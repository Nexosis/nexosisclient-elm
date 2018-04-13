module Nexosis.Types.Session exposing (ResultInterval(..), SessionData, SessionList, SessionResults)

import Dict exposing (Dict)
import Nexosis.Types.Algorithm exposing (..)
import Nexosis.Types.Columns exposing (ColumnMetadata)
import Nexosis.Types.Link exposing (..)
import Nexosis.Types.Message exposing (..)
import Nexosis.Types.PredictionDomain exposing (..)
import Nexosis.Types.Status exposing (HistoryRecord, Status)
import Time.ZonedDateTime exposing (ZonedDateTime)


type alias SessionData =
    { sessionId : String
    , status : Status
    , predictionDomain : PredictionDomain
    , columns : List ColumnMetadata
    , availablePredictionIntervals : List String
    , startDate : Maybe String
    , endDate : Maybe String
    , resultInterval : Maybe ResultInterval
    , requestedDate : ZonedDateTime
    , statusHistory : List HistoryRecord
    , extraParameters : Dict String String
    , messages : List Message
    , name : String
    , dataSourceName : String
    , targetColumn : Maybe String
    , links : List Link
    , modelId : Maybe String
    , algorithm : Maybe Algorithm
    }


type alias SessionResults =
    { metrics : Dict String Float
    , data : List (Dict String String)
    }


type alias SessionList =
    { items : List SessionData
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


type ResultInterval
    = Hour
    | Day
    | Week
    | Month
    | Year
