class MessageModel {
  MessageModel({
      String? senderID, 
      String? receiverID, 
      String? message, 
      String? image, 
      String? date,}){
    _senderID = senderID;
    _receiverID = receiverID;
    _message = message;
    _image = image;
    _date = date;
}

  MessageModel.fromJson(dynamic json) {
    _senderID = json['senderID'];
    _receiverID = json['receiverID'];
    _message = json['message'];
    _image = json['image'];
    _date = json['date'];
  }
  String? _senderID;
  String? _receiverID;
  String? _message;
  String? _image;
  String? _date;

  String? get senderID => _senderID;
  String? get receiverID => _receiverID;
  String? get message => _message;
  String? get image => _image;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['senderID'] = _senderID;
    map['receiverID'] = _receiverID;
    map['message'] = _message;
    map['image'] = _image;
    map['date'] = _date;
    return map;
  }

}