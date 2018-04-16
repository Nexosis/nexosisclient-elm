module Nexosis.Types.Data exposing (Data)

{-|

@docs Data

-}

import Dict exposing (Dict)


{-| Alias for a `List` of `Dict String String`. Returned from several different Api calls.
-}
type alias Data =
    List (Dict String String)
