import 'dart:async';
import 'package:flutter/services.dart';
import 'package:veriff_flutter/src/constants.dart';
import 'package:veriff_flutter/src/result_parser.dart';
import 'configuration.dart';
import 'result.dart';

/// Contains the methods to use Veriff plugin.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.

class Veriff {
  /// MethodChannel to communicate with platform specific code.
  final MethodChannel channel;
  static const String name = "com.veriff.flutter";

  /// Creates a [Veriff] object.
  Veriff() : channel = MethodChannel(name);

  /// Returs the platform version
  Future<String> get platformVersion async {
    final String version = await channel.invokeMethod(GET_PLATFORM_VERSION);
    return version;
  }

  /// Starts the verification session.
  Future<Result> start(Configuration config) async {
    final Map resultMap =
        await channel.invokeMethod(VERIFF_START, config.asMap());
    return ResultParser().fromResultMap(resultMap);
  }
}
