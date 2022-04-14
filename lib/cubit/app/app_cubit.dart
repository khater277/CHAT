import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/models/MessageModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/add_story/add_story_screen.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/contacts/contacts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:contacts_service/contacts_service.dart';
import '../../screens/calls/calls_screen.dart';
import '../../shared/constants.dart';
import 'app_states.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  void logOut(){
    emit(AppLoadingState());
    FirebaseAuth.instance.signOut().then((value){
      otp=null;
      uId=null;
      GetStorage().remove('uId');
      emit(AppLogoutState());
    }).catchError((error){
      emit(AppErrorState());
    });
  }

  List<Widget> screens = [
    const ChatsScreen(),
    const AddStoryScreen(),
    const CallsScreen(),
    const ContactsScreen()
  ];
  int navBarIndex = 0;
  void changeNavBar(int index){
    navBarIndex = index;
    emit(AppChangeNavBarState());
  }

  List<Contact> contacts = [];
  List<String> usersID = [];
  List<UserModel> users = [];
  void getContacts(){
    if(contactsPermission!){
      emit(AppLoadingState());
      ContactsService.getContacts().then((contactList){
        for (var element in contactList) {
          FirebaseFirestore.instance.collection('users')
              .get()
              .then((value){
            if(element.phones!.isNotEmpty){
              for (var e in value.docs) {
                UserModel user = UserModel.fromJson(e.data());
                //debugPrint("==========> ${element.phones!}");
                if(element.phones![0].value!.length>=11){
                  if((phoneFormat(phoneNumber: element.phones![0].value!)==
                      phoneFormat(phoneNumber: user.phone!))){
                    usersID.add(e.id);
                    users.add(UserModel(
                        name: element.displayName,
                        uId: user.uId,
                        phone: user.phone,
                        image: user.image
                    ));
                    contacts.add(element);
                  }
                }
              }
            }
          }).catchError((error){
            printError("getContacts",error.toString());
            emit(AppErrorState());
          });
        }
        debugPrint("=============GET CONTACTS=============");
        //emit(AppGetContactsState());
        getChats();
      }).catchError((error){
        emit(AppErrorState());
      });
    }
  }

  void addNewContact(Contact contact){
    ContactsService.addContact(contact)
        .then((value){
          debugPrint("NEW CONTACT ADDED");
          getContacts();
        emit(AppAddNewContactState());
    }).catchError((error){
      emit(AppErrorState());
    });
  }

  void sendMessage({
    required String friendID,
    String? message,
    String? image,
  }){
    emit(AppLoadingState());
    ///message model which will be stored in my firestore
    MessageModel myMessageModel = MessageModel(
      senderID: uId,
      receiverID: friendID,
      message: message??"",
      image: image??"",
      date: DateTime.now().toString()
    );
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .collection('chats')
    .doc(friendID)
    .collection('messages')
    .add(myMessageModel.toJson())
    .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(friendID)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(myMessageModel.toJson())
          .then((value){
            sendLastMessage(friendID: friendID,message: message,image: image);
            debugPrint("MESSAGE SENT");
            emit(AppSendMessageState());
      }).catchError((error){
        printError("sendMessage", error.toString());
        emit(AppErrorState());
      });
    }).catchError((error){
      printError("sendMessage", error.toString());
      emit(AppErrorState());
    });
  }
  

  void sendLastMessage({
    required String friendID,
    String? message,
    String? image,
  }){
    emit(AppLoadingState());
    LastMessageModel lastMessageModel = LastMessageModel(
      senderID: uId,
      receiverID: friendID,
      message: message??"",
      image: image??"",
      date: DateTime.now().toString(),
      isRead: true
    );
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .collection('chats')
    .doc(friendID)
    .set(lastMessageModel.toJson())
    .then((value){
      FirebaseFirestore.instance.collection('users')
          .doc(friendID)
          .collection('chats')
          .doc(uId)
          .set(lastMessageModel.toJson())
          .then((value){
           emit(AppSendLastMessageState());
      }).catchError((error){
        printError("SendLastMessage", error.toString());
        emit(AppErrorState());
      });
    });
  }

  List<String> chatsID = [];
  List<UserModel> chats = [];
  List<LastMessageModel> chatsLastMessages = [];
  void getChats(){
    emit(AppLoadingState());
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .collection('chats')
    .get()
    .then((value){
      for (var element in value.docs) {
        chatsID.add(element.id);
        chatsLastMessages.add(LastMessageModel.fromJson(element.data()));
        FirebaseFirestore.instance.collection('users')
        .doc(element.id)
        .get()
        .then((value){
          UserModel userModel = UserModel.fromJson(value.data());
          String? name;
          bool isContact = usersID.contains(userModel.uId);
          name = isContact?users.firstWhere((element) =>
          element.uId==userModel.uId).name!:userModel.name!;
          UserModel finalUserModel = UserModel(
            name: name,
            uId: userModel.uId,
            phone: userModel.phone,
            image: userModel.image
          );
          chats.add(finalUserModel);
          emit(AppGetChatsState());
        }).catchError((error){
          printError("getChatsLoop", error.toString());
          emit(AppErrorState());
        });
      }
      debugPrint("GET CHATS");
      // emit(AppGetChatsState());
    }).catchError((error){
      printError("getChats", error.toString());
      emit(AppErrorState());
    });
  }

}