module WxWeb.Api.ShowMenuItems exposing (MenuItem(..), call, cmd)

import WxWeb.Types exposing (..)
import WxWeb.Internal.Wx as Wx

import YJPark.Data as Data

import Task exposing (..)
import Json.Decode exposing (decodeValue, string, field)
import Json.Encode as Encode


type MenuItem
    = ShareAppMesage
    | ShareTimeline
    | ShareQQ
    | ShareWeibo
    | ShareQZone


encodeMenuItem : MenuItem -> String
encodeMenuItem item =
    case item of
        ShareAppMesage -> "menuItem:share:appMessage"
        ShareTimeline -> "menuItem:share:timeline"
        ShareQQ -> "menuItem:share:qq"
        ShareWeibo -> "menuItem:share:weiboApp"
        ShareQZone -> "menuItem:share:QZone"


--附录3-所有菜单项列表
--基本类
--举报: "menuItem:exposeArticle"
--调整字体: "menuItem:setFont"
--日间模式: "menuItem:dayMode"
--夜间模式: "menuItem:nightMode"
--刷新: "menuItem:refresh"
--查看公众号（已添加）: "menuItem:profile"
--查看公众号（未添加）: "menuItem:addContact"
--传播类
--发送给朋友: "menuItem:share:appMessage"
--分享到朋友圈: "menuItem:share:timeline"
--分享到QQ: "menuItem:share:qq"
--分享到Weibo: "menuItem:share:weiboApp"
--收藏: "menuItem:favorite"
--分享到FB: "menuItem:share:facebook"
--分享到 QQ 空间/menuItem:share:QZone
--保护类
--编辑标签: "menuItem:editTag"
--删除: "menuItem:delete"
--复制链接: "menuItem:copyUrl"
--原网页: "menuItem:originPage"
--阅读模式: "menuItem:readMode"
--在QQ浏览器中打开: "menuItem:openWithQQBrowser"
--在Safari中打开: "menuItem:openWithSafari"
--邮件: "menuItem:share:email"
--一些特殊公众号: "menuItem:share:brand"


encodeMenuItems : List MenuItem -> Value
encodeMenuItems items =
    items
        |> List.map encodeMenuItem
        |> List.map Encode.string
        |> Encode.list


onSucceed : Value -> Task Error Value
onSucceed res =
    succeed res


call : List MenuItem -> Task Error Value
call items =
    let
        val =
            Data.empty
                |> Data.insertValue "menuList" (encodeMenuItems items)
                |> Data.toValue
    in
        Wx.call "showMenuItems" val onSucceed


cmd : List MenuItem -> (Result Error Value -> msg) -> Cmd msg
cmd items msg =
    call items
        |> attempt msg
