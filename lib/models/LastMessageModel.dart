
class LastMessageModel {
  LastMessageModel({
      String? senderID, 
      String? receiverID, 
      String? message,
      String? media,
      bool? isImage,
      bool? isVideo,
      bool? isDoc,
      String? date, 
      bool? isRead,}){
    _senderID = senderID;
    _receiverID = receiverID;
    _message = message;
    _media = media;
    _isImage = isImage;
    _isVideo = isVideo;
    _isDoc = isDoc;
    _date = date;
    _isRead = isRead;
}

  LastMessageModel.fromJson(dynamic json) {
    _senderID = json['senderID'];
    _receiverID = json['receiverID'];
    _message = json['message'];
    _media = json['media'];
    _isImage = json['isImage'];
    _isVideo = json['isVideo'];
    _isDoc = json['isDoc'];
    _date = json['date'];
    _isRead = json['isRead'];
  }
  String? _senderID;
  String? _receiverID;
  String? _message;
  String? _media;
  bool? _isImage;
  bool? _isVideo;
  bool? _isDoc;
  String? _date;
  bool? _isRead;

  String? get senderID => _senderID;
  String? get receiverID => _receiverID;
  String? get message => _message;
  String? get media => _media;
  bool? get isImage => _isImage;
  bool? get isVideo => _isVideo;
  bool? get isDoc => _isDoc;
  String? get date => _date;
  bool? get isRead => _isRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['senderID'] = _senderID;
    map['receiverID'] = _receiverID;
    map['message'] = _message;
    map['media'] = _media;
    map['isImage'] = isImage;
    map['isVideo'] = isVideo;
    map['isDoc'] = isDoc;
    map['date'] = _date;
    map['isRead'] = _isRead;
    return map;
  }

}