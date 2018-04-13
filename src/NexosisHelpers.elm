module NexosisHelpers exposing (SortDirection(..), SortParameters, addHeaders, commaFormatInteger, formatFloatToString, sortParams)

{-| Helpers - Will become private to the package.

@docs addHeaders, SortDirection, SortParameters, sortParams, formatFloatToString, commaFormatInteger

-}

import HttpBuilder exposing (RequestBuilder)
import Nexosis exposing (ClientConfig, withAppHeader, withAuthorization)


{-| Helper for adding all the needed headers
-}
addHeaders : ClientConfig -> RequestBuilder a -> RequestBuilder a
addHeaders clientConfig builder =
    builder |> withAppHeader clientConfig |> withAuthorization clientConfig


{-| -}
type alias SortParameters =
    { sortName : String
    , direction : SortDirection
    }


{-| -}
type SortDirection
    = Ascending
    | Descending


{-| -}
sortParams : SortParameters -> List ( String, String )
sortParams { sortName, direction } =
    [ ( "sortBy", sortName )
    , ( "sortOrder"
      , if direction == Ascending then
            "asc"
        else
            "desc"
      )
    ]


{-| -}
formatFloatToString : Float -> String
formatFloatToString input =
    if not <| isActuallyInteger input then
        let
            expand =
                toString (ceiling (input * 100000))

            len =
                String.length expand

            filled =
                String.padLeft 5 '0' expand

            result =
                trimRightZeroes (String.left (len - 5) filled ++ "." ++ String.right 5 filled)
        in
        if String.left 1 result == "." then
            "0" ++ result
        else
            result
    else
        commaFormatInteger <| truncate input


{-| -}
trimRightZeroes : String -> String
trimRightZeroes input =
    let
        strings =
            String.split "." input

        left =
            Maybe.withDefault "" (List.head strings)

        right =
            Maybe.withDefault [] (List.tail strings)
    in
    if right == [ "" ] then
        left
    else
        case String.reverse input |> String.uncons of
            Just ( h, tl ) ->
                if h == '0' then
                    trimRightZeroes <| String.reverse tl
                else
                    input

            Nothing ->
                ""


{-| -}
isActuallyInteger : Float -> Bool
isActuallyInteger input =
    (input / 1.0 - (toFloat <| round input)) == 0


{-| -}
commaFormatInteger : Int -> String
commaFormatInteger value =
    String.join "," (splitThousands (toString value))


{-| -}
splitThousands : String -> List String
splitThousands integers =
    let
        reversedSplitThousands : String -> List String
        reversedSplitThousands value =
            if String.length value > 3 then
                value
                    |> String.dropRight 3
                    |> reversedSplitThousands
                    |> (::) (String.right 3 value)
            else
                [ value ]
    in
    integers
        |> reversedSplitThousands
        |> List.reverse
