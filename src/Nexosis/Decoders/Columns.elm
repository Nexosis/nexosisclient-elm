module Nexosis.Decoders.Columns exposing (decodeColumnMetadata, decodeColumnStatsDict, distributionDecoder)

import Json.Decode as Decode exposing (Decoder, andThen, dict, fail, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Decoders.Date exposing (decodeDate)
import Nexosis.Types.AggregationStrategy as Aggregate exposing (AggregationStrategy)
import Nexosis.Types.Columns exposing (ColumnMetadata, ColumnStats, ColumnStatsDict, DataType(..), DistributionShape(..), Role(..))
import Nexosis.Types.ImputationStrategy as Impute exposing (ImputationStrategy)


decodeColumnMetadata : Decoder (List ColumnMetadata)
decodeColumnMetadata =
    decode ColumnMetadata
        |> optional "dataType" decodeDataType String
        |> optional "role" decodeRole None
        |> optional "imputation" decodeImputation Impute.Mean
        |> optional "aggregation" decodeAggregation Aggregate.Mean
        |> Decode.keyValuePairs
        |> Decode.map (\a -> List.map (uncurry (|>)) a)


decodeDataType : Decoder DataType
decodeDataType =
    string
        |> andThen
            (\columnType ->
                case String.toLower columnType of
                    "numericmeasure" ->
                        succeed Measure

                    "string" ->
                        succeed String

                    "numeric" ->
                        succeed Numeric

                    "logical" ->
                        succeed Logical

                    "date" ->
                        succeed Date

                    "text" ->
                        succeed Text

                    unknown ->
                        fail <| "Unknown columnType: " ++ unknown
            )


decodeRole : Decoder Role
decodeRole =
    string
        |> andThen
            (\role ->
                case String.toLower role of
                    "none" ->
                        succeed None

                    "timestamp" ->
                        succeed Timestamp

                    "target" ->
                        succeed Target

                    "feature" ->
                        succeed Feature

                    "key" ->
                        succeed Key

                    unknown ->
                        fail <| "Unknown column role: " ++ unknown
            )


decodeImputation : Decoder ImputationStrategy
decodeImputation =
    string
        |> andThen
            (\imputation ->
                case String.toLower imputation of
                    "zeroes" ->
                        succeed Impute.Zeroes

                    "mean" ->
                        succeed Impute.Mean

                    "median" ->
                        succeed Impute.Median

                    "mode" ->
                        succeed Impute.Mode

                    "min" ->
                        succeed Impute.Min

                    "max" ->
                        succeed Impute.Max

                    unknown ->
                        fail <| "Unknown imputation strategy: " ++ unknown
            )


decodeAggregation : Decoder AggregationStrategy
decodeAggregation =
    string
        |> andThen
            (\aggregation ->
                case String.toLower aggregation of
                    "sum" ->
                        succeed Aggregate.Sum

                    "mean" ->
                        succeed Aggregate.Mean

                    "median" ->
                        succeed Aggregate.Median

                    "mode" ->
                        succeed Aggregate.Mode

                    "min" ->
                        succeed Aggregate.Min

                    "max" ->
                        succeed Aggregate.Max

                    unknown ->
                        fail <| "Unknown aggregation strategy: " ++ unknown
            )


decodeColumnStats : Decoder ColumnStats
decodeColumnStats =
    decode ColumnStats
        |> optional "distinctCount" int 0
        |> optional "distribution" distributionDecoder []
        |> optional "errorCount" int 0
        |> required "lastCalculated" decodeDate
        |> optional "max" variableDecoder ""
        |> optional "mean" float 0
        |> optional "median" float 0
        |> optional "min" variableDecoder ""
        |> optional "missingCount" int 0
        |> optional "mode" variableDecoder ""
        |> optional "stddev" float 0
        |> optional "suggestedType" string "numericMeasure"
        |> required "totalCount" int
        |> optional "variance" float 0


distributionDecoder : Decoder (List DistributionShape)
distributionDecoder =
    list decodeDistributionItem


decodeColumnStatsDict : Decoder ColumnStatsDict
decodeColumnStatsDict =
    dict decodeColumnStats


decodeDistributionItem : Decoder DistributionShape
decodeDistributionItem =
    Decode.oneOf
        [ decodeRange
        , decodeCount
        ]


decodeCount : Decoder DistributionShape
decodeCount =
    decode Counts
        |> required "value" numberOrStringDecoder
        |> required "count" int


decodeRange : Decoder DistributionShape
decodeRange =
    decode Ranges
        |> required "min" numberOrStringDecoder
        |> required "max" numberOrStringDecoder
        |> required "count" int


variableDecoder : Decoder String
variableDecoder =
    Decode.oneOf
        [ Decode.float |> Decode.andThen (\f -> succeed (toString f))
        , Decode.bool |> Decode.andThen (\b -> succeed (toString b))
        , Decode.string
        ]


numberOrStringDecoder : Decoder String
numberOrStringDecoder =
    Decode.oneOf
        [ Decode.int |> Decode.andThen (\i -> toString i |> succeed)
        , Decode.float |> Decode.andThen (\f -> toString f |> succeed)
        , Decode.string
        ]
