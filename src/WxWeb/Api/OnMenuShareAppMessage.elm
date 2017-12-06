module WxWeb.Api.OnMenuShareAppMessage exposing (Setting, call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)
import Json.Decode exposing (decodeValue, string, field)


type alias Setting =
    { title : String
    , desc : String
    , link : String
    , imgUrl : String
    }


encodeSetting : Setting -> Data.Value
encodeSetting setting =
    Data.empty
        |> Data.insertString "title" setting.title
        |> Data.insertString "desc" setting.desc
        |> Data.insertString "link" setting.link
        |> Data.insertString "imgUrl" setting.imgUrl
        |> Data.toValue


onSucceed : Value -> Task Error Value
onSucceed res =
    succeed res


call : Setting -> Task Error Value
call setting =
    Wx.call "onMenuShareAppMessage" (encodeSetting setting) onSucceed


cmd : Setting -> (Result Error Value -> msg) -> Cmd msg
cmd setting msg =
    call setting
        |> attempt msg
