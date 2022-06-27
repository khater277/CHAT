import 'package:chat/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';


class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://fcm.googleapis.com/fcm/send',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': "application/json",
            'Authorization': 'key=AAAAaTTvvMM:APA91bFmi2dEmGM-PWzfBvG3IkR3BhNo-lDDXKE3UrIiSDuNJhUHyAhhwGf8cOpdCudUUh5YtScb39zJrA-2mlsOcszkqX66-CZmy02RaJ1d_QuEXM8u__gBQcII7yOZs0alrHvRf8T_',
          }),
    );
  }


  static Future<Response> pushNotification({
    required String token,
    required String myPhoneNumber,
    required String userID,
    required String userName}){

    // String? userName;
    //
    // FirebaseFirestore.instance.collection('users')
    // .doc(userID)
    // .collection('contacts')
    // .doc(uId)
    // .get()
    // .then((value){
    //   UserModel userModel = UserModel.fromJson(value.data());
    //   userName = userModel.name;
    // });

    Map<String,dynamic> data = {
      "to":token,
      "priority":"high",

      "notification":{
        "title":"New Message",
        "body":"$userName sent you new message",
        "sound": "default"
      },
      "data":{
        "type":"order",
        "id":"$uId$userID${DateTime.now().millisecondsSinceEpoch}",
        "senderID":"$uId",
        "phoneNumber":myPhoneNumber,
        "click_action":"FLUTTER_NOTIFICATION_CLICK"
      }
    };

    return dio!.post('',data: data);
  }
}