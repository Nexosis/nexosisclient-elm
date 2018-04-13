module Nexosis.Decoders.Algorithm exposing (decodeAlgorithm)

import Json.Decode as Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Types.Algorithm exposing (Algorithm)


decodeAlgorithm : Decoder Algorithm
decodeAlgorithm =
    decode Algorithm
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> optional "key" (Decode.map Just string) Nothing
