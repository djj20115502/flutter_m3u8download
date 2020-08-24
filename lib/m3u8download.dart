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
      "onDownloadPause": (s) => {
            listeners.forEach((element) {
              element.onDownloadPause(s);
            })
          },
      "onDownloadError": (s) => {
            listeners.forEach((element) {
              element.onDownloadError(s);
            })
          },
      "onDownloadPrepare": (s) => {
            listeners.forEach((element) {
              element.onDownloadPrepare(s);
            })
          },
      "onDownloadItem": (s) => {
            listeners.forEach((element) {
              element.onDownloadItem(s);
            })
          },
      "onDownloadSuccess": (s) => {
            listeners.forEach((element) {
              element.onDownloadSuccess(s);
            })
          },
      "onDownloadPending": (s) => {
            listeners.forEach((element) {
              element.onDownloadPending(s);
            })
          },
      "onDownloadProgress": (s) => {
            listeners.forEach((element) {
              element.onDownloadProgress(s);
            })
          },
    };

    _eventChannel.receiveBroadcastStream().listen((data) {
      print(data);
      map[data["type"]]?.call(M3U8Task.fromJson(data["data"]));
    });
  }

  static List<M3u8downloadListener> listeners = [];

  static addM3u8downloadListener(M3u8downloadListener listener) {
    if (listeners.contains(listener)) {
      return;
    }
    listeners.add(listener);
  }

  static bool removeM3u8downloadListener(M3u8downloadListener listener) {
    return listeners.remove(listener);
  }
}

abstract class M3u8downloadListener {
  onDownloadPause(M3U8Task m3u8task);

  onDownloadError(M3U8Task m3u8task);

  onDownloadPrepare(M3U8Task m3u8task);

  onDownloadItem(M3U8Task m3u8task);

  onDownloadSuccess(M3U8Task m3u8task);

  onDownloadPending(M3U8Task m3u8task);

  onDownloadProgress(M3U8Task m3u8task);
}
