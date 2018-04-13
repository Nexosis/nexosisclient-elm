module Nexosis.Api.Sessions exposing (ForecastSessionRequest, ImpactSessionRequest, ModelSessionRequest, delete, get, getConfusionMatrix, getDistanceMetrics, getDistanceMetricsCsv, getForDataset, getOne, postForecast, postImpact, postModel, results, resultsCsv)

import Http
import HttpBuilder
import Json.Encode as Encode
import Nexosis exposing (ClientConfig, getBaseUrl)
import Nexosis.Decoders.ConfusionMatrix exposing (decodeConfusionMatrix)
import Nexosis.Decoders.DistanceMetric exposing (decodeDistanceMetrics)
import Nexosis.Decoders.Session exposing (decodeSession, decodeSessionList, decodeSessionResults)
import Nexosis.Encoders.Columns exposing (encodeColumnMetadataList)
import Nexosis.Types.Columns exposing (ColumnMetadata)
import Nexosis.Types.ConfusionMatrix exposing (ConfusionMatrix)
import Nexosis.Types.DataSet exposing (DataSetName, dataSetNameToString)
import Nexosis.Types.DistanceMetric exposing (DistanceMetrics)
import Nexosis.Types.PredictionDomain exposing (PredictionDomain)
import Nexosis.Types.Session exposing (ResultInterval, SessionData, SessionList, SessionResults)
import Nexosis.Types.SortParameters exposing (SortParameters)
import NexosisHelpers exposing (addHeaders, sortParams)
import Time.ZonedDateTime exposing (ZonedDateTime, toISO8601)


get : ClientConfig -> Int -> Int -> SortParameters -> Http.Request SessionList
get config page pageSize sorting =
    let
        params =
            pageParams page pageSize
                ++ sortParams sorting
    in
    (getBaseUrl config ++ "/sessions")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeSessionList
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


results : ClientConfig -> String -> Int -> Int -> Http.Request SessionResults
results config sessionId page pageSize =
    let
        params =
            pageParams page pageSize
    in
    (getBaseUrl config ++ "/sessions/" ++ sessionId ++ "/results")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeSessionResults
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


resultsCsv : ClientConfig -> String -> Http.Request String
resultsCsv config sessionId =
    (getBaseUrl config ++ "/sessions/" ++ sessionId ++ "/results")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectString
        |> HttpBuilder.withHeader "Accept" "text/csv"
        |> HttpBuilder.withQueryParams [ ( "pageSize", "1000" ) ]
        |> addHeaders config
        |> HttpBuilder.toRequest


pageParams : Int -> Int -> List ( String, String )
pageParams page pageSize =
    [ ( "page", page |> toString )
    , ( "pageSize", pageSize |> toString )
    ]


getConfusionMatrix : ClientConfig -> String -> Int -> Int -> Http.Request ConfusionMatrix
getConfusionMatrix config sessionId page pageSize =
    let
        params =
            pageParams page pageSize
    in
    (getBaseUrl config ++ "/sessions/" ++ sessionId ++ "/results/confusionmatrix")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeConfusionMatrix
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


getForDataset : ClientConfig -> DataSetName -> Http.Request SessionList
getForDataset config dataSetName =
    let
        params =
            [ ( "dataSetName", dataSetNameToString dataSetName ) ]
    in
    (getBaseUrl config ++ "/sessions")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeSessionList
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


delete : ClientConfig -> String -> Http.Request ()
delete config sessionId =
    (getBaseUrl config ++ "/sessions/" ++ sessionId)
        |> HttpBuilder.delete
        |> addHeaders config
        |> HttpBuilder.toRequest


getOne : ClientConfig -> String -> Http.Request SessionData
getOne config sessionId =
    (getBaseUrl config ++ "/sessions/" ++ sessionId)
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeSession
        |> addHeaders config
        |> HttpBuilder.toRequest


type alias ModelSessionRequest =
    { name : Maybe String
    , dataSourceName : DataSetName
    , columns : List ColumnMetadata
    , predictionDomain : PredictionDomain
    , balance : Maybe Bool
    , containsAnomalies : Maybe Bool
    }


postModel : ClientConfig -> ModelSessionRequest -> Http.Request SessionData
postModel config sessionRequest =
    let
        requestBody =
            encodeModelSessionRequest sessionRequest
    in
    (getBaseUrl config ++ "/sessions/model")
        |> HttpBuilder.post
        |> HttpBuilder.withExpectJson decodeSession
        |> addHeaders config
        |> HttpBuilder.withJsonBody requestBody
        |> HttpBuilder.toRequest


