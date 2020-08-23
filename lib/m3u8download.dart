import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'data.dart';

class M3u8download {
  static const MethodChannel _channel = const MethodChannel('m3u8download');
  static const EventChannel _eventChannel =
      const EventChannel("m3u8download_event");

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //初始化sdk
  //返回值：初始化成功与否
  static Future<bool> initM3u8download(String secretKey) async {
    //初始化的时候注册eventChannel回调
    eventChannelDistribution();
//    return _channel.invokeMethod(
//        "initLBSdk", {"appid": appid, "secretKey": secretKey}).then((data) {
//      return data;
//    });
  }

  static eventChannelDistribution() {
    Map<String, ValueChanged<M3U8Task>> map = {
      "onDownloadPause": null,
      "onDownloadError": null,
      "onDownloadPrepare": null,
      "onDownloadItem": null,
      "onDownloadSuccess": null,
      "onDownloadPending": null,
      "onDownloadProgress": null,
    };

    _eventChannel.receiveBroadcastStream().listen((data) {
      print(data);
      map[data["type"]]?.call(M3U8Task.fromJson(data["data"]));
    });
  }
}
