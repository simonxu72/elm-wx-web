module WxWeb.Mod exposing
    ( Data, Value, Model, init, InitError(..), Msg(..), update )


import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import WxWeb.Model.Mod as WxModel
import WxWeb.Model.Config as Config
import WxWeb.Model.JsConfig as JsConfig
import WxWeb.Model.AuthInfo as AuthInfo

import WxWeb.Api.Config as Config
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


type InitError
    = GetConfigFailed Http.Error
    | AuthFailed Http.Error
    | ConfigFailed Error
    | GetSessionFailed Error


type Msg
    = DoInit
    | OnInitFailed InitError
    | OnGetConfig (Result Http.Error JsConfig.Type)
    | OnConfig (Result Error Value)
    | OnAuth (Result Http.Error AuthInfo.Type)
    | OnGetSession (Result Error (Maybe String))


onAuth : AuthInfo.Type -> Model -> (Model, Cmd Msg)
onAuth info model =
    let _ = error2 "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA onAuth" info in
    (model, Cmd.none)


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
                js_config = config_
                    |> JsConfig.setDebug model.config.debug
                    |> JsConfig.setJsApiList model.config.jsApiList
            in
                ({model | js_config = js_config}, Config.cmd js_config OnConfig)
        OnConfig (Ok _) ->
            let
                cmd = case WxModel.getCode model of
                    Just code ->
                        let
                            req = model.config
                                |> Config.checkCodeRequest code
                        in
                            Http.cmd OnAuth req
                    Nothing ->
                        GetStorage.cmd "_WxWeb.Session" JsonDecode.string OnGetSession
            in
                (model, cmd)
        OnAuth (Ok info) ->
            onAuth info model
        OnGetSession (Ok session) ->
            let
                req = case session of
                    Nothing ->
                        model.config
                            |> Config.getAuthUrlRequest model.location
                    Just session ->
                        model.config
                            |> Config.checkSessionRequest session
                cmd = Http.cmd OnAuth req
            in
                (model, cmd)
        OnGetConfig (Err err) ->
            (model, toCmd <| OnInitFailed <| GetConfigFailed err)
        OnConfig (Err err) ->
            (model, toCmd <| OnInitFailed <| ConfigFailed err)
        OnAuth (Err err) ->
            (model, toCmd <| OnInitFailed <| AuthFailed err)
        OnGetSession (Err err) ->
            (model, toCmd <| OnInitFailed <| GetSessionFailed err)
        OnInitFailed err ->
            let _ = error2 "Init Failed:" err in
            (model, Cmd.none)

