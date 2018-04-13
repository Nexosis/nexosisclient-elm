module Nexosis.Decoders.Algorithm exposing (decodeAlgorithm)

import Json.Decode as Decode exposing (Decoder, andThen, dict, fail, field, float, int, list, map2, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Types.Algorithm exposing (Algorithm)


decodeAlgorithm : Decoder Algorithm
decodeAlgorithm =
    decode Algorithm
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> optional "key" (Decode.map Just string) Nothing
