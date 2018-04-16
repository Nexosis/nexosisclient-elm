module Nexosis.Types.AggregationStrategy exposing (AggregationStrategy(..))

{-| The Aggregation Strategy to use when rolling up time series data. This is an option provided on [ColumnMetadata](Nexosis.Types.Columns#ColumnMetadata).

Refer to the docs for more information about [ColumnMetadata](https://docs.nexosis.com/guides/column-metadata).

@docs AggregationStrategy

-}


{-| -}
type AggregationStrategy
    = Sum
    | Mean
    | Median
    | Mode
    | Min
    | Max
