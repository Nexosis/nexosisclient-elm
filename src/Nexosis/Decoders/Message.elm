module Nexosis.Decoders.Message exposing (decodeMessage, decodeSeverity)

import Json.Decode as Decode exposing (Decoder, andThen, fail, field, map2, string, succeed)
import Nexosis.Types.Message exposing (Message, Severity(..))


decodeMessage : Decoder Message
decodeMessage =
    map2 Message
        (field "severity" decodeSeverity)
        (field "message" string)


decodeSeverity : Decoder Severity
decodeSeverity =
    string
        |> andThen
            (\severity ->
                case severity of
                    "debug" ->
                        succeed Debug

                    "informational" ->
                        succeed Informational

                    "warning" ->
                        succeed Warning

                    "error" ->
                        succeed Error

                    unknown ->
                        fail <| "Unknown message severity: " ++ unknown
            )
