import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m3u8download/data.dart';
import 'package:m3u8download/m3u8download.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await M3u8download.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    M3u8download.addM3u8downloadListener(Test());
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
              child: Text('Running on: $_platformVersion\n'),
              onTap: () => {
                    M3u8download.download(
                        "http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4"),
                  }),
        ),
      ),
    );
  }
}

class Test extends M3u8downloadListener {
  @override
  onDownloadError(M3U8Task m3u8task) {
    print(m3u8task);
  }

  @override
  onDownloadItem(M3U8Task m3u8task) {
    print(m3u8task);
  }

  @override
  onDownloadPause(M3U8Task m3u8task) {
    print(m3u8task);
  }

  @override
  onDownloadPending(M3U8Task m3u8task) {
    print(m3u8task);
  }

  @override
  onDownloadPrepare(M3U8Task m3u8task) {
    print(m3u8task);
  }

  @override
  onDownloadProgress(M3U8Task m3u8task) {
    print(m3u8task);
  }

  @override
  onDownloadSuccess(M3U8Task m3u8task) {
    print(m3u8task);
  }
}
