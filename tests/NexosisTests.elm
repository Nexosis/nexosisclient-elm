module NexosisTests exposing (..)

import Expect
import Nexosis
import Test exposing (Test, describe, test)


createConfigTests : Test
createConfigTests =
    describe "can create a ClientConfig"
        [ test "with Token"
            (\_ ->
                Expect.equal """ClientConfig { apiAccess = AccessToken (Token "my-token"), baseUrl = "https://ml.nexosis.com/v2", applicationName = Nothing }""" <|
                    toString <|
                        Nexosis.createConfigWithToken "my-token"
            )
        , test "with Api Key"
            (\_ ->
                Expect.equal """ClientConfig { apiAccess = ApiKey (Key "my-api-key"), baseUrl = "https://ml.nexosis.com/v1", applicationName = Nothing }""" <|
                    toString <|
                        Nexosis.createConfigWithApiKey "my-api-key"
            )
        ]
