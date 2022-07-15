class CallModel {
  CallModel({
      String? userID, 
      String? callType, 
      String? callStatus, 
      String? dateTime,}){
    _userID = userID;
    _callType = callType;
    _callStatus = callStatus;
    _dateTime = dateTime;
}

  CallModel.fromJson(dynamic json) {
    _userID = json['userID'];
    _callType = json['callType'];
    _callStatus = json['callStatus'];
    _dateTime = json['dateTime'];
  }
  String? _userID;
  String? _callType;
  String? _callStatus;
  String? _dateTime;

  String? get userID => _userID;
  String? get callType => _callType;
  String? get callStatus => _callStatus;
  String? get dateTime => _dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userID'] = _userID;
    map['callType'] = _callType;
    map['callStatus'] = _callStatus;
    map['dateTime'] = _dateTime;
    return map;
  }

}