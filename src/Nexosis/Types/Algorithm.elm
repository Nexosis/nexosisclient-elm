module Nexosis.Types.Algorithm exposing (Algorithm)

{-| Details about a machine learning algorithm.

@docs Algorithm

-}


{-| -}
type alias Algorithm =
    { name : String
    , description : String
    , key : Maybe String
    }
