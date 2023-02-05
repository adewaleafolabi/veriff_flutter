/// Contains the errors that can occur during verification session by Veriff.
enum Error {
  /// User did not give permission for the camera.
  cameraUnavailable,

  /// User did not give permission for the microphone.
  microphoneUnavailable,

  /// Network error occurred.
  networkError,

  /// A local error happened before submitting the session.
  sessionError,

  /// Version of Veriff SDK used in plugin has been deprecated. Please update to the latest version.
  deprecatedSDKVersion,

  /// Uknown error occurred.
  unknown,

  /// Error with NFC
  nfcError,

  /// Error with setup
  setupError,

  /// No error.
  none
}

/// Returns [Error] for string
extension ErrorExtension on String {
  Error stringError() {
    switch (this) {
      case "cameraUnavailable":
        return Error.cameraUnavailable;
      case "microphoneUnavailable":
        return Error.microphoneUnavailable;
      case "networkError":
        return Error.networkError;
      case "sessionError":
        return Error.sessionError;
      case "deprecatedSDKVersion":
        return Error.deprecatedSDKVersion;
      case "unknown":
        return Error.unknown;
      case "nfcError":
        return Error.nfcError;
      case "setupError":
        return Error.setupError;
      case "none":
        return Error.none;
      default:
        return Error.unknown;
    }
  }
}

/// Returns string for [Error]
extension StringExtension on Error {
  String errorString() {
    switch (this) {
      case Error.cameraUnavailable:
        return "cameraUnavailable";
      case Error.microphoneUnavailable:
        return "microphoneUnavailable";
      case Error.networkError:
        return "networkError";
      case Error.sessionError:
        return "sessionError";
      case Error.deprecatedSDKVersion:
        return "deprecatedSDKVersion";
      case Error.unknown:
        return "unknown";
      case Error.nfcError:
        return "nfcError";
      case Error.setupError:
        return "setupError";
      case Error.none:
        return "none";
      default:
        return "unknown";
    }
  }
}
