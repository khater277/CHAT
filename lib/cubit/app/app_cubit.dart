import 'dart:io';

import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/models/MessageModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/add_story/add_story_screen.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/contacts/contacts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
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
      // contacts = [];
      // usersID = [];
      // users = [];
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
        getChats();
        //emit(AppGetContactsState());

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
    bool? isFirstMessage,
    MediaSource? mediaSource,
    String? message,
    String? file,
  }){
    //emit(AppLoadingState());
    ///message model which will be stored in my firestore
    MessageModel myMessageModel = MessageModel(
      senderID: uId,
      receiverID: friendID,
      message: message??"",
      media: file??"",
      isImage: mediaSource==MediaSource.image,
      isVideo: mediaSource==MediaSource.video,
      isDoc: mediaSource==MediaSource.doc,
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
            sendLastMessage(
                friendID: friendID,
                message: message,
                file: file,
              mediaSource: mediaSource
            );
            debugPrint("MESSAGE SENT");
            if(isFirstMessage==true){
              getChats(firstMessage: true);
            }else {
              emit(AppSendMessageState());
            }
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
    String? file,
    MediaSource? mediaSource,
  }){
    LastMessageModel lastMessageModel = LastMessageModel(
      senderID: uId,
      receiverID: friendID,
      message: message??"",
      media: file??"",
      isImage: mediaSource==MediaSource.image,
      isVideo: mediaSource==MediaSource.video,
      isDoc: mediaSource==MediaSource.doc,
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
  void getChats({bool? firstMessage}){
    if(firstMessage!=true) {
      emit(AppLoadingState());
    }
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .collection('chats')
    .orderBy('date')
    .get()
    .then((v){
      for (int i=0;i<v.size;i++) {
        var element = v.docs[i];
        chatsID.add(element.id);
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
          if(v.size==chats.length) {
            emit(AppGetChatsState());
          }
        }).catchError((error){
          printError("getChatsLoop", error.toString());
          emit(AppErrorState());
        });
      }
      debugPrint("GET CHATS");
    }).catchError((error){
      printError("getChats", error.toString());
      emit(AppErrorState());
    });
  }

  void deleteChat({required String chatID}){
    emit(AppDeleteChatLoadingState());
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .collection('chats')
    .doc(chatID)
    .collection('messages')
    .get()
    .then((value){
      for (var element in value.docs) {
        element.reference.delete();
      }
      FirebaseFirestore.instance.collection('users')
          .doc(uId)
          .collection('chats')
          .doc(chatID)
      .delete()
      .then((value){
        debugPrint("CHAT DELETED");
        emit(AppDeleteChatState());
      }).catchError((error){
        printError("deleteChat", error.toString());
        emit(AppErrorState());
      });
    }).catchError((error){
      printError("deleteChat", error.toString());
      emit(AppErrorState());
    });
  }

  bool isImage = false;
  bool isVideo = false;
  bool isDoc = false;
  ImagePicker picker = ImagePicker();
  File? file;
  Future<void> selectMessageImage({required MediaSource mediaSource})async{
    late XFile? pickedFile;
    if(mediaSource==MediaSource.image){
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }else{
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    }
    if(pickedFile!=null){
      file = File(pickedFile.path);
      if(mediaSource==MediaSource.image){
        isImage = true;
        emit(AppSelectMessageImageState());
      }else{
        isVideo = true;
        emit(AppSelectMessageVideoState());
      }
    }else{
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }

  String? docName;
  void selectFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
      allowedExtensions: ['doc','docx','pdf','ppt','pptx','txt',
        'html','htm','odt','ods','xls','xlsx',]
    );
    if (result != null) {
      isDoc = true;
      file = File(result.files.single.path!);
      docName = Uri.file(file!.path).pathSegments.last;
      emit(AppSelectFileState());
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }

  void cancelSelectFile(){
    isImage = false;
    isVideo = false;
    isDoc = false;
    file = null;
    emit(AppCancelSelectFileState());
  }


  double? percentage;
  void sendMediaMessage({
  required String friendID,
  required MediaSource mediaSource,
  required bool isFirstMessage,
  String? message,
}){
    FirebaseStorage.instance.ref("media/${Uri.file(file!.path).pathSegments.last}")
    .putFile(file!)
    .snapshotEvents
    .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          percentage = taskSnapshot.bytesTransferred/taskSnapshot.totalBytes;
          emit(AppSendMediaMessageLoadingState());
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          taskSnapshot.ref.getDownloadURL().then((value){
            sendMessage(
                friendID: friendID,
                isFirstMessage: isFirstMessage,
                mediaSource: mediaSource,
                file: value,
                message: message
            );
            percentage = 0;
            isImage = false;
            isVideo = false;
            isDoc = false;
            debugPrint("MEDIA SENT");
            emit(AppSendMediaMessageState());
          }).catchError((error){
            printError("sendMediaMessage", error.toString());
            emit(AppErrorState());
          });
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          printError("sendMediaMessage", TaskState.error.toString());
          emit(AppErrorState());
          break;
      }
    });
  }

  void deleteMessageForMe({
    required String friendID,
    required String messageID,
    required LastMessageModel? lastMessageModel,
  }){
    emit(AppDeleteMessageLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .collection('messages')
        .doc(messageID)
        .delete()
        .then((value){
          if(lastMessageModel!=null){
            updateLastMessageInDelete(
                friendID: friendID,
                lastMessageModel: lastMessageModel,
                isForEveryone: false,
            );
          }else {
            emit(AppDeleteMessageState());
          }
        }).catchError((error){
          printError("deleteMessageForMe", error.toString());
          emit(AppErrorState());
        });
  }


  void deleteMessageForEveryone({
    required String friendID,
    required MessageModel messageModel,
    required String messageID,
    required LastMessageModel? lastMessageModel,
  }){
    emit(AppDeleteMessageLoadingState());
    FirebaseFirestore.instance.collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .collection('messages')
        .doc(messageID)
        .delete()
        .then((value){
          FirebaseFirestore.instance.collection('users')
              .doc(friendID)
              .collection('chats')
              .doc(uId)
              .collection('messages')
              .doc(messageID)
              .delete()
              .then((value){
                if(messageModel.isImage!||messageModel.isVideo!||messageModel.isDoc!){
                  deleteMediaMessage(
                      media: messageModel.media!,
                    lastMessageModel: lastMessageModel,
                    friendID: friendID,
                    messageID: messageID,
                    isVideo: messageModel.isVideo!
                  );
                }else{
                  if(lastMessageModel!=null){
                    updateLastMessageInDelete(
                      friendID: friendID,
                      lastMessageModel: lastMessageModel,
                      isForEveryone: true,
                    );
                  }else {
                    emit(AppDeleteMessageState());
                  }
                }
          }).catchError((error){
            printError("deleteMessageForMe", error.toString());
            emit(AppErrorState());
          });
    }).catchError((error){
      printError("deleteMessageForMe", error.toString());
      emit(AppErrorState());
    });
  }

  void updateLastMessageInDelete({
    required String friendID,
    required LastMessageModel? lastMessageModel,
    required bool isForEveryone,
}) {
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .collection('chats')
    .doc(friendID)
    .update(lastMessageModel!.toJson())
    .then((value){
      if(isForEveryone){
        FirebaseFirestore.instance.collection('users')
            .doc(friendID)
            .collection('chats')
            .doc(uId)
            .update(lastMessageModel.toJson())
            .then((value){
              debugPrint("MESSAGE DELETED AND LAST MESSAGE UPDATED");
              emit(AppDeleteMessageState());
        }).catchError((error){
          printError("deleteMessage", error.toString());
          emit(AppErrorState());
        });
      }else{
        debugPrint("MESSAGE DELETED AND LAST MESSAGE UPDATED");
        emit(AppDeleteMessageState());
      }
    }).catchError((error){
      printError("deleteMessage", error.toString());
      emit(AppErrorState());
    });
  }


  void deleteMediaMessage({
    required String friendID,
    required String media,
    required LastMessageModel? lastMessageModel,
    required bool isVideo,
    required String messageID,
  }){
    String mediaName = media.substring(media.indexOf("image_picker"),media.indexOf('?'));
    FirebaseStorage.instance.ref('media/$mediaName')
        .delete()
        .then((value){
          if(isVideo == true){
            DefaultCacheManager().removeFile(messageID);
          }
      if(lastMessageModel!=null){
        updateLastMessageInDelete(
          friendID: friendID,
          lastMessageModel: lastMessageModel,
          isForEveryone: true,
        );
      }else {
        debugPrint("MESSAGE DELETED AND LAST MESSAGE UPDATED");
        emit(AppDeleteMessageState());
      }
    }).catchError((error){
      printError("deleteMessageForMe", error.toString());
      emit(AppErrorState());
    });
  }

}