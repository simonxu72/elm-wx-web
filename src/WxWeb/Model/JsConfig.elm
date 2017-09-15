module WxWeb.Model.JsConfig exposing (..)
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


setDebug : Bool -> Type -> Type
setDebug debug model =
    { model
    | debug = debug
    }


setJsApiList : List JsApi.Type -> Type -> Type
setJsApiList jsApiList model =
    { model
    | jsApiList = jsApiList
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
encode model =
    empty
        |> insertString "url" model.url
        |> insertString "appId" model.appId
        |> insertString "timestamp" model.timestamp
        |> insertString "nonceStr" model.nonceStr
        |> insertString "signature" model.signature
        |> insertValue "jsApiList" (JsApi.encodeList model.jsApiList)
        |> insertBool "debug" model.debug
        |> toValue
