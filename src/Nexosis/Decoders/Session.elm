module Nexosis.Decoders.Session exposing (decodeSession, decodeSessionList, decodeSessionResults)

import Json.Decode as Decode exposing (Decoder, andThen, fail, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Decoders.Algorithm exposing (decodeAlgorithm)
import Nexosis.Decoders.Columns exposing (decodeColumnMetadata)
import Nexosis.Decoders.Data exposing (decodeData)
import Nexosis.Decoders.Date exposing (decodeDate)
import Nexosis.Decoders.Link exposing (decodeLink)
import Nexosis.Decoders.Message exposing (decodeObjectMessage)
import Nexosis.Decoders.PredictionDomain exposing (decodePredictionDomain)
import Nexosis.Decoders.Status exposing (decodeHistoryRecord, decodeStatus)
import Nexosis.Types.Session exposing (ResultInterval(..), SessionData, SessionList, SessionResults)


decodeSessionResults : Decode.Decoder SessionResults
decodeSessionResults =
    decode SessionResults
        |> required "metrics" (Decode.dict Decode.float)
        |> required "data" decodeData


decodeSession : Decode.Decoder SessionData
decodeSession =
    Json.Decode.Pipeline.decode SessionData
        |> required "sessionId" Decode.string
        |> required "status" decodeStatus
        |> required "predictionDomain" decodePredictionDomain
        |> required "columns" decodeColumnMetadata
        |> required "availablePredictionIntervals" (Decode.list Decode.string)
        |> optional "startDate" (Decode.map Just string) Nothing
        |> optional "endDate" (Decode.map Just string) Nothing
        |> optional "resultInterval" (Decode.map Just decodeResultInterval) Nothing
        |> required "requestedDate" decodeDate
        |> required "statusHistory" (Decode.list decodeHistoryRecord)
        |> required "extraParameters" (Decode.dict (Decode.oneOf [ Decode.string, Decode.bool |> Decode.andThen (\b -> succeed (toString b)) ]))
        |> required "messages" (Decode.list decodeObjectMessage)
        |> required "name" Decode.string
        |> required "dataSourceName" Decode.string
        |> optional "targetColumn" (Decode.map Just string) Nothing
        |> required "links" (Decode.list decodeLink)
        |> optional "modelId" (Decode.map Just string) Nothing
        |> optional "algorithm" (Decode.map Just decodeAlgorithm) Nothing
        |> optional "approximateCompletionPercentage" Decode.int 0


decodeSessionList : Decoder SessionList
decodeSessionList =
    decode SessionList
        |> required "items" (Decode.list decodeSession)
        |> required "pageNumber" Decode.int
        |> required "totalPages" Decode.int
        |> required "pageSize" Decode.int
        |> required "totalCount" Decode.int


decodeResultInterval : Decoder ResultInterval
decodeResultInterval =
    string
        |> andThen
            (\r ->
                case r of
                    "hour" ->
                        succeed Hour

                    "day" ->
                        succeed Day

                    "week" ->
                        succeed Week

                    "month" ->
                        succeed Month

                    "year" ->
                        succeed Year

                    unknown ->
                        fail <| "Unknown result interval: " ++ unknown
            )
