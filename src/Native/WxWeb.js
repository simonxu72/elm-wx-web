// https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1421141115

var _yjpark$elm_wx_web$Native_WxWeb = function() {

var ns = _elm_lang$core$Native_Scheduler;

function config(data) {
  return ns.nativeBinding(function(callback) {
    if (typeof WeixinJSBridge == "undefined") {
      callback(ns.fail({ ctor: 'BadEnvironment' }));
      return;
    }
    var result =  wx.config(data);
    var failed = false;
    wx.error(function(res) {
      failed = true;
      callback(ns.fail({ ctor: 'ApiFailed', _0: res }));
    });
    wx.ready(function() {
      if (!failed) {
        callback(ns.succeed(data));
      }
    });
  });
}

function _call(api, data) {
  return ns.nativeBinding(function(callback) {
    if (typeof WeixinJSBridge == "undefined") {
      callback(ns.fail({ ctor: 'BadEnvironment' }));
      return;
    }
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

function getStorage(data) {
  return ns.nativeBinding(function(callback) {
    if (data && typeof(data) == "object") {
      var key = data.key;
      var _val = window.localStorage.getItem(key);
      try {
        var val = JSON.parse(_val);
        if (val != null) {
          var result = {
            "data": val
          };
          return callback(ns.succeed(result));
        } else {
          var err = {
            "errMsg": "data not exist: " + key
          };
          return callback(ns.fail({ ctor: 'ApiFailed', _0: err }));
        }
      } catch (e) {
        return callback(ns.fail({ ctor: 'ApiException', _0: e }));
      }
    } else {
      var err = {
        "errMsg": "data is not an object"
      };
      return callback(ns.fail({ ctor: 'ApiFailed', _0: err }));
    }
  });
}

function setStorage(data) {
  return ns.nativeBinding(function(callback) {
    if (data && typeof(data) == "object") {
      var key = data.key;
      var val = JSON.stringify(data.data);
      var result = window.localStorage.setItem(key, val);
      return callback(ns.succeed(result));
    } else {
      var err = {
        "errMsg": "data is not an object"
      };
      return callback(ns.fail({ ctor: 'ApiFailed', _0: err }));
    }
  });
}

function removeStorage(data) {
  return ns.nativeBinding(function(callback) {
    if (data && typeof(data) == "object") {
      var key = data.key;
      var result = window.localStorage.removeItem(key);
      return callback(ns.succeed(result));
    } else {
      var err = {
        "errMsg": "data is not an object"
      };
      return callback(ns.fail({ ctor: 'ApiFailed', _0: err }));
    }
  });
}

function clearStorage() {
  return ns.nativeBinding(function(callback) {
    var result = window.localStorage.clear();
    return callback(ns.succeed(result));
  });
}

function call(api, data) {
  if (api == "getStorage") {
    return getStorage(data);
  } else if (api == "setStorage") {
    return setStorage(data);
  } else if (api == "removeStorage") {
    return removeStorage(data);
  } else if (api == "clearStorage") {
    return clearStorage();
  } else {
    return _call(api, data);
  }
}

function logSucceed(api, data, msg) {
  console.log("[WxWeb] wx." + api + " Succeed:", data, "->", msg);
}

function logFailed(api, data, err, res) {
  console.error("[WxWeb] wx." + api + " Failed:", data, "->", err, res);
}

return {
  config: config,
  call: F2(call),
  logSucceed: F3(logSucceed),
  logFailed: F4(logFailed)
};

}();

