module Nexosis.Types.SortParameters exposing (SortDirection(..), SortParameters)

{-| Api calls that return lists of results require a sort order and direction in order to determine how the results
should be returned.

@docs SortParameters, SortDirection

-}


{-| The `sortName` that can be used is specific to the endpoint being called.
Refer to the full [Api documentation](https://developers.nexosis.com/docs/services/98847a3fbbe64f73aa959d3cededb3af/operations/datasets-list-all?) for the list of supported values.
-}
type alias SortParameters =
    { sortName : String
    , direction : SortDirection
    }


{-| Direction in which to return the results.
-}
type SortDirection
    = Ascending
    | Descending
