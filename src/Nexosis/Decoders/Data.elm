module Nexosis.Decoders.Data exposing (decodeData)

import Json.Decode as Decode exposing (Decoder, dict, list, string, succeed)
import Nexosis.Types.Data exposing (Data)


decodeData : Decoder Data
decodeData =
    list <|
        dict (Decode.oneOf [ string, succeed "" ])
