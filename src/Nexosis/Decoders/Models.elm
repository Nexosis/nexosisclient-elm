module Nexosis.Decoders.Models exposing (decodeModel, decodeModelList, decodePredictions)

import Json.Decode as Decode exposing (Decoder, float, list, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Decoders.Algorithm exposing (decodeAlgorithm)
import Nexosis.Decoders.Columns exposing (decodeColumnMetadata)
import Nexosis.Decoders.Data exposing (decodeData)
import Nexosis.Decoders.Date exposing (decodeDate)
import Nexosis.Decoders.Link exposing (decodeLink)
import Nexosis.Decoders.Message exposing (decodeMessage)
import Nexosis.Decoders.PredictionDomain exposing (decodePredictionDomain)
import Nexosis.Types.Model exposing (ModelData, ModelList, PredictionResult)


decodeModelList : Decoder ModelList
decodeModelList =
    decode ModelList
        |> required "items" (Decode.list decodeModel)
        |> required "pageNumber" Decode.int
        |> required "totalPages" Decode.int
        |> required "pageSize" Decode.int
        |> required "totalCount" Decode.int


decodeModel : Decoder ModelData
decodeModel =
    decode ModelData
        |> required "modelId" Decode.string
        |> required "sessionId" Decode.string
        |> required "predictionDomain" decodePredictionDomain
        |> required "dataSourceName" Decode.string
        |> required "columns" decodeColumnMetadata
        |> required "createdDate" decodeDate
        |> required "algorithm" decodeAlgorithm
        |> optional "modelName" (Decode.map Just string) Nothing
        |> optional "lastUsedDate" (Decode.map Just decodeDate) Nothing
        |> required "metrics" (Decode.dict float)
        |> required "links" (Decode.list decodeLink)


decodePredictions : Decoder PredictionResult
decodePredictions =
    decode PredictionResult
        |> required "data" decodeData
        |> required "messages" (list decodeMessage)
