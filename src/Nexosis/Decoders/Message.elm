module Nexosis.Decoders.Message exposing (decodeMessageList, decodeObjectMessage, decodeSeverity)

import Json.Decode exposing (Decoder, andThen, fail, field, int, list, map2, string, succeed)
import Json.Decode.Pipeline exposing (decode, required)
import Nexosis.Types.Message exposing (Message, MessageList, ObjectMessage, Severity(..))


decodeObjectMessage : Decoder ObjectMessage
decodeObjectMessage =
    map2 ObjectMessage
        (field "severity" decodeSeverity)
        (field "message" string)


decodeMessageList : Decoder MessageList
decodeMessageList =
    decode MessageList
        |> required "items" (list decodeMessage)
        |> required "pageNumber" int
        |> required "totalPages" int
        |> required "pageSize" int
        |> required "totalCount" int


decodeMessage : Decoder Message
decodeMessage =
    decode Message
        |> required "messageId" string
        |> required "content" string
        |> required "severity" decodeSeverity
        |> required "userId" string
        |> required "organizationId" string
        |> required "createAt" string
        |> required "relatedId" string
        |> required "relatedTo" string


decodeSeverity : Decoder Severity
decodeSeverity =
    string
        |> andThen
            (\severity ->
                case severity of
                    "status" ->
                        succeed Status

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
