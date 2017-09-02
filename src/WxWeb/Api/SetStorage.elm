module WxWeb.Api.SetStorage exposing (Key, call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)


type alias Key = String


onSucceed : Value -> Task Error Value
onSucceed res =
    succeed res


encodeData : Key -> Value -> Value
encodeData key data =
    Data.empty
        |> Data.insertString "key" key
        |> Data.insertValue "data" data
        |> Data.toValue


call : Key -> Value -> Task Error Value
call key data =
    Wx.call "setStorage" (encodeData key data) onSucceed


cmd : Key -> Value -> (Result Error Value -> msg) -> Cmd msg
cmd key data msg =
    call key data
        |> attempt msg
