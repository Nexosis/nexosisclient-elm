module Nexosis.Types.DataSet
    exposing
        ( Data
        , DataSet
        , DataSetData
        , DataSetList
        , DataSetName
        , DataSetStats
        , dataSetNameToString
        , toDataSetName
        )

import Dict exposing (Dict)
import Nexosis.Types.Columns exposing (ColumnMetadata, ColumnStatsDict)
import Time.ZonedDateTime exposing (ZonedDateTime)


{-| Returned from /data/{dataSetName}
Details of the dataset, a List of data, and paging information for the data.
-}
type alias DataSetData =
    { dataSetName : DataSetName
    , dataSetSize : Int
    , isTimeSeries : Bool
    , columns : List ColumnMetadata
    , data : Data
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    , dateCreated : ZonedDateTime
    , lastModified : ZonedDateTime
    , rowCount : Int
    }


type alias DataSetList =
    { items : List DataSet
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


type alias DataSet =
    { dataSetName : DataSetName
    , dataSetSize : Int
    , isTimeSeries : Bool
    , dateCreated : ZonedDateTime
    , lastModified : ZonedDateTime
    , rowCount : Int
    , columnCount : Int
    }


type alias DataSetStats =
    { dataSetName : String
    , columns : ColumnStatsDict
    }


type DataSetName
    = DataSetName String


type alias Data =
    List (Dict String String)


toDataSetName : String -> DataSetName
toDataSetName input =
    DataSetName input


dataSetNameToString : DataSetName -> String
dataSetNameToString (DataSetName name) =
    name
