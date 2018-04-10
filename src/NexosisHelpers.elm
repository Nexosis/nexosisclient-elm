module NexosisHelpers exposing (addHeaders)

{-| Helpers - Will become private to the package.

@docs addHeaders

-}

import HttpBuilder exposing (RequestBuilder)
import Nexosis exposing (ClientConfig, withAppHeader, withAuthorization)


{-| Helper for adding all the needed headers
-}
addHeaders : ClientConfig -> RequestBuilder a -> RequestBuilder a
addHeaders clientConfig builder =
    builder |> withAppHeader clientConfig |> withAuthorization clientConfig
