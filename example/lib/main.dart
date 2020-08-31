import 'dart:async';

import 'package:flutter/foundation.dart';
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
    M3u8download.initM3u8download("secretKey");
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
                        "http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8"),
                  }),
        ),
      ),
    );
  }
}

class Test extends M3u8downloadListener {
  @override
  onDownloadError(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }

  @override
  onDownloadItem(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }

  @override
  onDownloadPause(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }

  @override
  onDownloadPending(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }

  @override
  onDownloadPrepare(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }

  @override
  onDownloadProgress(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }

  @override
  onDownloadSuccess(M3U8Task m3u8task) {
    CommonUtils.log(m3u8task);
  }
}
abstract class CommonUtils {
  static log(Object s) {
    _print(s.toString());
  }

  static log2(List s) {
    _print(s.toString());
  }

  static _print(String s) {

    String all = StackTrace.current.toString();
    List<String> show = [];
    if (kIsWeb == true) {
      show = all.split("package");
      show.addAll(["空", "空", "空", "空", "空"]);
      show = List<String>()..add(show[4])..add(show[5]);
    } else {
      if (all.contains("#3")) {
        show.add(all.substring(all.indexOf("#2"), all.indexOf("#3")));
      }
      if (all.contains("#4")) {
        show.add(all.substring(all.indexOf("#3"), all.indexOf("#4")));
      }
      show.addAll(["空", "空", "空", "空", "空"]);
    }
    _printOne(show[0], show[1], s);
  }

  static const int MAX_LEN = 500;

  static _printOne(String p1, String p2, String content) {

    while (content.length > MAX_LEN) {
      _printOne(p1, p2, content.substring(0, MAX_LEN));
      content = content.substring(MAX_LEN);
    }
    StringBuffer sb = new StringBuffer();
    sb.write(" \n╔═════════════════════════════════");
    sb.write("\n║➨➨at ");
    sb.write(p1);
    sb.write("║➨➨➨➨at ");
    sb.write(p2);
    sb.write("╟───────────────────────────────────\n");
    sb.write("║");
    sb.write("djjtest:" + content);
    sb.write("\n╚═════════════════════════════════");
    print(sb.toString());
  }


  //web 端的表现
  //package:build_web_compilers/src/dev_compiler/C:/b/s/w/ir/cache/builder/src/out/host_debug/dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 248:20  get current
  //package:kanju/debug.dart 79:29                                                                                                                                 _print
  //package:kanju/debug.dart 72:5                                                                                                                                  log2
  //package:kanju/main.dart 26:17                                                                                                                                  build
  //package:flutter/src/widgets/framework.dart 4364:28                                                                                                                      build
  //package:flutter/src/widgets/framework.dart 4296:15                                                                                                                      performRebuild
  //package:flutter/src/widgets/framework.dart 4020:5                                                                                                                       rebuild
  //package:flutter/src/widgets/framework.dart 4279:5                                                                                                                       [_firstBuild]
  //package:flutter/src/widgets/framework.dart 4274:5                                                                                                                       mount
  //package:flutter/src/widgets/framework.dart 3269:13                                                                                                                      inflateWidget
  //package:flutter/src/widgets/framework.dart 3063:12                                                                                                                      updateChild
  //package:flutter/src/widgets/binding.dart 1054:16                                                                                                                        [_rebuild]
  //package:flutter/src/widgets/binding.dart 1025:5                                                                                                                         mount
  //package:flutter/src/widgets/binding.dart 968:16                                                                                                                         <fn>
  //package:flutter/src/widgets/framework.dart 2487:19                                                                                                                      buildScope
  //package:flutter/src/widgets/binding.dart 967:12                                                                                                                         attachToRenderTree
  //package:flutter/src/widgets/binding.dart 847:24                                                                                                                         attachRootWidget
  //package:flutter/src/widgets/binding.dart 830:7                                                                                                                          <fn>
  //package:build_web_compilers/src/dev_compiler/C:/b/s/w/ir/cache/builder/src/out/host_debug/dart-sdk/lib/_internal/js_dev_runtime/private/isolate_helper.dart 50:19

  static printStackTrace(String s) {

    String all = StackTrace.current.toString();
    print("djjtest:" + s + all);
  }

  static int testCount = 0;

  static Color getTestColor() {
    testCount++;
    switch (testCount % 2) {
      case 0:
        return Color(0x33FFFF00);
      case 1:
        return Color(0x3300FFFF);
    }
  }

  static String listToString(List<String> list,
      {String div = ",", String coverL = "", String coverR = ""}) {
    if (list == null || list.length == 0) {
      return "null";
    }
    StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.write(coverL + list[0] + coverR);
    for (int i = 1; i < list.length; i++) {
      stringBuffer.write(div + coverL + list[i] + coverR);
    }

    return stringBuffer.toString();
  }


}