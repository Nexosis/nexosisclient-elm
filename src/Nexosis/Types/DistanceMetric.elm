module Nexosis.Types.DistanceMetric exposing (DistanceMetrics, DistanceValue, fromDistanceMetrics)

import Dict exposing (Dict)
import Nexosis.Types.Data exposing (Data)


type alias DistanceMetrics =
    { dataSourceName : String
    , modelId : String
    , sessionId : String
    , sessionName : String
    , data : Data
    , pageNumber : Int
    , pageSize : Int
    , totalCount : Int
    , totalPages : Int
    }


type alias DistanceValue =
    { anomaly : Float
    , distance : Float
    }


fromDistanceMetrics : DistanceMetrics -> List DistanceValue
fromDistanceMetrics metrics =
    let
        toDistance : Maybe String -> Maybe String -> DistanceValue
        toDistance anomaly distance =
            DistanceValue (Maybe.withDefault "0" anomaly |> String.toFloat |> Result.withDefault 0) (Maybe.withDefault "0" distance |> String.toFloat |> Result.withDefault 0)
    in
    List.map (\d -> toDistance (Dict.get "anomaly" d) (Dict.get "mahalanobis_distance" d)) metrics.data
