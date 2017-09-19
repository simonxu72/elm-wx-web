module WxWeb.Model.Mod exposing (..)

import WxWeb.Model.Config as Config
import WxWeb.Model.JsConfig as JsConfig
import WxWeb.Model.UserInfo as UserInfo

import WxWeb.Types exposing (..)

import YJPark.Data exposing (..)
import YJPark.Html.Helper exposing (parseParams)

import Json.Decode exposing (int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Navigation exposing (Location)
import Dict


type alias Value = YJPark.Data.Value


type alias Type =
    { config : Config.Type
    , location : Location
    , js_config : JsConfig.Type
    , userToken : String
    , userInfo : UserInfo.Type
    }


init : Config.Type -> Location -> Type
init config location =
    { config = config
    , location = location
    , js_config = JsConfig.null
    , userToken = ""
    , userInfo = UserInfo.null
    }


resetSession : Type -> Type
resetSession model =
    { model
    | userToken = ""
    , userInfo = UserInfo.null
    }


setLocation : Location -> Type -> Type
setLocation location model =
    { model
    | location = location
    }


setUserToken : String -> Type -> Type
setUserToken userToken model =
    { model
    | userToken = userToken
    }


setUserInfo : UserInfo.Type -> Type -> Type
setUserInfo userInfo model =
    { model
    | userInfo = userInfo
    }


getCode : Type -> Maybe String
getCode model =
    model.location.search
        |> parseParams
        |> Dict.get "code"
