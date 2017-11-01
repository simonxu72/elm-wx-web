module WxWeb.Types exposing (..)

import YJPark.Json as Json
import YJPark.Data as Data

import Json.Encode
import Dict
import Http


type alias Value = Json.Value

type Error
    = BadEnvironment
    | ApiNotFound
    | ApiException Json.Value
    | ApiFailed Json.Value
    | ApiError Json.Value String
    | DecodeError Json.Value String


type AsyncOpState
    = Idle
    | Waiting
    | Succeed
    | Failed
