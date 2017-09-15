module WxWeb.Mod exposing
    ( Data, Value, Model, init, Msg(..), update )


import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import WxWeb.Model.Mod as WxModel
import WxWeb.Model.Config as Config
import WxWeb.Model.JsConfig as JsConfig

import WxWeb.Api.Init as Init
import WxWeb.Api.GetStorage as GetStorage
import WxWeb.Api.SetStorage as SetStorage
import WxWeb.Api.RemoveStorage as RemoveStorage

import YJPark.Util exposing (..)
import YJPark.Json as Json
import YJPark.Data as Data
import YJPark.Http as Http

import Task exposing (..)
import Json.Encode
import Json.Decode as JsonDecode


type alias Data = Data.Data
type alias Value = Json.Value

type alias Model = WxModel.Type
init = WxModel.init


type Msg
    = DoInit
    | OnGetConfig (Result Http.Error JsConfig.Type)
    | OnInitMsg JsConfig.Type (Result Error Value)
    --| DoLogin
    --| LoginMsg (Result Error Login.Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        DoInit ->
            let
                req = model.config
                    |> Config.getConfigRequest model.location
            in
                (model, Http.cmd OnGetConfig req)
        OnGetConfig (Ok config_) ->
            let
                config = config_
                    |> JsConfig.setDebug model.config.debug
                    |> JsConfig.setJsApiList model.config.jsApiList
            in
                (model, Init.cmd config <| OnInitMsg config)
        OnInitMsg config (Ok _) ->
            --TODO: Get Token
            (model, Cmd.none)
        OnGetConfig (Err err) ->
            --TODO: Error Handling
            (model, Cmd.none)
        OnInitMsg config (Err err) ->
            --TODO: Error Handling
            (model, Cmd.none)
