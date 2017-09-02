module WxWeb.Api.GetStorage exposing (Key, call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)
import Json.Decode exposing (Decoder, decodeValue, string, field, value)


type alias Key = String


encodeData : Key -> Value
encodeData key =
    Data.empty
        |> Data.insertString "key" key
        |> Data.toValue


onSucceed : (Decoder msg) -> Value -> Task Error msg
onSucceed decoder res =
    let
        dataResult = decodeValue (field "data" value) res
    in
        case dataResult of
            Ok data ->
                case decodeValue decoder data of
                    Ok msg ->
                        succeed msg
                    Err err ->
                        fail <| DecodeError res err
            Err err ->
                fail <| ApiError res ("BadData:" ++ err)


call : Key -> (Decoder msg) -> Task Error msg
call key decoder =
    Wx.call "getStorage" (encodeData key) (onSucceed decoder)


cmd : Key -> (Decoder msg) -> (Result Error msg -> msg2) -> Cmd msg2
cmd key decoder msg =
    call key decoder
        |> attempt msg
