module Nexosis.Decoders.DistanceMetric exposing (decodeDistanceMetrics)

import Json.Decode exposing (Decoder, dict, int, list, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Decoders.Data exposing (decodeData)
import Nexosis.Types.DistanceMetric exposing (DistanceMetrics, DistanceValue)


decodeDistanceMetrics : Decoder DistanceMetrics
decodeDistanceMetrics =
    decode DistanceMetrics
        |> required "dataSourceName" string
        |> required "modelId" string
        |> required "sessionId" string
        |> required "name" string
        |> required "data" decodeData
        |> required "pageNumber" int
        |> required "pageSize" int
        |> required "totalCount" int
        |> required "totalPages" int
