module Nexosis exposing (ClientConfig, createConfigWithToken, createConfigWithTokenOptions, getBaseUrl, withAppHeader, withAuthorization)

{-| Nexosis Api Client

@docs ClientConfig, createConfigWithToken, withAuthorization, createConfigWithTokenOptions, withAppHeader, getBaseUrl

-}

import HttpBuilder exposing (RequestBuilder, withBearerToken, withHeader)


{-| Creds and url.
-}
type ClientConfig
    = ClientConfig
        { apiAccess : ApiAccess
        , baseUrl : String
        , applicationName : Maybe String
        }


type ApiAccess
    = AccessToken Token
    | ApiKey Key


type Token
    = Token String


type Key
    = Key String


createConfigWithApiKey : String -> ClientConfig
createConfigWithApiKey apiKey =
    ClientConfig
        { apiAccess = ApiKey (Key apiKey)
        , baseUrl = "https://ml.nexosis.com/v1"
        , applicationName = Nothing
        }


{-| Builds a config from a url and a token
-}
createConfigWithToken : String -> ClientConfig
createConfigWithToken token =
    ClientConfig
        { apiAccess = AccessToken (Token token)
        , baseUrl = "https://ml.nexosis.com/v2"
        , applicationName = Nothing
        }


{-| Create a config with token authorization, specifying all available options.
-}
createConfigWithTokenOptions :
    { token : String
    , baseUrl : String
    , applicationName : Maybe String
    }
    -> ClientConfig
createConfigWithTokenOptions { token, baseUrl, applicationName } =
    ClientConfig
        { apiAccess = AccessToken (Token token)
        , baseUrl = baseUrl
        , applicationName = applicationName
        }


createConfigWithApiKeyOptions :
    { apiKey : String
    , baseUrl : String
    , applicationName : Maybe String
    }
    -> ClientConfig
createConfigWithApiKeyOptions { apiKey, baseUrl, applicationName } =
    ClientConfig
        { apiAccess = ApiKey (Key apiKey)
        , baseUrl = baseUrl
        , applicationName = applicationName
        }


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


{-| Gets the base url that requests will be sent to
-}
getBaseUrl : ClientConfig -> String
getBaseUrl (ClientConfig config) =
    config.baseUrl
