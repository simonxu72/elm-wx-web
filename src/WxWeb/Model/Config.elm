module WxWeb.Model.Config exposing (..)
import WxWeb.Model.JsApi as JsApi

import WxWeb.Types exposing (..)
import YJPark.Data as Data exposing (..)

import Json.Decode exposing (bool, int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Navigation exposing (Location)


type alias Type =
    { url : String
    , appId : String
    , timestamp : String
    , nonceStr : String
    , signature : String
    , jsApiList : List JsApi.Type
    , debug : Bool
    }


null : Type
null =
    { url = ""
    , appId = ""
    , timestamp = ""
    , nonceStr = ""
    , signature = ""
    , jsApiList = []
    , debug = True
    }


decoder : Decoder Type
decoder =
    decode Type
        |> required "url" string
        |> required "appId" string
        |> required "timestamp" string
        |> required "nonceStr" string
        |> required "signature" string
        |> optional "jsApiList" JsApi.listDecoder []
        |> optional "debug" bool False


encode : Type -> Data.Value
encode config =
    empty
        |> insertString "url" config.url
        |> insertString "appId" config.appId
        |> insertString "timestamp" config.timestamp
        |> insertString "nonceStr" config.nonceStr
        |> insertString "signature" config.signature
        |> insertValue "jsApiList" (JsApi.encodeList config.jsApiList)
        |> insertBool "debug" config.debug
        |> toValue


encodeUrl : Location -> String
encodeUrl location =
    location.protocol ++ "//" ++ location.host ++ location.pathname ++ location.search

