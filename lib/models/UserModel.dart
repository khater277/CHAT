// ignore_for_file: file_names

class UserModel {
  UserModel({
      String? token,
      String? name,
      String? uId,
      String? phone,
      String? image,
      bool? inCall,}){
    _token = token;
    _name = name;
    _uId = uId;
    _phone = phone;
    _image = image;
    _inCall = inCall;
}

  UserModel.fromJson(dynamic json) {
    _token = json['token'];
    _name = json['name'];
    _uId = json['uId'];
    _phone = json['phone'];
    _image = json['image'];
    _inCall = json['inCall'];
  }
  String? _token;
  String? _name;
  String? _uId;
  String? _phone;
  String? _image;
  bool? _inCall;

  String? get token => _token;
  String? get name => _name;
  String? get uId => _uId;
  String? get phone => _phone;
  String? get image => _image;
  bool? get inCall => _inCall;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['name'] = _name;
    map['uId'] = _uId;
    map['phone'] = _phone;
    map['image'] = _image;
    map['inCall'] = _inCall;
    return map;
  }

}