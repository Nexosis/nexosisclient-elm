module Nexosis.Api.Imports exposing (PostAzureRequest, PostS3Request, PostUrlRequest, get, postAzure, postS3, postUrl)

{-| Functions for interacting with the `/imports` endpoint.


## GET

@docs get


## POST

Data can be imported from a public facing Url, an S3 bucket, or an Azure blob. Use the specific function and request to start an file import.

@docs postUrl, PostUrlRequest, postS3, PostS3Request, postAzure, PostAzureRequest

-}

import Http
import HttpBuilder exposing (withExpectJson)
import Json.Encode exposing (encode)
import Nexosis exposing (ClientConfig, getBaseUrl)
import Nexosis.Decoders.Import exposing (decodeImportDetail)
import Nexosis.Encoders.Columns exposing (encodeKeyColumnMetadata)
import Nexosis.Types.Import exposing (ImportDetail)
import NexosisHelpers exposing (addHeaders)


{-| The name of the `DataSet` to import data to, the publicly accessible Url to import from, and an optional unique key column.
-}
type alias PostUrlRequest =
    { dataSetName : String
    , url : String
    , key : Maybe String
    }


{-| The name of the `DataSet` to import data to, all of the details needed to download the data from S3.
-}
type alias PostS3Request =
    { dataSetName : String
    , bucket : String
    , path : String
    , region : Maybe String
    , accessKeyId : Maybe String
    , secretAccessKey : Maybe String
    }


{-| The name of the `DataSet` to import data to, all of the details needed to download the data from Azure.
-}
type alias PostAzureRequest =
    { dataSetName : String
    , connectionString : String
    , container : String
    , blob : String
    }


{-| POST to start a data `Import` from a public Url.
-}
postUrl : ClientConfig -> PostUrlRequest -> Http.Request ImportDetail
postUrl config { dataSetName, url, key } =
    (getBaseUrl config ++ "/imports/url")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody "application/json" <| encode 0 (encodeImportUrl dataSetName url key))
        |> addHeaders config
        |> withExpectJson decodeImportDetail
        |> HttpBuilder.toRequest


{-| POST to start a data `Import` from S3.
-}
postS3 : ClientConfig -> PostS3Request -> Http.Request ImportDetail
postS3 config request =
    (getBaseUrl config ++ "/imports/s3")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody "application/json" <| encode 0 (encodeImportS3 request))
        |> addHeaders config
        |> withExpectJson decodeImportDetail
        |> HttpBuilder.toRequest


{-| POST to start a data `Import` from Azure.
-}
postAzure : ClientConfig -> PostAzureRequest -> Http.Request ImportDetail
postAzure config request =
    (getBaseUrl config ++ "/imports/azure")
        |> HttpBuilder.post
        |> HttpBuilder.withBody (Http.stringBody "application/json" <| encode 0 (encodeImportAzure request))
        |> addHeaders config
        |> withExpectJson decodeImportDetail
        |> HttpBuilder.toRequest


{-| GET a specific `Import` by id. Useful for checking the `Status`.
-}
get : ClientConfig -> String -> Http.Request ImportDetail
get config importId =
    (getBaseUrl config ++ "/imports/" ++ importId)
        |> HttpBuilder.get
        |> addHeaders config
        |> withExpectJson decodeImportDetail
        |> HttpBuilder.toRequest


encodeImportUrl : String -> String -> Maybe String -> Json.Encode.Value
encodeImportUrl dataSetName url key =
    let
        keyEncoder =
            key
                |> Maybe.map encodeKeyColumnMetadata
                |> Maybe.withDefault Json.Encode.null
    in
    Json.Encode.object
        [ ( "dataSetName", Json.Encode.string <| dataSetName )
        , ( "url", Json.Encode.string <| url )
        , ( "columns", keyEncoder )
        ]


encodeImportS3 : PostS3Request -> Json.Encode.Value
encodeImportS3 request =
    let
        encodeMaybe maybe =
            case maybe of
                Nothing ->
                    Json.Encode.null

                Just thing ->
                    Json.Encode.string thing
    in
    Json.Encode.object
        [ ( "dataSetName", Json.Encode.string <| request.dataSetName )
        , ( "path", Json.Encode.string <| request.path )
        , ( "bucket", Json.Encode.string <| request.bucket )
        , ( "region", encodeMaybe <| request.region )
        , ( "accessKeyId", encodeMaybe <| request.accessKeyId )
        , ( "secretAccessKey", encodeMaybe <| request.secretAccessKey )
        ]


encodeImportAzure : PostAzureRequest -> Json.Encode.Value
encodeImportAzure request =
    Json.Encode.object
        [ ( "dataSetName", Json.Encode.string <| request.dataSetName )
        , ( "connectionString", Json.Encode.string <| request.connectionString )
        , ( "container", Json.Encode.string <| request.container )
        , ( "blob", Json.Encode.string <| request.blob )
        ]
