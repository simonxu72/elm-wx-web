module WxWeb.Api.HideAllNonBaseMenuItem exposing (call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import Task exposing (..)
import Json.Decode exposing (decodeValue, string, field)


onSucceed : Value -> Task Error Value
onSucceed res =
    succeed res


call : Task Error Value
call =
    Wx.call "hideAllNonBaseMenuItem" null onSucceed


cmd : (Result Error Value -> msg) -> Cmd msg
cmd msg =
    call
        |> attempt msg
