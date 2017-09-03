module WxWeb.Helper.CachedGet exposing (Error(..), Request, Msg(..), handle, handlePipe)

import YJPark.Util exposing (..)
import YJPark.Json as Json
import YJPark.Http as Http

import WxWeb.Types as WxTypes
import WxWeb.Api.GetStorage as GetStorage
import WxWeb.Api.SetStorage as SetStorage
import WxWeb.Api.RemoveStorage as RemoveStorage

import Dict
import Json.Decode exposing (Decoder, decodeValue, string, int, value, field)


type Error
    = HttpError Http.Error
    | WxError WxTypes.Error


type alias Request val msg =
    { storageKey : String
    , request : Maybe (Http.Request val)
    , decoder : Decoder val
    , encode : val -> Json.Value
    , wrapper : Msg val msg -> msg
    , callback : (Result Error val) -> msg
    }


type Msg val msg
    = DoGet (Request val msg)
    | OnGet (Request val msg) (Result Error val)
    | DoSet String Json.Value (Msg val msg -> msg)
    | DoClear String (Msg val msg -> msg)
    | LoadLocalRst (Request val msg) (Result WxTypes.Error val)
    | LoadRemoteRst (Request val msg) (Result Http.Error val)
    | RemoveLocalRst (Request val msg) (Result WxTypes.Error Json.Value)
    | SaveLocalRst (Request val msg) (Result WxTypes.Error Json.Value)
    | SetLocalRst String Json.Value (Result WxTypes.Error Json.Value)
    | ClearLocalRst String (Result WxTypes.Error Json.Value)



handle : Msg val msg -> Cmd msg
handle msg =
    case msg of
        DoGet req ->
            GetStorage.cmd req.storageKey req.decoder <| (\res -> req.wrapper <| LoadLocalRst req res)
        OnGet req res ->
            toCmd <| req.callback res
        DoSet storageKey data wrapper ->
            SetStorage.cmd storageKey data (\res -> wrapper <| SetLocalRst storageKey data res)
        DoClear storageKey wrapper ->
            RemoveStorage.cmd storageKey (\res -> wrapper <| ClearLocalRst storageKey res)
        LoadLocalRst req (Ok val) ->
            toCmd <| req.wrapper <| OnGet req (Ok val)
        LoadLocalRst req (Err err) ->
            let
                removeCmd = case err of
                    (WxTypes.DecodeError _ _) ->
                        RemoveStorage.cmd req.storageKey (\res -> req.wrapper <| RemoveLocalRst req res)
                    _ ->
                        Cmd.none
                requestCmd = case req.request of
                    Nothing ->
                        toCmd <| req.wrapper <| OnGet req <| Err <| WxError err
                    Just request ->
                        (Http.cmd (\res -> req.wrapper <| LoadRemoteRst req res) request)
            in []
                |> insertCmd removeCmd
                |> insertCmd requestCmd
                |> Cmd.batch
        LoadRemoteRst req (Ok val) ->
            []
                |> insertCmd (SetStorage.cmd req.storageKey (req.encode val) (\res -> req.wrapper <| SaveLocalRst req res))
                |> insertCmd (toCmd <| req.wrapper <| OnGet req (Ok val))
                |> Cmd.batch
        LoadRemoteRst req (Err err) ->
            toCmd <| req.wrapper <| OnGet req <| Err <| HttpError err
        _ ->
            Cmd.none


handlePipe : Msg val msg -> (model, Cmd msg) -> (model, Cmd msg)
handlePipe msg =
    let
        cmd = handle msg
    in
        addCmd cmd
