module Nexosis.Types.ImputationStrategy exposing (ImputationStrategy(..))


type ImputationStrategy
    = Zeroes
    | Mean
    | Median
    | Mode
    | Min
    | Max
