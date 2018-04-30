module Nexosis.Api.Messages exposing (get)

{-| This endpoint returns static information about the metrics that the Api will calculate.
This is really just to provide up to date text descriptions and names for metrics that may be shown to a user.

@docs get

-}

import Http
import HttpBuilder exposing (withExpectJson)
import Json.Decode exposing (Decoder, field, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Nexosis exposing (ClientConfig, getBaseUrl)
import NexosisHelpers exposing (addHeaders)
import Nexosis.Decoders.Message exposing (decodeMessageList)
import Nexosis.Types.Message exposing (Message)


{-| GET a list of `Messages` based on a query
-}
get : ClientConfig -> Int -> Int -> Http.Request MessageList
get config page pageSize =
    let
        params =
            pageParams page pageSize
    in
        (getBaseUrl config ++ "/messages")
            |> HttpBuilder.get
            |> withExpectJson decodeMessageList
            |> addHeaders config
            |> HttpBuilder.toRequest
