module Nexosis.Decoders.Date exposing (decodeDate)

import Json.Decode as Decode exposing (Decoder, andThen, fail, string, succeed)
import Time.TimeZones exposing (etc_universal)
import Time.ZonedDateTime exposing (ZonedDateTime, fromISO8601)


decodeDate : Decoder ZonedDateTime
decodeDate =
    let
        convert : String -> Decoder ZonedDateTime
        convert raw =
            case fromISO8601 (etc_universal ()) raw of
                Ok date ->
                    succeed date

                Err error ->
                    fail error
    in
    string |> andThen convert
