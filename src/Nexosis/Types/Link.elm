module Nexosis.Types.Link exposing (Link)

{-| Links are returned on many different endpoint calls, and refer to different related objects in the Api.

@docs Link

-}


{-| -}
type alias Link =
    { rel : String
    , href : String
    }
