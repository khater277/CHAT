// ignore_for_file: file_names

import 'package:chat/models/ViewerModel.dart';

class StoryModel {
  StoryModel({
    String? date,
    bool? isImage,
    bool? isRead,
    bool? isVideo,
    String? videoDuration,
    String? media,
    String? phone,
    String? text,
    List<ViewerModel>? viewers,
    List<String>? canView,
  }){
    _date = date;
    _isImage = isImage;
    _isRead = isRead;
    _isVideo = isVideo;
    _videoDuration = videoDuration;
    _media = media;
    _phone = phone;
    _text = text;
    _viewers = viewers;
    _canView = canView;
  }

  StoryModel.fromJson(dynamic json) {
    _date = json['date'];
    _isImage = json['isImage'];
    _isRead = json['isRead'];
    _isVideo = json['isVideo'];
    _videoDuration = json['videoDuration'];
    _media = json['media'];
    _phone = json['phone'];
    _text = json['text'];
    if (json['viewers'] != null) {
      _viewers = [];
      json['viewers'].forEach((v) {
        _viewers?.add(ViewerModel.fromJson(v));
      });
    }
    // _viewers = json['viewers'] != null ? json['viewers'].cast<String>() : [];
    _canView = json['canView'] != null ? json['canView'].cast<String>() : [];
  }
  String? _date;
  bool? _isImage;
  bool? _isRead;
  bool? _isVideo;
  String? _videoDuration;
  String? _media;
  String? _phone;
  String? _text;
  List<ViewerModel>? _viewers;
  List<String>? _canView;

  String? get date => _date;
  bool? get isImage => _isImage;
  bool? get isRead => _isRead;
  bool? get isVideo => _isVideo;
  String? get videoDuration => _videoDuration;
  String? get media => _media;
  String? get phone => _phone;
  String? get text => _text;
  List<ViewerModel>? get viewers => _viewers;
  List<String>? get canView => _canView;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['isImage'] = _isImage;
    map['isRead'] = _isRead;
    map['isVideo'] = _isVideo;
    map['videoDuration'] = _videoDuration;
    map['media'] = _media;
    map['phone'] = _phone;
    map['text'] = _text;
    if (_viewers != null) {
      map['viewers'] = _viewers?.map((v) => v.toJson()).toList();
    }
    map['canView'] = _canView;
    return map;
  }

}