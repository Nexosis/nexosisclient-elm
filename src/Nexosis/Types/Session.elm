module Nexosis.Types.Session exposing (ResultInterval(..), SessionData, SessionList, SessionResults)

{-| A `Session` is the representation of the long running processing done when building a machine learning model.

New `Sessions` can be requested, and when completed, results can be retrieved, and the generated machine learning `Models` can be called on to make predictions on new data.

Refer to our [documentation on Sessions](https://docs.nexosis.com/guides/sessions) for more information.

@docs SessionData, SessionList, SessionResults, ResultInterval

-}

import Dict exposing (Dict)
import Nexosis.Types.Algorithm exposing (Algorithm)
import Nexosis.Types.Columns exposing (ColumnMetadata)
import Nexosis.Types.Link exposing (Link)
import Nexosis.Types.Message exposing (Message)
import Nexosis.Types.PredictionDomain exposing (PredictionDomain)
import Nexosis.Types.Status exposing (HistoryRecord, Status)
import Time.ZonedDateTime exposing (ZonedDateTime)


{-| This is the information about a specific `Session`. Some values may not be available until the
`Session` has completed successfully.
-}
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
    , approximateCompletionPercentage : Int
    }


{-| The results of a Session. The information returned will vary based on the type of `Session` that was run.
-}
type alias SessionResults =
    { metrics : Dict String Float
    , data : List (Dict String String)
    }


{-| A `List` of `SessionData`, with paging information.
-}
type alias SessionList =
    { items : List SessionData
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


{-| The interval at which to calculate results when requesting a `Forecast` or `Impact` session.
-}
type ResultInterval
    = Hour
    | Day
    | Week
    | Month
    | Year
