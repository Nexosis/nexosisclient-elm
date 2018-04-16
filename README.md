# Nexosis Api Client for Elm

This package provides functions which allow you to easily call the Nexosis Api.  It allows you to interact upload data, run machine learning algorithms, and make predictions on new data using a trained model.

## Basic usage

You will need to [register an account](https://nexosis.com) and get an Api key.  This will allow you to create a `ClientConfig`.

The `Api` modules contain functions to create Http requests.  The `Types` modules contain the types need to make requests, or the response types that will be returned.

```elm
import Http
import Nexosis
import Nexosis.Api.Data
import Nexosis.Types.DataSet
import Nexosis.Types.SortParameters exposing (SortDirection(..))

type Msg
    = DataSetListResponse (Result Http.Error Nexosis.Types.DataSet.DataSetList)


loadDataSetList : () -> Cmd Msg
loadDataSetList =
    let
        config =
            Nexosis.createConfigWithApiKey "my-api-key"

        pageSorting =
            { sortName: "dataSetName"
            , direction: Ascending
            }
    in
        Nexosis.Api.Data.get config 0 1 pageSorting
            |> Cmd.map DataSetListResponse

```

Refer to the [Api Documentation](https://docs.nexosis.com/) for more high level information of how to work with the Nexosis Api.