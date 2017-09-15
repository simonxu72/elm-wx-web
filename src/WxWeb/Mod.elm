module WxWeb.Mod exposing
    ( Data, Value, Model, null, Msg(..), update )


import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import WxWeb.Model.Mod as WxModel
import WxWeb.Model.Config as Config

import WxWeb.Api.Init as Init
import WxWeb.Api.GetStorage as GetStorage
import WxWeb.Api.SetStorage as SetStorage
import WxWeb.Api.RemoveStorage as RemoveStorage

import YJPark.Util exposing (..)
import YJPark.Json as Json
import YJPark.Data as Data

import Task exposing (..)
import Json.Encode
import Json.Decode as JsonDecode


type alias Data = Data.Data
type alias Value = Json.Value

type alias Model = WxModel.Type
null = WxModel.null


type Msg
    = DoInit Config.Type
    | InitMsg (Result Error Value)
    --| DoLogin
    --| LoginMsg (Result Error Login.Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        DoInit config ->
            (model, Init.cmd config InitMsg)
        _ ->
            (model, Cmd.none)
