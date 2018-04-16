module Nexosis.Types.Import exposing (ImportDetail, ImportType(..))

{-| Information about the Imports that can be found at the `/imports` endpoint, <Nexosis.Api.Imports>.

@docs ImportDetail, ImportType

-}

import Dict exposing (Dict)
import Nexosis.Types.Columns exposing (ColumnMetadata)
import Nexosis.Types.DataSet exposing (DataSetName)
import Nexosis.Types.Message exposing (Message)
import Nexosis.Types.Status exposing (HistoryRecord, Status)
import Time.DateTime exposing (DateTime)


{-| Detail information about a specific Import request.
-}
type alias ImportDetail =
    { importId : String
    , importType : ImportType
    , status : Status
    , dataSetName : DataSetName
    , parameters : Dict String (Maybe String)
    , requestedDate : DateTime
    , statusHistory : List HistoryRecord
    , messages : List Message
    , columns : List ColumnMetadata
    }


{-| The source where the import is coming from.
-}
type ImportType
    = S3
    | Url
    | Azure
