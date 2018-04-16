module Nexosis.Encoders.Columns exposing (encodeColumnMetadataList, encodeKeyColumnMetadata)

import Json.Encode exposing (Value, object, string)
import Nexosis.Types.Columns exposing (ColumnMetadata, DataType(..))


encodeKeyColumnMetadata : String -> Value
encodeKeyColumnMetadata key =
    object <|
        [ ( key
          , object [ ( "role", string "key" ) ]
          )
        ]


encodeColumnMetadataList : List ColumnMetadata -> Value
encodeColumnMetadataList columns =
    object <|
        (columns
            |> List.map (\c -> ( c.name, encodeColumnValues c ))
        )


encodeColumnValues : ColumnMetadata -> Value
encodeColumnValues column =
    object
        [ ( "dataType", encodeDataType <| column.dataType )
        , ( "role", string <| toString <| column.role )
        , ( "imputation", string <| toString <| column.imputation )
        , ( "aggregation", string <| toString <| column.aggregation )
        ]


encodeDataType : DataType -> Value
encodeDataType dataType =
    if dataType == Measure then
        string "numericMeasure"
    else
        string <| toString dataType
