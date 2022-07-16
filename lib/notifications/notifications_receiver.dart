import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/notifications/local_notifications.dart';
import 'package:chat/screens/call_content/voice_call/voice_call_content_screen.dart';
import 'package:chat/screens/contacts/contacts_screen.dart';
import 'package:chat/screens/messages/messages_screen.dart';
import 'package:chat/screens/receive_calls/receive_calls_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationsReceiver {

  static void handelForegroundMessage({required AppCubit cubit}){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.body}');
      }


      if(message.data['type']=="call"){
        Get.to(()=> ReceiveCallScreen(
            senderID: message.data['senderID'],
            token: message.data['token'],
            channelName: message.data['channelName'],
            callID: message.data['callID'],
        ));
        // cubit.changeNavBar(1);
        // Get.to(()=>CallContentScreen(
        //   senderID: message.data['senderID'],
        //   token: message.data['token'],
        //   channelName: message.data['channelName'],
        // ));
      }else{
        UserModel? userModel = cubit.users.firstWhereOrNull((element) =>
        element.uId==message.data['senderID']);
        String? name = userModel!=null?userModel.name!
            :message.data['phoneNumber'];
        int id = (DateTime.now().millisecondsSinceEpoch/1000).floor();
        print("current=================>${cubit.currentChat}");
        print("sender=================>${message.data['senderID']}");
        if(cubit.currentChat != message.data['senderID']) {
          NotificationsHelper.showNotification(id: id,name: name!,senderID: message.data['senderID']);
        }
      }
    });
  }

  static void handelBackgroundMessage({required AppCubit cubit}){
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("sender=================>${message.data['senderID']}");
      UserModel? userModel = cubit.chats.firstWhereOrNull((element) =>
      element.uId==message.data['senderID']);
      if(userModel==null){
        cubit.getChats();
        userModel = cubit.chats.firstWhereOrNull((element) =>
        element.uId==message.data['senderID']);
        Get.to(()=>MessagesScreen(user: userModel!, isFirstMessage: false));
      }else {
        Get.to(()=>MessagesScreen(user: userModel!, isFirstMessage: false));
      }
    });
  }

  static void handelBackgroundVideoCall(){
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.to(()=>const ContactsScreen());
    });
  }
}