module Nexosis.Types.ConfusionMatrix exposing (ConfusionMatrix)

import Array exposing (Array)


type alias ConfusionMatrix =
    { classes : Array String
    , confusionMatrix : Array (Array Int)
    }
