module Nexosis.Api.Metrics exposing (Metric, get)

{-| This endpoint returns static information about the metrics that the Api will calculate.
This is really just to provide up to date text descriptions and names for metrics that may be shown to a user.

@docs get, Metric

-}

import Http
import HttpBuilder exposing (withExpectJson)
import Json.Decode exposing (Decoder, field, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Nexosis exposing (ClientConfig, getBaseUrl)
import NexosisHelpers exposing (addHeaders)


{-| Metrics information.
-}
type alias Metric =
    { key : String
    , name : String
    , description : String
    }


{-| GET a list of `Metric` definitions that are reported by the Api.
-}
get : ClientConfig -> Http.Request (List Metric)
get config =
    (getBaseUrl config ++ "/metrics")
        |> HttpBuilder.get
        |> withExpectJson decodeMetricList
        |> addHeaders config
        |> HttpBuilder.toRequest


decodeMetricList : Decoder (List Metric)
decodeMetricList =
    field "metrics" (list decodeMetric)


decodeMetric : Decoder Metric
decodeMetric =
    decode Metric
        |> required "key" string
        |> required "name" string
        |> required "description" string
