module WxWeb.Api.RemoveStorage exposing (Key, call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)
import Json.Decode exposing (decodeValue, string, field)


type alias Key = String


onSucceed : Value -> Task Error Value
onSucceed res =
    succeed res


encodeData : Key -> Value
encodeData key =
    Data.empty
        |> Data.insertString "key" key
        |> Data.toValue


call : Key -> Task Error Value
call key =
    Wx.call "removeStorage" (encodeData key) onSucceed


cmd : Key -> (Result Error Value -> msg) -> Cmd msg
cmd key msg =
    call key
        |> attempt msg
