import 'status.dart';
import 'error.dart';

/// Contains the result of verification session by Veriff.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.
class Result {
  /// [Status] enumaration describing the status of the result.
  late Status status;

  /// [Error] enumaration describing the error in case result is .error.
  Error? error;

  Result(Status status, Error? error) {
    this.status = status;
    this.error = error;
  }
}
