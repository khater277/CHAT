class StoryModel {
  StoryModel({
      String? phone, 
      String? date, 
      String? text, 
      String? media, 
      bool? isVideo,
      bool? isImage,
      bool? isRead,}){
    _phone = phone;
    _date = date;
    _text = text;
    _media = media;
    _isVideo = isVideo;
    _isImage = isImage;
    _isRead = isRead;
}

  StoryModel.fromJson(dynamic json) {
    _phone = json['phone'];
    _date = json['date'];
    _text = json['text'];
    _media = json['media'];
    _isVideo = json['isVideo'];
    _isImage = json['isImage'];
    _isRead = json['isRead'];
  }
  String? _phone;
  String? _date;
  String? _text;
  String? _media;
  bool? _isVideo;
  bool? _isImage;
  bool? _isRead;

  String? get phone => _phone;
  String? get date => _date;
  String? get text => _text;
  String? get media => _media;
  bool? get isVideo => _isVideo;
  bool? get isImage => _isImage;
  bool? get isRead => _isRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['date'] = _date;
    map['text'] = _text;
    map['media'] = _media;
    map['isVideo'] = _isVideo;
    map['isImage'] = _isImage;
    map['isRead'] = _isRead;
    return map;
  }

}