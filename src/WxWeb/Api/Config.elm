module WxWeb.Api.Config exposing (call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Model.JsConfig as JsConfig
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)


call : JsConfig.Type -> Task Error Value
call config =
    Wx.config (JsConfig.encode config)


cmd : JsConfig.Type -> (Result Error Value -> msg) -> Cmd msg
cmd config msg =
    call config
        |> attempt msg
