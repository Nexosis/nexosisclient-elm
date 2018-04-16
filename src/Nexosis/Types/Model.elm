module Nexosis.Types.Model exposing (ModelData, ModelList, PredictionResult)

{-| In this package, `Model` refers to a machine learning `Model`, used to make predictions on new data, rather than the `Model` in The Elm Architecture.

After a `Session` has completed, a `Model` will be available. This `Model` can be used to make predictions by using the <Nexosis.Api.Mdoels> prediction functions.

Refer to our [documentation](https://docs.nexosis.com/guides/sessions) for more information.

@docs ModelData, ModelList, PredictionResult

-}

import Dict exposing (Dict)
import Nexosis.Types.Algorithm exposing (Algorithm)
import Nexosis.Types.Columns exposing (ColumnMetadata)
import Nexosis.Types.Link exposing (Link)
import Nexosis.Types.Message exposing (Message)
import Nexosis.Types.PredictionDomain exposing (PredictionDomain)
import Time.ZonedDateTime exposing (ZonedDateTime)


{-| ModelData
Representation of a single Model. Returned from the `/models` endpoint called by <Nexosis.Api.Models>.
-}
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


{-| A `List` of `ModelData`, with paging information.
-}
type alias ModelList =
    { items : List ModelData
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


{-| The results returned when calling [`predict`](Nexosis.Api.Models#predict) on a `Model`.
-}
type alias PredictionResult =
    { data : List (Dict String String)
    , messages : List Message
    }
