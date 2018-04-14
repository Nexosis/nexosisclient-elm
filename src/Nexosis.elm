module Nexosis exposing (ClientConfig, createConfigWithToken, createConfigWithTokenOptions, getBaseUrl)

{-| Nexosis Api Client

Api Client for use with the [Nexosis Machine Learning Api](https://nexosis.com/). This package provides all of the Api endpoints and types for the request parameters
and response results.


# Configuration

In order to make calls to the Api, you will need an Api key, which you will find on your [Nexosis account](https://account.nexosis.com).

@docs createConfigWithApiKey, ClientConfig

#

@docs getBaseUrl

-}


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


{-| Gets the base url that requests will be sent to
-}
getBaseUrl : ClientConfig -> String
getBaseUrl (ClientConfig config) =
    config.baseUrl
