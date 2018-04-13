module Nexosis.Types.Message exposing (Message, Severity(..))


type alias Message =
    { severity : Severity
    , message : String
    }


type Severity
    = Debug
    | Informational
    | Warning
    | Error
