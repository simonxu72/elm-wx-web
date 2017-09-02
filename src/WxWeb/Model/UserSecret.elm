module WxWeb.Model.UserSecret exposing (Type, null, decoder, encode)

import WxWeb.Types exposing (..)

import YJPark.Data exposing (..)

import Json.Decode exposing (int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

type alias Value = YJPark.Data.Value

type alias Type =
    { rawData : String
    , signature : String
    , encryptedData : String
    , iv : String
    }


null : Type
null =
    { rawData = ""
    , signature = ""
    , encryptedData = ""
    , iv = ""
    }


decoder : Decoder Type
decoder =
    decode Type
        |> required "rawData" string
        |> required "signature" string
        |> required "encryptedData" string
        |> required "iv" string


encode : Type -> Value
encode info =
    empty
        |> insertString "rawData" info.rawData
        |> insertString "signature" info.signature
        |> insertString "encryptedData" info.encryptedData
        |> insertString "iv" info.iv
        |> toValue

