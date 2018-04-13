module Nexosis.Decoders.ConfusionMatrix exposing (decodeConfusionMatrix)

import Json.Decode as Decode exposing (Decoder, andThen, array, dict, fail, field, float, int, list, map2, string, succeed)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Nexosis.Types.ConfusionMatrix exposing (ConfusionMatrix)


decodeConfusionMatrix : Decode.Decoder ConfusionMatrix
decodeConfusionMatrix =
    decode ConfusionMatrix
        |> required "classes" (array string)
        |> required "confusionMatrix" (array (array int))
