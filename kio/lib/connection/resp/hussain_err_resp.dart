class HussainErrResp {
  final String message;
  final String exception;
  final List<String> errors;
  final bool success;

  HussainErrResp.fromError(String errorMessage)
      : this.message = errorMessage,
        exception = "",
        errors = [],
        success = false;

  HussainErrResp.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? "",
        exception = json['exception'] ?? "",
        errors = json['errors']?.cast<String>() ?? [],
        success = json['success'] ?? false{
    print("$json");
  }

  String get errorMessage {
    String errMess = _messageLn(message);
    errMess += _messageLn(exception);
    if (errors != null && errors.length > 0) {
      errMess += errors.reduce((value, element) => "$value\n$element");
    }
    return errMess;
  }

  String _messageLn(String m) {
    return m.isNotEmpty ? "$m\n" : "";
  }
}
