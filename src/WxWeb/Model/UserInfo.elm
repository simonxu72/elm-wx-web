module WxWeb.Model.UserInfo exposing (Type, null, decoder, encode)
import WxWeb.Model.UserGender as Gender

import WxWeb.Types exposing (..)
import YJPark.Data exposing (..)

import Json.Decode exposing (int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

type alias Value = YJPark.Data.Value

type alias Type =
    { nickName : String
    , gender : Gender.Type
    , city : String
    , province : String
    , country : String
    , avatarUrl : String
    }


null : Type
null =
    { nickName = ""
    , gender = Gender.unknown
    , city = ""
    , province = ""
    , country = ""
    , avatarUrl = ""
    }


decoder : Decoder Type
decoder =
    decode Type
        |> required "nickName" string
        |> optional "gender" Gender.decoder Gender.unknown
        |> optional "city" string ""
        |> optional "province" string ""
        |> optional "country" string ""
        |> optional "avatarUrl" string ""


encode : Type -> Value
encode info =
    empty
        |> insertString "nickName" info.nickName
        |> insertInt "gender" (Gender.encode info.gender)
        |> insertString "city" info.city
        |> insertString "province" info.province
        |> insertString "country" info.country
        |> insertString "avatarUrl" info.avatarUrl
        |> toValue