encodeModelSessionRequest : ModelSessionRequest -> Encode.Value
encodeModelSessionRequest sessionRequest =
    Encode.object
        [ ( "dataSourceName", Encode.string <| dataSetNameToString <| sessionRequest.dataSourceName )
        , ( "name", encodeName sessionRequest.name )
        , ( "columns", encodeColumnMetadataList <| sessionRequest.columns )
        , ( "predictionDomain", Encode.string <| toString <| sessionRequest.predictionDomain )
        , ( "extraParameters", encodeExtraParameters <| sessionRequest )
        ]


type alias ForecastSessionRequest =
    { name : Maybe String
    , dataSourceName : DataSetName
    , columns : List ColumnMetadata
    , dates :
        { startDate : ZonedDateTime
        , endDate : ZonedDateTime
        }
    , resultInterval : ResultInterval
    }


postForecast : ClientConfig -> ForecastSessionRequest -> Http.Request SessionData
postForecast config sessionRequest =
    let
        requestBody =
            encodeForecastSessionRequest sessionRequest
    in
    (getBaseUrl config ++ "/sessions/forecast")
        |> HttpBuilder.post
        |> HttpBuilder.withExpectJson decodeSession
        |> addHeaders config
        |> HttpBuilder.withJsonBody requestBody
        |> HttpBuilder.toRequest


encodeForecastSessionRequest : ForecastSessionRequest -> Encode.Value
encodeForecastSessionRequest sessionRequest =
    Encode.object
        [ ( "dataSourceName", Encode.string <| dataSetNameToString <| sessionRequest.dataSourceName )
        , ( "name", encodeName sessionRequest.name )
        , ( "columns", encodeColumnMetadataList <| sessionRequest.columns )
        , ( "startDate", Encode.string <| toISO8601 <| sessionRequest.dates.startDate )
        , ( "endDate", Encode.string <| toISO8601 <| sessionRequest.dates.endDate )
        , ( "resultInterval", Encode.string <| toString <| sessionRequest.resultInterval )
        ]


type alias ImpactSessionRequest =
    { name : Maybe String
    , dataSourceName : DataSetName
    , columns : List ColumnMetadata
    , dates :
        { startDate : ZonedDateTime
        , endDate : ZonedDateTime
        }
    , eventName : String
    , resultInterval : ResultInterval
    }


postImpact : ClientConfig -> ImpactSessionRequest -> Http.Request SessionData
postImpact config sessionRequest =
    let
        requestBody =
            encodeImpactSessionRequest sessionRequest
    in
    (getBaseUrl config ++ "/sessions/impact")
        |> HttpBuilder.post
        |> HttpBuilder.withExpectJson decodeSession
        |> addHeaders config
        |> HttpBuilder.withJsonBody requestBody
        |> HttpBuilder.toRequest


encodeImpactSessionRequest : ImpactSessionRequest -> Encode.Value
encodeImpactSessionRequest sessionRequest =
    Encode.object
        [ ( "dataSourceName", Encode.string <| dataSetNameToString <| sessionRequest.dataSourceName )
        , ( "name", encodeName sessionRequest.name )
        , ( "columns", encodeColumnMetadataList <| sessionRequest.columns )
        , ( "startDate", Encode.string <| toISO8601 <| sessionRequest.dates.startDate )
        , ( "endDate", Encode.string <| toISO8601 <| sessionRequest.dates.endDate )
        , ( "eventName", Encode.string <| sessionRequest.eventName )
        , ( "resultInterval", Encode.string <| toString <| sessionRequest.resultInterval )
        ]


encodeName : Maybe String -> Encode.Value
encodeName name =
    name
        |> Maybe.map Encode.string
        |> Maybe.withDefault Encode.null


encodeExtraParameters : ModelSessionRequest -> Encode.Value
encodeExtraParameters sessionRequest =
    let
        balance =
            sessionRequest.balance
                |> Maybe.map Encode.bool
                |> Maybe.withDefault Encode.null

        anomalies =
            sessionRequest.containsAnomalies
                |> Maybe.map Encode.bool
                |> Maybe.withDefault Encode.null
    in
    Encode.object
        [ ( "balance", balance )
        , ( "containsAnomalies", anomalies )
        ]


getDistanceMetricsCsv : ClientConfig -> String -> Int -> Int -> Http.Request String
getDistanceMetricsCsv config sessionId page pageSize =
    let
        params =
            pageParams page pageSize
    in
    (getBaseUrl config ++ "/sessions/" ++ sessionId ++ "/results/mahalanobisdistances")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectString
        |> HttpBuilder.withHeader "Accept" "text/csv"
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


getDistanceMetrics : ClientConfig -> String -> Int -> Int -> Http.Request DistanceMetrics
getDistanceMetrics config sessionId page pageSize =
    let
        params =
            pageParams page pageSize
    in
    (getBaseUrl config ++ "/sessions/" ++ sessionId ++ "/results/mahalanobisdistances")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeDistanceMetrics
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest
