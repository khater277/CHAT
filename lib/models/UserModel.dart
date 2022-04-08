class UserModel {
  UserModel({
      String? uId,
      String? phone, 
      String? image,}){
    _uId = uId;
    _phone = phone;
    _image = image;
}

  UserModel.fromJson(dynamic json) {
    _uId = json['uId'];
    _phone = json['phone'];
    _image = json['image'];
  }
  String? _uId;
  String? _phone;
  String? _image;

  String? get uId => _uId;
  String? get phone => _phone;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uId'] = _uId;
    map['phone'] = _phone;
    map['image'] = _image;
    return map;
  }

}