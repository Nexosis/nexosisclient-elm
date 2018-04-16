module Nexosis.Types.Status exposing (HistoryRecord, Status(..))

{-| Status is reported on any long running processing that the Nexosis Api may be doing. These are mostly `Sessions` and `Imports`.

@docs Status, HistoryRecord

-}

import Time.ZonedDateTime exposing (ZonedDateTime)


{-| -}
type Status
    = Requested
    | Started
    | Completed
    | Cancelled
    | Failed
    | CancellationPending


{-| The history of when status was changed from one value to another.
-}
type alias HistoryRecord =
    { date : ZonedDateTime
    , status : Status
    }
