import 'dart:async';

import 'package:flutter/services.dart';

class M3u8download {
  static const MethodChannel _channel = const MethodChannel('m3u8download');
  static const EventChannel _eventChannel =
      const EventChannel("m3u8download_event");

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
