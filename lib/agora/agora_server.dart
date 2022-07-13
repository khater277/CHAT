import 'package:chat/shared/constants.dart';
import 'package:dio/dio.dart';

class AgoraServer {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'http://192.168.1.5:8082/',
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': "application/json",
          }),
    );
  }

  static Future<Response> getToken({required String receiverId}){
    return dio!.post("fetch_rtc_token",data: {
      'channelName':"$uId$receiverId",
    });
  }

}