module Nexosis.Decoders.PredictionDomain exposing (decodePredictionDomain)

import Json.Decode as Decode exposing (Decoder, andThen, fail, string, succeed)
import Nexosis.Types.PredictionDomain exposing (PredictionDomain(..))


decodePredictionDomain : Decoder PredictionDomain
decodePredictionDomain =
    string
        |> andThen
            (\n ->
                case n of
                    "regression" ->
                        succeed Regression

                    "classification" ->
                        succeed Classification

                    "forecast" ->
                        succeed Forecast

                    "anomalies" ->
                        succeed Anomalies

                    "impact" ->
                        succeed Impact

                    unknown ->
                        fail <| "Unknown prediction domain: " ++ unknown
            )
