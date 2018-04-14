module NexosisHelpers exposing (addHeaders, sortParams, withAppHeader, withAuthorization)

import HttpBuilder exposing (RequestBuilder, withBearerToken, withHeader)
import Nexosis exposing (ClientConfig, withAppHeader, withAuthorization)
import Nexosis.Types.SortParameters exposing (SortDirection(..), SortParameters)


addHeaders : ClientConfig -> RequestBuilder a -> RequestBuilder a
addHeaders clientConfig builder =
    builder |> withAppHeader clientConfig |> withAuthorization clientConfig


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


{-| Adds auth headers to an HttpBuilder pipeline
-}
withAuthorization : ClientConfig -> RequestBuilder a -> RequestBuilder a
withAuthorization (ClientConfig config) builder =
    case config.apiAccess of
        AccessToken (Token token) ->
            builder |> withBearerToken token

        ApiKey (Key key) ->
            builder |> withHeader "api-key" key


{-| Adds an application-name header, to help us distinguish where api calls are coming from
-}
withAppHeader : ClientConfig -> RequestBuilder a -> RequestBuilder a
withAppHeader (ClientConfig config) builder =
    case config.applicationName of
        Just name ->
            builder
                |> withHeader "application-name" name

        Nothing ->
            builder
                |> withHeader "application-name" "nexosisclient-elm"
