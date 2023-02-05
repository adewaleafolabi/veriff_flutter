/// Contains public constants used in Veriff plugin.
///
/// See relevant documentation at
/// https://developers.veriff.com/#flutter-integration.
const String VERIFF_START = "veriffStart";
//todo remove this before release
// these do not follow dart conventions, let's update them
// https://dart.dev/guides/language/effective-dart/style#prefer-using-lowercamelcase-for-constant-names
const String GET_PLATFORM_VERSION = "getPlatformVersion";
const int RESULT_STATUS_DONE = 1;
const int RESULT_STATUS_CANCELLED = 0;
const int RESULT_STATUS_ERROR = -1;
const String RESULT_KEY_STATUS = "status";
const String RESULT_KEY_ERROR = "error";
