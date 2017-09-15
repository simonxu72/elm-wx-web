module WxWeb.Model.JsApi exposing (..)

import WxWeb.Types exposing (..)
import YJPark.Data as Data exposing (..)

import Json.Encode as Encode
import Json.Decode as Decode exposing (int, string, float, nullable, Decoder, succeed, andThen)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


type Type
    = Invalid
    | OnMenuShareTimeline
    | OnMenuShareAppMessage
    | OnMenuShareQQ
    | OnMenuShareWeibo
    | OnMenuShareQZone
    | StartRecord
    | StopRecord
    | OnVoiceRecordEnd
    | PlayVoice
    | PauseVoice
    | StopVoice
    | OnVoicePlayEnd
    | UploadVoice
    | DownloadVoice
    | ChooseImage
    | PreviewImage
    | UploadImage
    | DownloadImage
    | TranslateVoice
    | GetNetworkType
    | OpenLocation
    | GetLocation
    | HideOptionMenu
    | ShowOptionMenu
    | HideMenuItems
    | ShowMenuItems
    | HideAllNonBaseMenuItem
    | ShowAllNonBaseMenuItem
    | CloseWindow
    | ScanQRCode
    | ChooseWXPay
    | OpenProductSpecificView
    | AddCard
    | ChooseCard
    | OpenCard


encode : Type -> String
encode api =
    case api of
        Invalid -> ""
        OnMenuShareTimeline -> "onMenuShareTimeline"
        OnMenuShareAppMessage -> "onMenuShareAppMessage"
        OnMenuShareQQ -> "onMenuShareQQ"
        OnMenuShareWeibo -> "onMenuShareWeibo"
        OnMenuShareQZone -> "onMenuShareQZone"
        StartRecord -> "startRecord"
        StopRecord -> "stopRecord"
        OnVoiceRecordEnd -> "onVoiceRecordEnd"
        PlayVoice -> "playVoice"
        PauseVoice -> "pauseVoice"
        StopVoice -> "stopVoice"
        OnVoicePlayEnd -> "onVoicePlayEnd"
        UploadVoice -> "uploadVoice"
        DownloadVoice -> "downloadVoice"
        ChooseImage -> "chooseImage"
        PreviewImage -> "previewImage"
        UploadImage -> "uploadImage"
        DownloadImage -> "downloadImage"
        TranslateVoice -> "translateVoice"
        GetNetworkType -> "getNetworkType"
        OpenLocation -> "openLocation"
        GetLocation -> "getLocation"
        HideOptionMenu -> "hideOptionMenu"
        ShowOptionMenu -> "showOptionMenu"
        HideMenuItems -> "hideMenuItems"
        ShowMenuItems -> "showMenuItems"
        HideAllNonBaseMenuItem -> "hideAllNonBaseMenuItem"
        ShowAllNonBaseMenuItem -> "showAllNonBaseMenuItem"
        CloseWindow -> "closeWindow"
        ScanQRCode -> "scanQRCode"
        ChooseWXPay -> "chooseWXPay"
        OpenProductSpecificView -> "openProductSpecificView"
        AddCard -> "addCard"
        ChooseCard -> "chooseCard"
        OpenCard -> "openCard"


encodeList : List Type -> Data.Value
encodeList apis =
    apis
        |> List.map encode
        |> List.map Encode.string
        |> Encode.list


parse : String -> Type
parse api =
    case api of
        "onMenuShareTimeline" -> OnMenuShareTimeline
        "onMenuShareAppMessage" -> OnMenuShareAppMessage
        "onMenuShareQQ" -> OnMenuShareQQ
        "onMenuShareWeibo" -> OnMenuShareWeibo
        "onMenuShareQZone" -> OnMenuShareQZone
        "startRecord" -> StartRecord
        "stopRecord" -> StopRecord
        "onVoiceRecordEnd" -> OnVoiceRecordEnd
        "playVoice" -> PlayVoice
        "pauseVoice" -> PauseVoice
        "stopVoice" -> StopVoice
        "onVoicePlayEnd" -> OnVoicePlayEnd
        "uploadVoice" -> UploadVoice
        "downloadVoice" -> DownloadVoice
        "chooseImage" -> ChooseImage
        "previewImage" -> PreviewImage
        "uploadImage" -> UploadImage
        "downloadImage" -> DownloadImage
        "translateVoice" -> TranslateVoice
        "getNetworkType" -> GetNetworkType
        "openLocation" -> OpenLocation
        "getLocation" -> GetLocation
        "hideOptionMenu" -> HideOptionMenu
        "showOptionMenu" -> ShowOptionMenu
        "hideMenuItems" -> HideMenuItems
        "showMenuItems" -> ShowMenuItems
        "hideAllNonBaseMenuItem" -> HideAllNonBaseMenuItem
        "showAllNonBaseMenuItem" -> ShowAllNonBaseMenuItem
        "closeWindow" -> CloseWindow
        "scanQRCode" -> ScanQRCode
        "chooseWXPay" -> ChooseWXPay
        "openProductSpecificView" -> OpenProductSpecificView
        "addCard" -> AddCard
        "chooseCard" -> ChooseCard
        "openCard" -> OpenCard
        _ -> Invalid


decode : String -> Decoder Type
decode api = succeed (parse api)


decoder : Decoder Type
decoder =
   string
        |> andThen decode


listDecoder =
    Decode.list decoder

