module Nexosis exposing (ClientConfig, createConfigWithApiKey, createConfigWithApiKeyOptions, createConfigWithToken, createConfigWithTokenOptions, getBaseUrl, withAppHeader, withAuthorization)

{-| Api Client for use with the [Nexosis Machine Learning Api](https://nexosis.com/). This package provides all of the Api endpoints and types for the request parameters
and response results.


# Configuration

In order to make calls to the Api, you will need an Api key, which you will find on your [Nexosis account](https://account.nexosis.com).

@docs createConfigWithApiKey, ClientConfig


# Advanced Configuration

Provides some more advanced config options, but these will not be needed for most cases.

@docs createConfigWithToken, createConfigWithApiKeyOptions, createConfigWithTokenOptions


# Helpers

These are helpers mostly used within this package, and will probably not need to be used outside of it.

@docs getBaseUrl, withAuthorization, withAppHeader

-}

import HttpBuilder exposing (RequestBuilder, withBearerToken, withHeader)


{-| Type that holds configuration information that is required to call the Api. This should be carried around on in your model.
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


{-| Create a [`ClientConfig`](#ClientConfig) using only an Api key. Your Api key can be found on your [Nexosis account](https://account.nexosis.com).
-}
createConfigWithApiKey : String -> ClientConfig
createConfigWithApiKey apiKey =
    ClientConfig
        { apiAccess = ApiKey (Key apiKey)
        , baseUrl = "https://ml.nexosis.com/v1"
        , applicationName = Nothing
        }


{-| Create a [`ClientConfig`](#ClientConfig) using only an Access Token.
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


{-| Create a config with an Api key, specifying all available options.
-}
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


{-| Gets the base url that requests will be sent to.
-}
getBaseUrl : ClientConfig -> String
getBaseUrl (ClientConfig config) =
    config.baseUrl


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
