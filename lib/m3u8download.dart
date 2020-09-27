import 'dart:async';
import 'dart:convert';

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
      print("_eventChannel");
      print(data);
      map[data["type"]]?.call(M3U8Task.fromJson(json.decode(data["data"])));
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

  static cancel(String url) {
    _channel.invokeMethod('cancel', {"url": url});
  }

  static download(String url) {
    _channel.invokeMethod('download', {"url": url});
  }

  static pause(String url) {
    _channel.invokeMethod('pause', {"url": url});
  }

  static Future<String> getM3U8Path(String url) async {
    var path = await _channel.invokeMethod('getM3U8Path', {"url": url});
    return path;
  }

  static Future<bool> checkM3U8IsExist(String url) async {
    final bool exist =
        await _channel.invokeMethod('checkM3U8IsExist', {"url": url});
    return exist;
  }

  static Future<bool> isCurrentTask(String url) async {
    final bool isCurrentTask =
        await _channel.invokeMethod('isCurrentTask', {"url": url});
    return isCurrentTask;
  }

  static setEncryptKey(String encryptKey) {
    _channel.invokeMethod('setEncryptKey', {"encryptKey": encryptKey});
  }

  static Future<String> getEncryptKey() async {
    final String encryptKey = await _channel.invokeMethod('getEncryptKey');
    return encryptKey;
  }
  static Future<String> getFileSize(int size) async {
    final String size = await _channel.invokeMethod('getFileSize', {"size": size});
    return size;
  }

  static cancelAndDelete(String url) {
    _channel.invokeMethod('cancelAndDelete', {"url": url});
  }

  static encrypt() {
    _channel.invokeMethod('encrypt');
  }

  static decrypt() {
    _channel.invokeMethod('decrypt');
  }

  static finish() {
    _channel.invokeMethod('finish');
  }

  static execute() {
    _channel.invokeMethod('execute');
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
