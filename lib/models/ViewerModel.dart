// ignore_for_file: file_names

class ViewerModel {
  ViewerModel({
    String? id,
    String? phoneNumber,
    String? dateTime,}){
    _id = id;
    _phoneNumber = phoneNumber;
    _dateTime = dateTime;
  }

  ViewerModel.fromJson(dynamic json) {
    _id = json['id'];
    _phoneNumber = json['phoneNumber'];
    _dateTime = json['dateTime'];
  }
  String? _id;
  String? _phoneNumber;
  String? _dateTime;

  String? get id => _id;
  String? get phoneNumber => _phoneNumber;
  String? get dateTime => _dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phoneNumber'] = _phoneNumber;
    map['dateTime'] = _dateTime;
    return map;
  }

}