class MessageModel {
  MessageModel({
      String? senderID, 
      String? receiverID, 
      String? message, 
      String? storyMedia,
      String? media,
      bool? isImage,
      bool? isStoryReply,
      bool? isStoryVideoReply,
      bool? isVideo,
      bool? isDoc,
      bool? isDeleted,
      String? date,
      String? storyDate,
  }){
    _senderID = senderID;
    _receiverID = receiverID;
    _message = message;
    _storyMedia = storyMedia;
    _media = media;
    _isStoryReply = isStoryReply;
    _isStoryVideoReply = isStoryVideoReply;
    _isImage = isImage;
    _isVideo = isVideo;
    _isDoc = isDoc;
    _isDeleted = isDeleted;
    _date = date;
    _storyDate = storyDate;
}

  MessageModel.fromJson(dynamic json) {
    _senderID = json['senderID'];
    _receiverID = json['receiverID'];
    _message = json['message'];
    _media = json['media'];
    _storyMedia = json['storyMedia'];
    _isStoryReply = json['isStoryReply'];
    _isStoryVideoReply = json['isStoryVideoReply'];
    _isImage = json['isImage'];
    _isVideo = json['isVideo'];
    _isDoc = json['isDoc'];
    _isDeleted = json['isDeleted'];
    _date = json['date'];
    _storyDate = json['storyDate'];
  }
  String? _senderID;
  String? _receiverID;
  String? _message;
  String? _media;
  String? _storyMedia;
  bool? _isStoryReply;
  bool? _isStoryVideoReply;
  bool? _isImage;
  bool? _isVideo;
  bool? _isDoc;
  bool? _isDeleted;
  String? _date;
  String? _storyDate;

  String? get senderID => _senderID;
  String? get receiverID => _receiverID;
  String? get message => _message;
  String? get media => _media;
  String? get storyMedia => _storyMedia;
  bool? get isStoryReply => _isStoryReply;
  bool? get isStoryVideoReply => _isStoryVideoReply;
  bool? get isImage => _isImage;
  bool? get isVideo => _isVideo;
  bool? get isDoc => _isDoc;
  bool? get isDeleted => _isDeleted;
  String? get date => _date;
  String? get storyDate => _storyDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['senderID'] = _senderID;
    map['receiverID'] = _receiverID;
    map['message'] = _message;
    map['media'] = _media;
    map['storyMedia'] = _storyMedia;
    map['isStoryReply'] = _isStoryReply;
    map['isStoryVideoReply'] = _isStoryVideoReply;
    map['isImage'] = isImage;
    map['isVideo'] = isVideo;
    map['isDoc'] = isDoc;
    map['isDeleted'] = isDeleted;
    map['date'] = _date;
    map['storyDate'] = _storyDate;
    return map;
  }

}