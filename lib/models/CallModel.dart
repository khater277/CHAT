class CallModel {
  CallModel({
      String? userID, 
      String? phoneNumber,
      String? callType,
      String? callStatus, 
      String? dateTime,}){
    _userID = userID;
    _phoneNumber = phoneNumber;
    _callType = callType;
    _callStatus = callStatus;
    _dateTime = dateTime;
}

  CallModel.fromJson(dynamic json) {
    _userID = json['userID'];
    _phoneNumber = json['phoneNumber'];
    _callType = json['callType'];
    _callStatus = json['callStatus'];
    _dateTime = json['dateTime'];
  }
  String? _userID;
  String? _phoneNumber;
  String? _callType;
  String? _callStatus;
  String? _dateTime;

  String? get userID => _userID;
  String? get phoneNumber => _phoneNumber;
  String? get callType => _callType;
  String? get callStatus => _callStatus;
  String? get dateTime => _dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userID'] = _userID;
    map['phoneNumber'] = _phoneNumber;
    map['callType'] = _callType;
    map['callStatus'] = _callStatus;
    map['dateTime'] = _dateTime;
    return map;
  }

}