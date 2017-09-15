module WxWeb.Model.Config exposing (..)
import WxWeb.Model.JsApi as JsApi
import WxWeb.Model.JsConfig as JsConfig

import WxWeb.Types exposing (..)
import YJPark.Data as Data exposing (..)

import Json.Decode exposing (bool, int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Navigation exposing (Location)
import Http exposing (Request)


type alias BackendUrls =
    { get_config : String -> Decoder JsConfig.Type -> Request JsConfig.Type
    , get_auth : String -> String
    , check_session : String -> String
    , check_code : String -> String
    }


type alias Type =
    { debug : Bool
    , urls : BackendUrls
    , jsApiList : List JsApi.Type
    }


init : Bool -> BackendUrls -> List JsApi.Type -> Type
init debug urls jsApiList =
    { debug = debug
    , urls = urls
    , jsApiList = jsApiList
    }


encodeUrl : Location -> String
encodeUrl location =
    location.protocol ++ "//" ++ location.host ++ location.pathname ++ location.search


getConfigRequest : Location -> Type -> Request JsConfig.Type
getConfigRequest location model =
    model.urls.get_config (encodeUrl location) JsConfig.decoder

