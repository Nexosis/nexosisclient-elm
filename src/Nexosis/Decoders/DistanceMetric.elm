module Nexosis.Decoders.DistanceMetric exposing (decodeDistanceMetrics)

import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (decode, required)
import Nexosis.Decoders.Data exposing (decodeData)
import Nexosis.Types.DistanceMetric exposing (DistanceMetrics)


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
