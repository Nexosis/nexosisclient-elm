module Nexosis.Types.PredictionDomain exposing (PredictionDomain(..))

{-| This specifies the broad class of machine learning algorithms that should be used when running a `Session`.

For more information about these types can be found [in our documentation](https://docs.nexosis.com/guides/how-it-works#session).

@docs PredictionDomain

-}


{-| -}
type PredictionDomain
    = Regression
    | Classification
    | Forecast
    | Impact
    | Anomalies
