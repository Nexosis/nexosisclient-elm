module Nexosis.Api.Messages exposing (get)

{-| This endpoint returns messages based on the query parameters. All messages on an organization or related to a specific session or import can be queried.

@docs get

-}

import Http
import List
import HttpBuilder exposing (withExpectJson)
import Nexosis exposing (ClientConfig, getBaseUrl)
import NexosisHelpers exposing (addHeaders, pageParams)
import Nexosis.Decoders.Message exposing (decodeMessageList)
import Nexosis.Types.Message exposing (MessageList, Severity)


type alias MessageQuery =
    { relatedId : Maybe String
    , levels : Maybe (List Severity)
    , page : Int
    , pageSize : Int
    }


{-| GET a list of `Messages` based on a query
-}
get : ClientConfig -> MessageQuery -> Http.Request MessageList
get config query =
    let
        encodeSeverity levels =
            levels |> List.map (\l -> toString l |> String.toLower) |> String.join ","

        params =
            (case ( query.relatedId, query.levels ) of
                ( Just id, Just lvl ) ->
                    [ ( "relatedId", id ), ( "levels", encodeSeverity lvl ) ]

                ( Nothing, Just lvl ) ->
                    [ ( "levels", encodeSeverity lvl ) ]

                ( Just id, Nothing ) ->
                    [ ( "relatedId", id ) ]

                ( Nothing, Nothing ) ->
                    []
            )
                ++ pageParams query.page query.pageSize
    in
        (getBaseUrl config ++ "/messages")
            |> HttpBuilder.get
            |> withExpectJson decodeMessageList
            |> addHeaders config
            |> HttpBuilder.toRequest
