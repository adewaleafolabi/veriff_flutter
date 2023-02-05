import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veriff_flutter/veriff_flutter.dart';
import 'package:veriff_flutter/src/status.dart';
import 'package:veriff_flutter/src/error.dart';

void main() {
  Veriff? veriff;
  MethodChannel? channel;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    veriff = Veriff();
    channel = veriff!.channel;
    channel!.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return 'X.Y.Z';
        case 'veriffStart':
          return {"status": 1};
        default:
          assert(false);
          return null;
      }
    });
  });

  tearDown(() {
    channel!.setMockMethodCallHandler(null);
    channel = null;
    veriff = null;
  });

  test('Get platform version', () async {
    expect(await veriff!.platformVersion, 'X.Y.Z');
  });

  test('Return result', () async {
    String sessionUrl = "";
    Configuration conf = Configuration(sessionUrl);
    Result received = await veriff!.start(conf);
    expect(received.status.hashCode, Status.done.hashCode);
    expect(received.error.hashCode, Error.none.hashCode);
  });
}
