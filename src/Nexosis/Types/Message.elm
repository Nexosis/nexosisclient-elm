module Nexosis.Types.Message exposing (ObjectMessage, Message, MessageList, Severity(..))

{-| Messages are returned on many different Api endpoints. Generally, these show additional information about an Api Resource.
Addditionally, you can query for all messages on an organization, session, or import.

@docs ObjectMessage, Message, Severity, MessageList

-}


{-| Message as given on an object
-}
type alias ObjectMessage =
    { severity : Severity
    , message : String
    }


{-| Returned from `/messages` endpoint called by [Nexosis.Api.Messages.get](Nexosis-Api-Messages#get)
A List of [Message](#Message), with paging information.
-}
type alias MessageList =
    { items : List Message
    , pageNumber : Int
    , totalPages : Int
    , pageSize : Int
    , totalCount : Int
    }


{-| Detailed Message information from /messages endpoint.
-}
type alias Message =
    { messageId : String
    , content : String
    , severity : Severity
    , userId : String
    , organizationId : String
    , createdAt : String
    , relatedId : String
    , relatedTo : String
    }


{-| Message Severity
-}
type Severity
    = Status
    | Debug
    | Informational
    | Warning
    | Error
