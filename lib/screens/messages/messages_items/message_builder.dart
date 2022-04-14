import 'package:chat/models/MessageModel.dart';
import 'package:chat/screens/messages/messages_items/friend_message.dart';
import 'package:chat/screens/messages/messages_items/my_message.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';

class MessageBuilder extends StatelessWidget {
  final MessageModel message;
  const MessageBuilder({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message.senderID==uId?MyMessage(message: message.message!)
        :FriendMessage(message: message.message!, image: message.image!);
  }
}
