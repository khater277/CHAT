class UserModel {
  UserModel({
      String? token,
      String? name,
      String? uId,
      String? phone,
      String? image,}){
    _token = token;
    _name = name;
    _uId = uId;
    _phone = phone;
    _image = image;
}

  UserModel.fromJson(dynamic json) {
    _token = json['token'];
    _name = json['name'];
    _uId = json['uId'];
    _phone = json['phone'];
    _image = json['image'];
  }
  String? _token;
  String? _name;
  String? _uId;
  String? _phone;
  String? _image;

  String? get token => _token;
  String? get name => _name;
  String? get uId => _uId;
  String? get phone => _phone;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['name'] = _name;
    map['uId'] = _uId;
    map['phone'] = _phone;
    map['image'] = _image;
    return map;
  }

}