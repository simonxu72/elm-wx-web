module WxWeb.Model.Mod exposing (..)

import WxWeb.Model.Config as Config
import WxWeb.Model.UserInfo as UserInfo
import WxWeb.Model.UserSecret as UserSecret

import WxWeb.Types exposing (..)

import YJPark.Data exposing (..)

import Json.Decode exposing (int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


type alias Value = YJPark.Data.Value


type alias Type =
    { config : Config.Type
    , userCode : String
    , userInfo : UserInfo.Type
    , userSecret : UserSecret.Type
    }

null : Type
null =
    { config = Config.null
    , userCode = ""
    , userInfo = UserInfo.null
    , userSecret = UserSecret.null
    }


resetSession : Type -> Type
resetSession model =
    { model
    | userCode = ""
    , userInfo = UserInfo.null
    , userSecret = UserSecret.null
    }


mergeSaved : Type -> Type -> Type
mergeSaved saved model =
    { model
    | userCode = saved.userCode
    , userInfo = saved.userInfo
    , userSecret = saved.userSecret
    }


decoder : Decoder Type
decoder =
    decode Type
        |> hardcoded Config.null
        |> required "userCode" string
        |> required "userInfo" UserInfo.decoder
        |> required "userSecret" UserSecret.decoder


encode : Type -> Value
encode model =
    empty
        |> insertString "userCode" model.userCode
        |> insertValue "userInfo" (UserInfo.encode model.userInfo)
        |> insertValue "userSecret" (UserSecret.encode model.userSecret)
        |> toValue

