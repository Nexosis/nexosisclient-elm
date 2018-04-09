module Nexosis exposing (ClientConfig, createConfigWithToken, withAuthorization)

{-| Nexosis Api Client

@docs ClientConfig, createConfigWithToken, withAuthorization

-}

import HttpBuilder exposing (RequestBuilder, withBearerToken, withHeader)


{-| Creds and url.
-}
type alias ClientConfig =
    { apiAccess : ApiAccess
    , url : String
    }


type ApiAccess
    = AccessToken Token
    | ApiKey Key


type Token
    = Token String


type Key
    = Key String


{-| Builds a config from a url and a token
-}
createConfigWithToken : String -> String -> ClientConfig
createConfigWithToken url apiToken =
    { apiAccess = AccessToken (Token apiToken)
    , url = url
    }


{-| Adds auth headers to an HttpBuilder pipeline
-}
withAuthorization : ClientConfig -> RequestBuilder a -> RequestBuilder a
withAuthorization config builder =
    case config.apiAccess of
        AccessToken (Token token) ->
            builder |> withBearerToken token

        ApiKey (Key key) ->
            builder |> withHeader "api-key" key
