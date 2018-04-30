module Nexosis.Api.Models exposing (delete, get, getOne, predict, predictRaw)

{-| Functions for interacting with the `/models` endpoint.


## GET

Retrieve information about `Models` that have been created by a `Session`.

@docs get, getOne


## Predict

Upload new rows of data which to be predicted by the specified `Model`.

@docs predict, predictRaw


## DELETE

@docs delete

-}

import Http
import HttpBuilder
import Nexosis exposing (ClientConfig, getBaseUrl)
import Nexosis.Decoders.Models exposing (decodeModel, decodeModelList, decodePredictions)
import Nexosis.Types.Model exposing (ModelData, ModelList, PredictionResult)
import Nexosis.Types.SortParameters exposing (SortParameters)
import NexosisHelpers exposing (addHeaders, sortParams, pageParams)


{-| GET a listing of `Models`, with page limits and sorting information.
-}
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


{-| DELETE a single `Model`.
-}
delete : ClientConfig -> String -> Http.Request ()
delete config modelId =
    (getBaseUrl config ++ "/models/" ++ modelId)
        |> HttpBuilder.delete
        |> addHeaders config
        |> HttpBuilder.toRequest


{-| GET details about a single `Model`.
-}
getOne : ClientConfig -> String -> Http.Request ModelData
getOne config modelId =
    (getBaseUrl config ++ "/models/" ++ modelId)
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeModel
        |> addHeaders config
        |> HttpBuilder.toRequest


{-| POST data to predict. This should be the `Id` of a `Model`, the `String` content that should be predicted in CSV or JSON format, and the ContentType of the data, either `"text/csv"` or `"application/json"`.
-}
predict : ClientConfig -> String -> String -> String -> Http.Request PredictionResult
predict config modelId content contentType =
    (getBaseUrl config ++ "/models/" ++ modelId ++ "/predict")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody contentType content)
        |> addHeaders config
        |> HttpBuilder.withExpectJson decodePredictions
        |> HttpBuilder.toRequest


{-| Same as [`predict`](#predict), but with an additional parameter to specify the return format of the response, either `"text/csv"` or `"application/json"`.
-}
predictRaw : ClientConfig -> String -> String -> String -> String -> Http.Request String
predictRaw config modelId content contentType acceptType =
    (getBaseUrl config ++ "/models/" ++ modelId ++ "/predict")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody contentType content)
        |> HttpBuilder.withHeader "Accept" acceptType
        |> addHeaders config
        |> HttpBuilder.withExpectString
        |> HttpBuilder.toRequest
