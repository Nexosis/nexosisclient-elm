module Nexosis.Api.Metrics exposing (Metric, get)

{-| Metrics

@docs get, Metric

-}

import Http
import HttpBuilder exposing (withExpectJson)
import Json.Decode exposing (Decoder, field, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Nexosis exposing (ClientConfig, getBaseUrl, withAppHeader, withAuthorization)


{-| Metrics type
-}
type alias Metric =
    { key : String
    , name : String
    , description : String
    }


{-| Get
-}
get : ClientConfig -> Http.Request (List Metric)
get config =
    (getBaseUrl config ++ "/metrics")
        |> HttpBuilder.get
        |> withExpectJson decodeMetricList
        |> withAuthorization config
        |> withAppHeader config
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
