module WxWeb.Internal.Wx exposing (config, call)
import Native.WxWeb
import WxWeb.Types exposing (..)

import YJPark.Json exposing (null)

import Json.Encode

import Task exposing (..)
import Dict


logFailed : String -> Value -> Error -> Error
logFailed api data error =
    let
        (err, res) = case error of
            BadEnvironment ->
                ("BadEnvironment", null)
            ApiNotFound ->
                ("ApiNotFound", null)
            ApiException res ->
                ("ApiException", res)
            ApiFailed res ->
                ("ApiFailed", res)
            ApiError res str ->
                ("ApiError:" ++ str, res)
            DecodeError res str ->
                ("DecodeError: " ++ str, res)
        _ = Native.WxWeb.logFailed api data err res
    in
        error


logSucceed : String -> Value -> msg -> Task Error msg
logSucceed api data msg =
    let
        _ = Native.WxWeb.logSucceed api data msg
    in
        succeed msg


config : Value -> Task Error msg
config data =
    Native.WxWeb.config data
        |> andThen (logSucceed "config" data)
        |> mapError (logFailed "config" data)


call : String -> Value -> (Value -> Task Error msg) -> Task Error msg
call api data onSucceed =
    Native.WxWeb.call api data
        |> andThen onSucceed
        |> andThen (logSucceed api data)
        |> mapError (logFailed api data)

