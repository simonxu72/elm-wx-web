module WxWeb.Model.AuthInfo exposing (..)
import WxWeb.Model.JsApi as JsApi

import WxWeb.Types exposing (..)
import YJPark.Data as Data exposing (..)

import Json.Decode exposing (bool, int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Navigation exposing (Location)


type alias Type =
    { ok : Bool
    , token : String
    , url : String
    , msg : String
    }


null : Type
null =
    { ok = False
    , token = ""
    , url = ""
    , msg = ""
    }


decoder : Decoder Type
decoder =
    decode Type
        |> required "ok" bool
        |> optional "token" string ""
        |> optional "url" string ""
        |> optional "msg" string ""
