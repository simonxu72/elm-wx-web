module WxWeb.Api.ChooseWXPay exposing (Order, call, cmd, callWithValue, cmdWithValue)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)
import Json.Decode exposing (decodeValue, string, field)
import Json.Encode as Encode


type alias Order =
    { timestamp: Int
    , nonceStr: String
    , prepay_id: String
    , signType: String
    , paySign: String
    }


encodeOrder : Order -> Value
encodeOrder order =
    Data.empty
        |> Data.insertInt "timestamp" order.timestamp
        |> Data.insertString "nonceStr" order.nonceStr
        |> Data.insertString "package" ("prepay_id=" ++ order.prepay_id)
        |> Data.insertString "signType" order.signType
        |> Data.insertString "paySign" order.paySign
        |> Data.toValue


onSucceed : Value -> Task Error Value
onSucceed res =
    succeed res


callWithValue : Value -> Task Error Value
callWithValue order =
    Wx.call "chooseWXPay" order onSucceed


call : Order -> Task Error Value
call order =
    callWithValue <| encodeOrder order


cmd : Order -> (Result Error Value -> msg) -> Cmd msg
cmd order msg =
    call order
        |> attempt msg


cmdWithValue : Value -> (Result Error Value -> msg) -> Cmd msg
cmdWithValue order msg =
    callWithValue order
        |> attempt msg
