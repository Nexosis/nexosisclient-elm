module Nexosis.Types.Model exposing (ModelData, ModelList, PredictionResult)

import Dict exposing (Dict)
import Nexosis.Types.Algorithm exposing (Algorithm)
import Nexosis.Types.Columns exposing (ColumnMetadata)
import Nexosis.Types.Link exposing (Link)
import Nexosis.Types.Message exposing (Message)
import Nexosis.Types.PredictionDomain exposing (PredictionDomain)
import Time.ZonedDateTime exposing (ZonedDateTime)


type alias ModelData =
    { modelId : String
    , sessionId : String
    , predictionDomain : PredictionDomain
    , dataSourceName : String
    , columns : List ColumnMetadata
    , createdDate : ZonedDateTime
    , algorithm : Algorithm
    , modelName : Maybe String
    , lastUsedDate : Maybe ZonedDateTime
    , metrics : Dict String Float
    , links : List Link
    }


type alias ModelList =
    { items : List ModelData
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


type alias PredictionResult =
    { data : List (Dict String String)
    , messages : List Message
    }
