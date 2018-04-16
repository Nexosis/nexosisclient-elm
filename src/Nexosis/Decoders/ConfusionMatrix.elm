module Nexosis.Decoders.ConfusionMatrix exposing (decodeConfusionMatrix)

import Json.Decode as Decode exposing (array, int, string)
import Json.Decode.Pipeline exposing (decode, required)
import Nexosis.Types.ConfusionMatrix exposing (ConfusionMatrix)


decodeConfusionMatrix : Decode.Decoder ConfusionMatrix
decodeConfusionMatrix =
    decode ConfusionMatrix
        |> required "classes" (array string)
        |> required "confusionMatrix" (array (array int))
