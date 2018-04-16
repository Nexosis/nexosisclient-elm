module Nexosis.Types.ImputationStrategy exposing (ImputationStrategy(..))

{-| The Imputation Strategy to use when filling in missing values in a `DataSet`. This is an option provided on [ColumnMetadata](Nexosis.Types.Columns#ColumnMetadata).

Refer to the docs for more information about [ColumnMetadata](https://docs.nexosis.com/guides/column-metadata).

@docs ImputationStrategy

-}


{-| -}
type ImputationStrategy
    = Zeroes
    | Mean
    | Median
    | Mode
    | Min
    | Max
