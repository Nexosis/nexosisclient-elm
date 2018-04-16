module Nexosis.Types.Columns exposing (ColumnMetadata, ColumnStats, ColumnStatsDict, DataType(..), DistributionShape(..), Role(..))

{-| Columns can be configured on the `DataSet` or at session submission time, which tell the machine learning algorithms how to process the data.

Refer to the docs for more information about [ColumnMetadata](https://docs.nexosis.com/guides/column-metadata).

@docs ColumnMetadata, DataType, Role


# Stats

@docs ColumnStatsDict, ColumnStats, DistributionShape

-}

import Dict exposing (Dict)
import Nexosis.Types.AggregationStrategy exposing (AggregationStrategy)
import Nexosis.Types.ImputationStrategy exposing (ImputationStrategy)
import Time.ZonedDateTime exposing (ZonedDateTime)


{-| -}
type alias ColumnMetadata =
    { dataType : DataType
    , role : Role
    , imputation : ImputationStrategy
    , aggregation : AggregationStrategy
    , name : String
    }


{-| Stats that have been calculated for a `Column` on a `DataSet`. Some types are represented as `String` as
different a `DataType` can return that value in a different format.
-}
type alias ColumnStats =
    { distinctCount : Int
    , distribution : List DistributionShape
    , errorCount : Int
    , lastCalculated : ZonedDateTime
    , max : String
    , mean : Float
    , median : Float
    , min : String
    , missingCount : Int
    , mode : String
    , stddev : Float
    , suggestedType : String
    , totalCount : Int
    , variance : Float
    }


{-| A `Dict` of stats
-}
type alias ColumnStatsDict =
    Dict String ColumnStats


{-| A distribution is calculated for a column, and could be either bucketed `Counts` of values, or `Ranges`.
-}
type DistributionShape
    = Counts String Int
    | Ranges String String Int


{-| The `DataType` of the data in this column. This determines how the machine learning algorithms will process the data.
-}
type DataType
    = Measure
    | String
    | Numeric
    | Logical
    | Date
    | Text


{-| The `Role` of the column. `Features` will be used by the machine learning algorithms in calculations,
one column should be designated as the `Target`, which is what the algorithms will try to predict. `None` will
exclude the column from the dataset. `Timestamp` and `Key` are used as unique identifiers for the row of data.
-}
type Role
    = None
    | Timestamp
    | Target
    | Feature
    | Key
