module Nexosis.Types.Columns exposing (ColumnMetadata, ColumnStats, ColumnStatsDict, DataType(..), DistributionShape(..), Role(..))

import Dict exposing (Dict)
import Nexosis.Types.AggregationStrategy exposing (AggregationStrategy)
import Nexosis.Types.ImputationStrategy exposing (ImputationStrategy)
import Time.ZonedDateTime exposing (ZonedDateTime)


type alias ColumnMetadata =
    { dataType : DataType
    , role : Role
    , imputation : ImputationStrategy
    , aggregation : AggregationStrategy
    , name : String
    }


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


type alias ColumnStatsDict =
    Dict String ColumnStats


type DistributionShape
    = Counts String Int
    | Ranges String String Int


type DataType
    = Measure
    | String
    | Numeric
    | Logical
    | Date
    | Text


type Role
    = None
    | Timestamp
    | Target
    | Feature
    | Key
