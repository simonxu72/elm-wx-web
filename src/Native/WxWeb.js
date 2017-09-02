// https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421141115

var _yjpark$elm_wx_web$Native_WxWeb = function() {

var ns = _elm_lang$core$Native_Scheduler;

function call(api, data) {
  return ns.nativeBinding(function(callback) {
    var func = null;
    try {
      func = wx[api];
    } catch (e) {
      return callback(ns.fail({ ctor: 'BadEnvironment' }));
    }
    if (func) {
      var params = {};
      if (data && typeof(data) == "object") {
        params = data
      }
      params.success = function(res) {
        callback(ns.succeed(res));
      }
      params.fail = function(res) {
        callback(ns.fail({ ctor: 'ApiFailed', _0: res }));
      }
      try {
        func(params);
        return function() {};
      } catch (e) {
        return callback(ns.fail({ ctor: 'ApiException', _0: e }));
      }
    } else {
      return callback(ns.fail({ ctor: 'ApiNotFound' }));
    }
  });
}

function logSucceed(api, data, msg) {
  console.log("[WxWeb] wx." + api + " Succeed:", data, "->", msg);
}

function logFailed(api, data, err, res) {
  console.error("[WxWeb] wx." + api + " Failed:", data, "->", err, res);
}

return {
  call: F2(call),
  logSucceed: F3(logSucceed),
  logFailed: F4(logFailed)
};

}();

