module Nexosis.Types.Status exposing (HistoryRecord, Status(..))

import Time.ZonedDateTime exposing (ZonedDateTime)


type Status
    = Requested
    | Started
    | Completed
    | Cancelled
    | Failed
    | CancellationPending


type alias HistoryRecord =
    { date : ZonedDateTime
    , status : Status
    }
