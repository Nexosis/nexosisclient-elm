module Nexosis.Api.Models exposing (delete, get, getOne, predict, predictRaw)

import Http
import HttpBuilder exposing (RequestBuilder, withExpect)
import Nexosis exposing (ClientConfig, getBaseUrl)
import Nexosis.Decoders.Models exposing (decodeModel, decodeModelList, decodePredictions)
import Nexosis.Types.Models exposing (ModelData, ModelList, PredictionResult)
import NexosisHelpers exposing (SortParameters, addHeaders, sortParams)


get : ClientConfig -> Int -> Int -> SortParameters -> Http.Request ModelList
get config page pageSize sorting =
    let
        params =
            pageParams page pageSize
                ++ sortParams sorting
    in
    (getBaseUrl config ++ "/models")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeModelList
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


pageParams : Int -> Int -> List ( String, String )
pageParams page pageSize =
    [ ( "page", page |> toString )
    , ( "pageSize", pageSize |> toString )
    ]


delete : ClientConfig -> String -> Http.Request ()
delete config modelId =
    (getBaseUrl config ++ "/models/" ++ modelId)
        |> HttpBuilder.delete
        |> addHeaders config
        |> HttpBuilder.toRequest


getOne : ClientConfig -> String -> Http.Request ModelData
getOne config modelId =
    (getBaseUrl config ++ "/models/" ++ modelId)
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeModel
        |> addHeaders config
        |> HttpBuilder.toRequest


predict : ClientConfig -> String -> String -> String -> Http.Request PredictionResult
predict config modelId content contentType =
    (getBaseUrl config ++ "/models/" ++ modelId ++ "/predict")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody contentType content)
        |> addHeaders config
        |> HttpBuilder.withExpectJson decodePredictions
        |> HttpBuilder.toRequest


predictRaw : ClientConfig -> String -> String -> String -> String -> Http.Request String
predictRaw config modelId content contentType acceptType =
    (getBaseUrl config ++ "/models/" ++ modelId ++ "/predict")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody contentType content)
        |> HttpBuilder.withHeader "Accept" acceptType
        |> addHeaders config
        |> HttpBuilder.withExpectString
        |> HttpBuilder.toRequest
