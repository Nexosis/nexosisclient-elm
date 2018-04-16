module Nexosis.Decoders.Link exposing (decodeLink)

import Json.Decode as Decode
import Nexosis.Types.Link exposing (Link)


decodeLink : Decode.Decoder Link
decodeLink =
    Decode.map2 Link
        (Decode.field "rel" Decode.string)
        (Decode.field "href" Decode.string)
