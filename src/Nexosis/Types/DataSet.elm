module Nexosis.Types.DataSet
    exposing
        ( DataSet
        , DataSetData
        , DataSetList
        , DataSetName
        , DataSetStats
        , dataSetNameToString
        , toDataSetName
        )

{-| Representations of DataSets. Used when interacting with the `/data` and `/imports` endpoints.

Refer to our [documentation on DataSets](https://docs.nexosis.com/guides/retrieving-data) for more information.

@docs DataSet, DataSetList, DataSetData, DataSetStats, DataSetName, toDataSetName, dataSetNameToString

-}

import Nexosis.Types.Columns exposing (ColumnMetadata, ColumnStatsDict)
import Nexosis.Types.Data exposing (Data)
import Time.ZonedDateTime exposing (ZonedDateTime)


{-| Returned from the `/data/{dataSetName}` endpoint called by [Nexosis.Api.Data.getRetrieveDetail](Nexosis.Api.Data#getRetrieveDetail)
Details of the `Dataset`, a List of data, and paging information for the data.
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


{-| Returned from `/data` endpoint called by [Nexosis.Api.Data.get](Nexosis.Api.Data#get)
A List of [DataSet](#DataSet), with paging information.
-}
type alias DataSetList =
    { items : List DataSet
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


{-| Summary information about a `DataSet`, returned within a [`DataSetList`](#DataSetList).
-}
type alias DataSet =
    { dataSetName : DataSetName
    , dataSetSize : Int
    , isTimeSeries : Bool
    , dateCreated : ZonedDateTime
    , lastModified : ZonedDateTime
    , rowCount : Int
    , columnCount : Int
    }


{-| Stats about a [`DataSet`](#DataSet). Returned from `/data/stats` endpoint called by [`Nexosis.Api.Data.getStats`](Nexosis.Api.Data#getStats)
-}
type alias DataSetStats =
    { dataSetName : String
    , columns : ColumnStatsDict
    }


{-| `DataSetName` is an opaque type, used to differentiate if from a normal string. Use [`toDataSetName`](#toDataSetName) and [`dataSetNameToString`](#dataSetNameToString) to wrap and unwrap if needed.
-}
type DataSetName
    = DataSetName String


{-| -}
toDataSetName : String -> DataSetName
toDataSetName input =
    DataSetName input


{-| -}
dataSetNameToString : DataSetName -> String
dataSetNameToString (DataSetName name) =
    name
