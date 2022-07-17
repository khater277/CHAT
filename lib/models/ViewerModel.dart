class ViewerModel {
  ViewerModel({
    String? id,
    String? dateTime,}){
    _id = id;
    _dateTime = dateTime;
  }

  ViewerModel.fromJson(dynamic json) {
    _id = json['id'];
    _dateTime = json['dateTime'];
  }
  String? _id;
  String? _dateTime;

  String? get id => _id;
  String? get dateTime => _dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['dateTime'] = _dateTime;
    return map;
  }

}