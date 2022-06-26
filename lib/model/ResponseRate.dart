/// success : true
/// status_code : 12
/// status_message : "The item/record was updated successfully."

class ResponseRate {
  bool _success;
  int _statusCode;
  String _statusMessage;

  bool get success => _success;
  int get statusCode => _statusCode;
  String get statusMessage => _statusMessage;

  ResponseRate({
      bool success, 
      int statusCode, 
      String statusMessage}){
    _success = success;
    _statusCode = statusCode;
    _statusMessage = statusMessage;
}

  ResponseRate.fromJson(dynamic json) {
    _success = json["success"];
    _statusCode = json["status_code"];
    _statusMessage = json["status_message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["success"] = _success;
    map["status_code"] = _statusCode;
    map["status_message"] = _statusMessage;
    return map;
  }

}