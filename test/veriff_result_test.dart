import 'package:flutter_test/flutter_test.dart';
import 'package:veriff_flutter/src/error.dart';
import 'package:veriff_flutter/src/result.dart';
import 'package:veriff_flutter/src/result_parser.dart';
import 'package:veriff_flutter/src/status.dart';

void main() {
  ResultParser? parser;

  setUp(() {
    parser = ResultParser();
  });
  tearDown(() {
    parser = null;
  });

  test("Test result parsing is correct for done", () async {
    Map<String, dynamic> resultMap = {"status": 1};
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.done);
  });

  test("Test result parsing is correct for cancelled", () async {
    Map<String, dynamic> resultMap = {"status": 0};
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.canceled);
  });

  test("Test result parsing is correct for camera error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1,
      "error": Error.cameraUnavailable.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.cameraUnavailable);

    resultMap = {"status": -1, "error": Error.cameraUnavailable.errorString()};
    result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.cameraUnavailable);
  });

  test("Test result parsing is correct for audio error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1,
      "error": Error.microphoneUnavailable.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.microphoneUnavailable);

    resultMap = {"status": -1, "error": Error.microphoneUnavailable.errorString()};
    result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.microphoneUnavailable);
  });

  test("Test result parsing is correct for sdk version error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1,
      "error": Error.deprecatedSDKVersion.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error!, Error.deprecatedSDKVersion);
  });

  test("Test result parsing is correct for nfc error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1,
      "error": Error.nfcError.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.nfcError);

    resultMap = {"status": -1, "error": Error.nfcError.errorString()};
    result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.nfcError);
  });

  test("Test result parsing is correct for session error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1, 
      "error": Error.sessionError.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.sessionError);
  });

  test("Test result parsing is correct for network error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1, 
      "error": Error.networkError.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.networkError);
  });

  test("Test result parsing is correct for setup error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1, 
      "error": Error.setupError.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.setupError);
  });

  test("Test result parsing is correct for setup error", () async {
    Map<String, dynamic> resultMap = {
      "status": -1, 
      "error": Error.unknown.errorString()
    };
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, Error.unknown);
  });

  test("Test result parsing is correct for none error", () async {
    Map<String, dynamic> resultMap = {"status": -1};
    Result result = parser!.fromResultMap(resultMap);
    expect(result.status, Status.error);
    expect(result.error, null);
  });
}
