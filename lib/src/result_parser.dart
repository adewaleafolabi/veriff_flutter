import 'error.dart';
import 'status.dart';
import 'result.dart';
import 'constants.dart';

///
/// Maps the result map from platform channel to [Result] object
/// Expected result map from channel
/// "status": [Status]
/// "error" => optional string. Please refer to [Error] for possible values
///
class ResultParser {
  Result fromResultMap(Map resultMap) {
    int status = resultMap[RESULT_KEY_STATUS];
    String? error = resultMap[RESULT_KEY_ERROR];
    switch (status) {
      case RESULT_STATUS_DONE:
        return Result(Status.done, Error.none);
      case RESULT_STATUS_CANCELLED:
        return Result(Status.canceled, error?.stringError());
      case RESULT_STATUS_ERROR:
      default:
        return Result(Status.error, error?.stringError());
    }
  }
}
