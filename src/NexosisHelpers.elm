module NexosisHelpers exposing (addHeaders, sortParams)

import HttpBuilder exposing (RequestBuilder)
import Nexosis exposing (ClientConfig, withAppHeader, withAuthorization)
import Nexosis.Types.SortParameters exposing (SortDirection(..), SortParameters)


addHeaders : ClientConfig -> RequestBuilder a -> RequestBuilder a
addHeaders clientConfig builder =
    builder |> withAppHeader clientConfig |> withAuthorization clientConfig


sortParams : SortParameters -> List ( String, String )
sortParams { sortName, direction } =
    [ ( "sortBy", sortName )
    , ( "sortOrder"
      , if direction == Ascending then
            "asc"
        else
            "desc"
      )
    ]
