module WxWeb.Model.Mod exposing (..)

import WxWeb.Model.Config as Config
import WxWeb.Model.UserInfo as UserInfo
import WxWeb.Model.UserSecret as UserSecret

import WxWeb.Types exposing (..)

import YJPark.Data exposing (..)

import Json.Decode exposing (int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Navigation exposing (Location)


type alias Value = YJPark.Data.Value


type alias Type =
    { config : Config.Type
    , location : Location
    , userToken : String
    , userInfo : UserInfo.Type
    }

init : Config.Type -> Location -> Type
init config location =
    { config = config
    , location = location
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
