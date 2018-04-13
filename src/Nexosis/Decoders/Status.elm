module Nexosis.Decoders.Status exposing (decodeHistoryRecord, decodeStatus)

import Json.Decode exposing (Decoder, andThen, fail, field, map2, string, succeed)
import Nexosis.Decoders.Date exposing (decodeDate)
import Nexosis.Types.Status exposing (HistoryRecord, Status(..))


decodeHistoryRecord : Decoder HistoryRecord
decodeHistoryRecord =
    map2 HistoryRecord
        (field "date" decodeDate)
        (field "status" decodeStatus)


decodeStatus : Decoder Status
decodeStatus =
    string
        |> andThen
            (\n ->
                case n of
                    "requested" ->
                        succeed Requested

                    "started" ->
                        succeed Started

                    "completed" ->
                        succeed Completed

                    "cancelled" ->
                        succeed Cancelled

                    "failed" ->
                        succeed Failed

                    "cancellationPending" ->
                        succeed CancellationPending

                    unknown ->
                        fail <| "Unknown session status: " ++ unknown
            )
