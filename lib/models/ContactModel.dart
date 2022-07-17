// ignore_for_file: file_names

class ContactModel {
  ContactModel({
      String? phoneNumber, 
      String? name,}){
    _phoneNumber = phoneNumber;
    _name = name;
}

  ContactModel.fromJson(dynamic json) {
    _phoneNumber = json['phoneNumber'];
    _name = json['name'];
  }
  String? _phoneNumber;
  String? _name;

  String? get phoneNumber => _phoneNumber;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = _phoneNumber;
    map['name'] = _name;
    return map;
  }

}