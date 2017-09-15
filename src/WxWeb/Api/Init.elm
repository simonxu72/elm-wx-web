module WxWeb.Api.Init exposing (call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Model.Config as Config
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)


call : Config.Type -> Task Error Value
call config =
    Wx.config (Config.encode config)


cmd : Config.Type -> (Result Error Value -> msg) -> Cmd msg
cmd config msg =
    call config
        |> attempt msg
