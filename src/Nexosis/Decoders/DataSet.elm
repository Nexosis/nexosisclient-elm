module Nexosis.Decoders.DataSet exposing (dataSetNameDecoder, decodeDataSetData, decodeDataSetList, decodeDataSetStats)

import Json.Decode as Decode exposing (Decoder, andThen, dict, fail, float, int, list, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Decoders.Columns exposing (decodeColumnMetadata, decodeColumnStatsDict)
import Nexosis.Decoders.Data exposing (decodeData)
import Nexosis.Decoders.Date exposing (decodeDate)
import Nexosis.Types.DataSet exposing (DataSet, DataSetData, DataSetList, DataSetName, DataSetStats, toDataSetName)


dataSetNameDecoder : Decoder DataSetName
dataSetNameDecoder =
    string
        |> Decode.map toDataSetName


decodeDataSetList : Decoder DataSetList
decodeDataSetList =
    decode DataSetList
        |> required "items" (Decode.list decodeDataSet)
        |> required "pageNumber" Decode.int
        |> required "totalPages" Decode.int
        |> required "pageSize" Decode.int
        |> required "totalCount" Decode.int


decodeDataSet : Decoder DataSet
decodeDataSet =
    decode DataSet
        |> required "dataSetName" dataSetNameDecoder
        |> optional "dataSetSize" Decode.int 0
        |> required "isTimeSeries" Decode.bool
        |> required "dateCreated" decodeDate
        |> required "lastModified" decodeDate
        |> optional "rowCount" Decode.int 0
        |> required "columnCount" Decode.int


decodeDataSetData : Decoder DataSetData
decodeDataSetData =
    decode DataSetData
        |> required "dataSetName" dataSetNameDecoder
        |> optional "dataSetSize" Decode.int 0
        |> required "isTimeSeries" Decode.bool
        |> required "columns" decodeColumnMetadata
        |> required "data" decodeData
        |> required "pageNumber" Decode.int
        |> required "totalPages" Decode.int
        |> required "pageSize" Decode.int
        |> required "totalCount" Decode.int
        |> required "dateCreated" decodeDate
        |> required "lastModified" decodeDate
        |> optional "rowCount" Decode.int 0


decodeDataSetStats : Decoder DataSetStats
decodeDataSetStats =
    decode DataSetStats
        |> required "dataSetName" string
        |> required "columns" decodeColumnStatsDict
