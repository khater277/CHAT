class LastStoryModel {
  LastStoryModel({
      String? phone, 
      String? date, 
      String? text, 
      String? media, 
      bool? isVideo, 
      bool? isImage,}){
    _phone = phone;
    _date = date;
    _text = text;
    _media = media;
    _isVideo = isVideo;
    _isImage = isImage;
}

  LastStoryModel.fromJson(dynamic json) {
    _phone = json['phone'];
    _date = json['date'];
    _text = json['text'];
    _media = json['media'];
    _isVideo = json['isVideo'];
    _isImage = json['isImage'];
  }
  String? _phone;
  String? _date;
  String? _text;
  String? _media;
  bool? _isVideo;
  bool? _isImage;

  String? get phone => _phone;
  String? get date => _date;
  String? get text => _text;
  String? get media => _media;
  bool? get isVideo => _isVideo;
  bool? get isImage => _isImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['date'] = _date;
    map['text'] = _text;
    map['media'] = _media;
    map['isVideo'] = _isVideo;
    map['isImage'] = _isImage;
    return map;
  }

}