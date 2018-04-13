module Nexosis.Api.Data exposing (MetadataUpdateRequest, createDataSetWithKey, delete, get, getDataByDateRange, getRetrieveDetail, getStats, getStatsForColumn, put, updateMetadata)

import Http
import HttpBuilder
import Json.Encode
import Nexosis exposing (ClientConfig, getBaseUrl)
import Nexosis.Decoders.DataSet exposing (decodeDataSetData, decodeDataSetList, decodeDataSetStats)
import Nexosis.Encoders.Columns exposing (encodeColumnMetadataList, encodeKeyColumnMetadata)
import Nexosis.Types.Columns exposing (ColumnMetadata, DataType(..))
import Nexosis.Types.DataSet exposing (DataSetData, DataSetList, DataSetName, DataSetStats, dataSetNameToString)
import Nexosis.Types.SortParameters exposing (SortDirection(..), SortParameters)
import NexosisHelpers exposing (addHeaders, sortParams)
import Set


type alias MetadataUpdateRequest =
    { dataSetName : DataSetName
    , columns : List ColumnMetadata
    }


get : ClientConfig -> Int -> Int -> SortParameters -> Http.Request DataSetList
get config page pageSize sorting =
    let
        params =
            pageParams page pageSize
                ++ sortParams sorting
    in
    (getBaseUrl config ++ "/data")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeDataSetList
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


getRetrieveDetail : ClientConfig -> DataSetName -> Int -> Int -> Http.Request DataSetData
getRetrieveDetail config name pgNum pgSize =
    let
        params =
            pageParams pgNum pgSize
    in
    (getBaseUrl config ++ "/data/" ++ uriEncodeDataSetName name)
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeDataSetData
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


getDataByDateRange : ClientConfig -> DataSetName -> Maybe ( String, String ) -> List String -> Http.Request DataSetData
getDataByDateRange config name dateRange include =
    let
        params =
            pageParams 0 1000
                ++ dateParams dateRange
                ++ includeParams include
                ++ [ ( "formatDates", "true" ) ]
    in
    (getBaseUrl config ++ "/data/" ++ uriEncodeDataSetName name)
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeDataSetData
        |> HttpBuilder.withQueryParams params
        |> addHeaders config
        |> HttpBuilder.toRequest


getStats : ClientConfig -> DataSetName -> Http.Request DataSetStats
getStats config name =
    (getBaseUrl config ++ "/data/" ++ uriEncodeDataSetName name ++ "/stats")
        |> HttpBuilder.get
        |> HttpBuilder.withExpectJson decodeDataSetStats
        |> addHeaders config
        |> HttpBuilder.toRequest


getStatsForColumn : ClientConfig -> DataSetName -> String -> DataType -> Http.Request DataSetStats
getStatsForColumn config dataSetName columnName columnType =
    (getBaseUrl config ++ "/data/" ++ uriEncodeDataSetName dataSetName ++ "/stats/" ++ Http.encodeUri columnName)
        |> HttpBuilder.get
        |> HttpBuilder.withQueryParams [ ( "dataType", dataTypeToString columnType ) ]
        |> HttpBuilder.withExpectJson decodeDataSetStats
        |> addHeaders config
        |> HttpBuilder.toRequest


delete : ClientConfig -> DataSetName -> Set.Set String -> Http.Request ()
delete config name cascadeOptions =
    let
        cascadeList =
            Set.toList cascadeOptions
                |> List.map (\c -> ( "cascade", c ))
    in
    (getBaseUrl config ++ "/data/" ++ uriEncodeDataSetName name)
        |> HttpBuilder.delete
        |> HttpBuilder.withQueryParams cascadeList
        |> addHeaders config
        |> HttpBuilder.toRequest


put : ClientConfig -> String -> String -> String -> Http.Request ()
put config name content contentType =
    (getBaseUrl config ++ "/data/" ++ Http.encodeUri name)
        |> HttpBuilder.put
        |> HttpBuilder.withBody (Http.stringBody contentType content)
        |> addHeaders config
        |> HttpBuilder.toRequest


pageParams : Int -> Int -> List ( String, String )
pageParams page pageSize =
    [ ( "page", page |> toString )
    , ( "pageSize", pageSize |> toString )
    ]


dateParams : Maybe ( String, String ) -> List ( String, String )
dateParams dateRange =
    case dateRange of
        Just dates ->
            [ ( "startDate", Tuple.first dates ), ( "endDate", Tuple.second dates ) ]

        Nothing ->
            []


includeParams : List String -> List ( String, String )
includeParams includes =
    includes |> List.map (\value -> ( "include", value ))


updateMetadata : ClientConfig -> MetadataUpdateRequest -> Http.Request ()
updateMetadata config request =
    (getBaseUrl config ++ "/data/" ++ uriEncodeDataSetName request.dataSetName)
        |> HttpBuilder.put
        |> addHeaders config
        |> HttpBuilder.withJsonBody (encodeMetadataPutDataRequest request)
        |> HttpBuilder.toRequest


encodeMetadataPutDataRequest : MetadataUpdateRequest -> Json.Encode.Value
encodeMetadataPutDataRequest request =
    Json.Encode.object
        [ ( "dataSetName", Json.Encode.string <| dataSetNameToString request.dataSetName )
        , ( "columns", encodeColumnMetadataList <| request.columns )
        ]


uriEncodeDataSetName : DataSetName -> String
uriEncodeDataSetName name =
    Http.encodeUri <| dataSetNameToString name


createDataSetWithKey : ClientConfig -> String -> String -> Http.Request ()
createDataSetWithKey config dataSetName keyName =
    let
        keyBody =
            Json.Encode.object [ ( "columns", encodeKeyColumnMetadata keyName ) ]
    in
    (getBaseUrl config ++ "/data/" ++ Http.encodeUri dataSetName)
        |> HttpBuilder.put
        |> addHeaders config
        |> HttpBuilder.withJsonBody keyBody
        |> HttpBuilder.toRequest


dataTypeToString : DataType -> String
dataTypeToString dataType =
    if dataType == Measure then
        "numericMeasure"
    else
        toString dataType
