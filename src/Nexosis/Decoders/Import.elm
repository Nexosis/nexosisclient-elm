module Nexosis.Decoders.Import exposing (decodeImportDetail)

import Json.Decode as Decode exposing (Decoder, andThen, decodeValue, dict, fail, field, float, int, list, map2, nullable, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Decoders.Columns exposing (decodeColumnMetadata)
import Nexosis.Decoders.DataSet exposing (dataSetNameDecoder)
import Nexosis.Decoders.Message exposing (decodeMessage)
import Nexosis.Decoders.Status exposing (decodeHistoryRecord, decodeStatus)
import Nexosis.Types.Import exposing (ImportDetail, ImportType(..))
import Time.DateTime exposing (DateTime, fromISO8601)


decodeImportDetail : Decoder ImportDetail
decodeImportDetail =
    decode ImportDetail
        |> required "importId" string
        |> required "type" decodeImportType
        |> required "status" decodeStatus
        |> required "dataSetName" dataSetNameDecoder
        |> required "parameters" (dict (nullable string))
        |> required "requestedDate" decodeDate
        |> required "statusHistory" (list decodeHistoryRecord)
        |> required "messages" (list decodeMessage)
        |> required "columns" decodeColumnMetadata


decodeDate : Decoder DateTime
decodeDate =
    string
        |> andThen
            (\s ->
                case fromISO8601 s of
                    Ok date ->
                        succeed date

                    Err err ->
                        fail err
            )


decodeImportType : Decoder ImportType
decodeImportType =
    string
        |> andThen
            (\i ->
                case i of
                    "s3" ->
                        succeed S3

                    "url" ->
                        succeed Url

                    "azure" ->
                        succeed Azure

                    unknown ->
                        fail <| "Unknown import type: " ++ unknown
            )
