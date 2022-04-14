class LastMessageModel {
  LastMessageModel({
      String? senderID, 
      String? receiverID, 
      String? message, 
      String? image, 
      String? date, 
      bool? isRead,}){
    _senderID = senderID;
    _receiverID = receiverID;
    _message = message;
    _image = image;
    _date = date;
    _isRead = isRead;
}

  LastMessageModel.fromJson(dynamic json) {
    _senderID = json['senderID'];
    _receiverID = json['receiverID'];
    _message = json['message'];
    _image = json['image'];
    _date = json['date'];
    _isRead = json['isRead'];
  }
  String? _senderID;
  String? _receiverID;
  String? _message;
  String? _image;
  String? _date;
  bool? _isRead;

  String? get senderID => _senderID;
  String? get receiverID => _receiverID;
  String? get message => _message;
  String? get image => _image;
  String? get date => _date;
  bool? get isRead => _isRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['senderID'] = _senderID;
    map['receiverID'] = _receiverID;
    map['message'] = _message;
    map['image'] = _image;
    map['date'] = _date;
    map['isRead'] = _isRead;
    return map;
  }

}