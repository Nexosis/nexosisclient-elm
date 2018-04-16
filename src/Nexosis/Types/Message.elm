module Nexosis.Types.Message exposing (Message, Severity(..))

{-| Messages are returned on many different Api endpoints. Generally, these show additional information about an Api Resource.

@docs Message, Severity

-}


{-| -}
type alias Message =
    { severity : Severity
    , message : String
    }


{-| -}
type Severity
    = Debug
    | Informational
    | Warning
    | Error
