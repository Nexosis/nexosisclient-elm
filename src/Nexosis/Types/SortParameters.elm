module Nexosis.Types.SortParameters exposing (SortDirection(..), SortParameters)

{-| Helpers - Will become private to the package.

@docs addHeaders, sortParams, formatFloatToString, commaFormatInteger

-}


{-| -}
type alias SortParameters =
    { sortName : String
    , direction : SortDirection
    }


{-| -}
type SortDirection
    = Ascending
    | Descending
