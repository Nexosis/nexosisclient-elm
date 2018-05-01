module Nexosis.Api.Messages exposing (MessageQuery, get)

{-| This endpoint returns messages based on the query parameters. All messages on an organization or related to a specific session or import can be queried.

@docs get

-}

import Http
import HttpBuilder exposing (withExpectJson)
import List
import Nexosis exposing (ClientConfig, getBaseUrl)
import Nexosis.Decoders.Message exposing (decodeMessageList)
import Nexosis.Types.Message exposing (MessageList, Severity)
import NexosisHelpers exposing (addHeaders, pageParams)


{-| Parameters used to perform the GET `Message`s query.
-}
type alias MessageQuery =
    { relatedId : Maybe String
    , levels : Maybe (List Severity)
    , page : Int
    , pageSize : Int
    }


{-| GET a list of `Message`s based on a query
-}
get : ClientConfig -> MessageQuery -> Http.Request MessageList
get config query =
    let
        encodeSeverity levels =
            levels |> List.map (\l -> toString l |> String.toLower) |> String.join ","

        params =
            (case ( query.relatedId, query.levels ) of
                ( Just id, Just lvl ) ->
                    [ ( "relatedId", id ), ( "levels", encodeSeverity lvl ) ]

                ( Nothing, Just lvl ) ->
                    [ ( "levels", encodeSeverity lvl ) ]

                ( Just id, Nothing ) ->
                    [ ( "relatedId", id ) ]

                ( Nothing, Nothing ) ->
                    []
            )
                ++ pageParams query.page query.pageSize
    in
    (getBaseUrl config ++ "/messages")
        |> HttpBuilder.get
        |> withExpectJson decodeMessageList
        |> addHeaders config
        |> HttpBuilder.withQueryParams params
        |> HttpBuilder.toRequest
