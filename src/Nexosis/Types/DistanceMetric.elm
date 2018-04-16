module Nexosis.Types.DistanceMetric exposing (DistanceMetrics, DistanceValue, fromDistanceMetrics)

{-| Distance metrics are calculated for Anomaly Detection `Sessions`. This is the Mahalanobis Distance of the items in the `DataSet`.

@docs DistanceMetrics, DistanceValue, fromDistanceMetrics

-}

import Dict
import Nexosis.Types.Data exposing (Data)


{-| Distance Metric information for the `DataSet`, as calculated during the `Session`.
-}
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


{-| Distance an Anomaly values.
-}
type alias DistanceValue =
    { anomaly : Float
    , distance : Float
    }


{-| Convenience function to go from a full `DistanceMetrics` response to just a list of `DistanceValue`.
-}
fromDistanceMetrics : DistanceMetrics -> List DistanceValue
fromDistanceMetrics metrics =
    let
        toDistance : Maybe String -> Maybe String -> DistanceValue
        toDistance anomaly distance =
            DistanceValue (Maybe.withDefault "0" anomaly |> String.toFloat |> Result.withDefault 0) (Maybe.withDefault "0" distance |> String.toFloat |> Result.withDefault 0)
    in
    List.map (\d -> toDistance (Dict.get "anomaly" d) (Dict.get "mahalanobis_distance" d)) metrics.data
