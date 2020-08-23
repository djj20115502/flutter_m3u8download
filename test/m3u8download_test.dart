import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3u8download/m3u8download.dart';

void main() {
  const MethodChannel channel = MethodChannel('m3u8download');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await M3u8download.platformVersion, '42');
  });
}
