module Nexosis.Types.ConfusionMatrix exposing (ConfusionMatrix)

{-| Classification `Sessions` will generate a `ConfusionMatrix`, which shows how well the `Model` was able to choose the correct class for a row.

@docs ConfusionMatrix

-}

import Array exposing (Array)


{-| -}
type alias ConfusionMatrix =
    { classes : Array String
    , confusionMatrix : Array (Array Int)
    }
