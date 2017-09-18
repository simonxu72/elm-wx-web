module WxWeb.Mod exposing
    ( Data, Value, Model, init, InitError(..), Msg(..), InMsg(..), OutMsg(..), update )


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
    | OtherFailed String


type InMsg
    = DoInit


type OutMsg
    = OnInitSucceed (Maybe String)
    | OnInitFailed InitError


type Msg
    = In InMsg
    | Out OutMsg
    | OnGetConfig (Result Http.Error JsConfig.Type)
    | OnConfig (Result Error Value)
    | OnAuth (Result Http.Error AuthInfo.Type)
    | OnGetSession (Result Error (Maybe String))
    | OnSetSession (Result Error Value)


onAuth : AuthInfo.Type -> Model -> (Model, Cmd Msg)
onAuth info model =
    case info.ok of
        True ->
            case info.token == "" of
                True ->
                    case info.url == "" of
                        True ->
                            (model, toCmd <| Out <| OnInitFailed <| OtherFailed (toString info))
                        False ->
                            (model, toCmd <| Out <| OnInitSucceed (Just info.url))
                False ->
                    {model | userToken = info.token} !
                        [ toCmd <| Out <| OnInitSucceed Nothing
                        , SetStorage.cmd "_WxWeb.Session" (Json.stringToValue info.token) OnSetSession
                        ]
        False ->
            let
                req = model.config
                    |> Config.getAuthUrlRequest model.location
                cmd = Http.cmd OnAuth req
            in
                (model, cmd)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        In DoInit ->
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
            (model, toCmd <| Out <| OnInitFailed <| GetConfigFailed err)
        OnConfig (Err err) ->
            (model, toCmd <| Out <| OnInitFailed <| ConfigFailed err)
        OnAuth (Err err) ->
            (model, toCmd <| Out <| OnInitFailed <| AuthFailed err)
        OnGetSession (Err err) ->
            (model, toCmd <| Out <| OnInitFailed <| GetSessionFailed err)
        OnSetSession (Ok session) ->
            let _ = error2 "Set Session Succeed:" session in
            (model, Cmd.none)
        OnSetSession (Err err) ->
            let _ = error2 "Set Session Failed:" err in
            (model, Cmd.none)
        Out (OnInitSucceed Nothing) ->
            let _ = info2 "Init Succeed, token =" model.userToken in
            (model, Cmd.none)
        Out (OnInitSucceed (Just url)) ->
            let _ = info2 "Init Succeed, need redirect to:" url in
            (model, Cmd.none)
        Out (OnInitFailed err) ->
            let _ = error2 "Init Failed:" err in
            (model, Cmd.none)

