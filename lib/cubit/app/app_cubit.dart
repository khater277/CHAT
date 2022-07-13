import 'dart:async';
import 'dart:io';

import 'package:chat/agora/agora_server.dart';
import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/models/MessageModel.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/call_content/call_content_screen.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/contacts/contacts_screen.dart';
import 'package:chat/screens/story/story_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/ContactModel.dart';
import '../../notifications/api.dart';
import '../../screens/calls/calls_screen.dart';
import '../../shared/constants.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  void logOut() {
    emit(AppLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      otp = null;
      uId = null;
      userModel = null;
      GetStorage().remove('uId');
      emit(AppLogoutState());
    }).catchError((error) {
      emit(AppErrorState());
    });
  }

  List<Widget> screens = [
    const ChatsScreen(),
    const StoryScreen(),
    const CallsScreen(),
    const ContactsScreen()
  ];
  int navBarIndex = 0;

  void changeNavBar(int index) {
    navBarIndex = index;
    emit(AppChangeNavBarState());
  }


  UserModel? userModel;

  void getUserData({bool? isOpening,bool? updateInCall}) {
    if(uId!=null&&uId!.isNotEmpty) {
      if(updateInCall==true) {
        updateInCallStatus(isTrue: false,isOpening: true);
      }
      FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data());
      if (isOpening != true) {
        emit(AppGetUserDataState());
      }
    }).catchError((error) {
      printError("getUserData", error.toString());
      emit(AppErrorState());
    });
    }
  }

  List<Contact> contacts = [];
  List<String> usersID = [];
  List<String> phones = [];
  List<UserModel> users = [];

  void getContacts({bool? addNewContact}) {
    if (contactsPermission!) {
      emit(AppLoadingState());
      ContactsService.getContacts().then((contactList) {
        usersID = [];
        users = [];
        contacts = [];
        phones = [];
        deleteContactsFormFirebase();
        for (var element in contactList) {
          FirebaseFirestore.instance.collection('users').get().then((value) {
            if (element.phones!.isNotEmpty) {
              for (var e in value.docs) {
                UserModel user = UserModel.fromJson(e.data());
                // debugPrint(user.name);
                if (element.phones![0].value!.length >= 11) {
                  if ((phoneFormat(phoneNumber: element.phones![0].value!) ==
                      phoneFormat(phoneNumber: user.phone!))) {
                    usersID.add(e.id);
                    UserModel finalUser = UserModel(
                        name: element.displayName,
                        token: user.token,
                        uId: user.uId,
                        phone: user.phone,
                        image: user.image,
                      inCall: user.inCall
                    );
                    users.add(finalUser);
                    contacts.add(element);
                    phones.add(user.phone!);
                    if(finalUser.uId!=uId) {
                      ContactModel contactModel = ContactModel(
                        phoneNumber: finalUser.phone,
                        name: finalUser.name
                      );
                      addContactsToFirebase(
                        userID: finalUser.uId!,
                        contactModel: contactModel
                      );
                    }
                  }
                }
              }
            }
          }).catchError((error) {
            printError("getContacts", error.toString());
            emit(AppErrorState());
          });
        }
        debugPrint("=============GET CONTACTS=============");
        if(addNewContact!=true) {
          getChats();
        }else{
          emit(AppGetContactsState());
        }
        //
      }).catchError((error) {
        emit(AppErrorState());
      });
    }
  }

  void deleteContactsFormFirebase(){
    FirebaseFirestore.instance.collection('users')
        .doc(uId!)
        .collection('contacts')
        .get()
        .then((value){
      for (var element in value.docs) {
        element.reference.delete();
      }
    }).catchError((error){
      printError("deleteContactsFormFirebase", error.toString());
      emit(AppErrorState());
    });
  }

  void addContactsToFirebase({required String userID,required ContactModel contactModel}){
    FirebaseFirestore.instance.collection('users')
        .doc(uId!)
        .collection('contacts')
        .doc(userID)
        .set(contactModel.toJson())
        .then((value) {
          // emit(AppLoadingState());
        }
    )
        .catchError((error){
      printError("addContactsToFirebase", error.toString());
      emit(AppErrorState());
    });
  }


  void addNewContact(Contact contact) {
    ContactsService.addContact(contact).then((value) {
      debugPrint("NEW CONTACT ADDED");
      getContacts(addNewContact: true);
      emit(AppAddNewContactState());
    }).catchError((error) {
      emit(AppErrorState());
    });
  }

  String? currentChat;
  void changeCurrentChat({required String? id}){
    currentChat = id;
    emit(AppChangeCurrentChatState());
  }

  void sendMessage({
    required String friendToken,
    required String friendID,
    required String message,
    bool? isFirstMessage,
    bool? isStoryReply,
    bool? isStoryVideoReply,
    MediaSource? mediaSource,
    String? file,
    String? storyMedia,
    String? storyDate,
  }) {
    if(isStoryReply==true) {
      emit(AppSendStoryReplyLoadingState());
    }
    ///message model which will be stored in my firestore
    MessageModel myMessageModel = MessageModel(
        senderID: uId,
        receiverID: friendID,
        message: message,
        media: file ?? "",
        storyMedia: storyMedia??"",
        isStoryReply: isStoryReply??false,
        isStoryVideoReply:isStoryVideoReply??false,
        isImage: mediaSource == MediaSource.image,
        isVideo: mediaSource == MediaSource.video,
        isDoc: mediaSource == MediaSource.doc,
        isDeleted: false,
        date: DateTime.now().toString(),
        storyDate: storyDate,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .collection('messages')
        .add(myMessageModel.toJson())
        .then((value) {
          print(value.id);
      FirebaseFirestore.instance
          .collection('users')
          .doc(friendID)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .doc(value.id)
          .set(myMessageModel.toJson())
          .then((value) {
        sendLastMessage(
            friendID: friendID,
            message: message,
            file: file,
            mediaSource: mediaSource
        );
        sendNotification(
            userToken: friendToken,
            userID: friendID);
        debugPrint("MESSAGE SENT");
        if (isFirstMessage == true) {
          getChats(firstMessage: true);
        } else {
          if(isStoryReply==true) {
            emit(AppSendStoryReplyState());
          }else {
            emit(AppSendMessageState());
          }
        }
      }).catchError((error) {
        printError("sendMessage", error.toString());
        emit(AppErrorState());
      });
    }).catchError((error) {
      printError("sendMessage", error.toString());
      emit(AppErrorState());
    });
  }

  void pushNotification({
    required String userToken,
    required String userID,
    required String userName,
  }){
      DioHelper.pushNotification(
        myPhoneNumber: userModel!.phone!,
        token: userToken,
        userID: userID,
        userName: userName)
        .then((value){
      print("MESSAGE SENT");
    }).catchError((error){
      printError("pushNotification", error.toString());
      emit(AppErrorState());
    });
  }

  void sendNotification({
    required String userToken,
    required String userID,
    }){
    // if(userModel!.token!=userToken) {
      FirebaseFirestore.instance.collection('users')
    .doc(userID)
    .collection('contacts')
    .doc(uId)
    .get()
    .then((value){
      ///if that number in my contacts i well send notification with contact name saved on my phone
      ContactModel contactModel = ContactModel.fromJson(value.data());
      pushNotification(userToken: userToken, userID: userID, userName: contactModel.name!);
    }).catchError((error){
      ///if that number not in my contacts i well send notification with phone number
      pushNotification(userToken: userToken, userID: userID, userName: userModel!.phone!);
      printError("getNotificationUser", error.toString());
      emit(AppErrorState());
    });
    // }
  }

  void sendLastMessage({
    required String friendID,
    String? message,
    String? file,
    MediaSource? mediaSource,
  }) {
    ///set data of my last message
    LastMessageModel myLastMessageModel = LastMessageModel(
        senderID: uId,
        receiverID: friendID,
        message: message ?? "",
        media: file ?? "",
        isImage: mediaSource == MediaSource.image,
        isVideo: mediaSource == MediaSource.video,
        isDoc: mediaSource == MediaSource.doc,
        isDeleted: false,
        date: DateTime.now().toString(),
        isRead: true);

    ///set data of my friend last message
    LastMessageModel friendLastMessageModel = LastMessageModel(
        senderID: uId,
        receiverID: friendID,
        message: message ?? "",
        media: file ?? "",
        isImage: mediaSource == MediaSource.image,
        isVideo: mediaSource == MediaSource.video,
        isDoc: mediaSource == MediaSource.doc,
        isDeleted: false,
        date: DateTime.now().toString(),
        isRead: false);

    ///send message to my chat with that friend in firebase
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .set(myLastMessageModel.toJson())
        .then((value) {
      ///send message to my friend chat with me in firebase
      FirebaseFirestore.instance
          .collection('users')
          .doc(friendID)
          .collection('chats')
          .doc(uId)
          .set(friendLastMessageModel.toJson())
          .then((value) {
        emit(AppSendLastMessageState());
      }).catchError((error) {
        printError("SendLastMessage", error.toString());
        emit(AppErrorState());
      });
    });
  }

  List<String> chatsID = [];
  List<UserModel> chats = [];
  List<LastMessageModel> chatsLastMessages = [];

  void getChats({
    bool? firstMessage,
    bool? isLogin,
  }) {
    ///don't loading when i send first message when i enter messages screen from contacts list
    if (firstMessage != true) {
      emit(AppLoadingState());
    }
    chatsID = [];
    chats = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .orderBy('date')
        .get()
        .then((v) {
      for (int i = 0; i < v.size; i++) {
        var element = v.docs[i];
        chatsID.add(element.id);
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          UserModel userModel = UserModel.fromJson(value.data());
          String? name;
          bool isContact = usersID.contains(userModel.uId);
          name = isContact
              ? users
                  .firstWhere((element) => element.uId == userModel.uId)
                  .name!
              : userModel.phone!;
          UserModel finalUserModel = UserModel(
              name: name,
              token: userModel.token,
              uId: userModel.uId,
              phone: userModel.phone,
              image: userModel.image,
          inCall: userModel.inCall);
          chats.add(finalUserModel);
          debugPrint("${v.size} == ${chats.length}");
          if (v.size == chats.length) {
            emit(AppGetChatsState());
          }
        }).catchError((error) {
          printError("getChatsLoop", error.toString());
          emit(AppErrorState());
        });
      }
      debugPrint("GET CHATS");
      // if(isLogin==true) {
        emit(AppGetChatsState());
      // }
    }).catchError((error) {
      printError("getChats", error.toString());
      emit(AppErrorState());
    });
  }

  void deleteChat({required String chatID}) {
    emit(AppDeleteChatLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(chatID)
          .delete()
          .then((value) {
        debugPrint("CHAT DELETED");
        emit(AppDeleteChatState());
      }).catchError((error) {
        printError("deleteChat", error.toString());
        emit(AppErrorState());
      });
    }).catchError((error) {
      printError("deleteChat", error.toString());
      emit(AppErrorState());
    });
  }

  bool isImage = false;
  bool isVideo = false;
  bool isDoc = false;
  ImagePicker picker = ImagePicker();
  File? file;

  Future<void> selectMessageImage({required MediaSource mediaSource}) async {
    late XFile? pickedFile;
    if (mediaSource == MediaSource.image) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    }
    if (pickedFile != null) {
      file = File(pickedFile.path);
      if (mediaSource == MediaSource.image) {
        isImage = true;
        emit(AppSelectMessageImageState());
      } else {
        isVideo = true;
        emit(AppSelectMessageVideoState());
      }
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }

  String? docName;

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'doc',
      'docx',
      'pdf',
      'ppt',
      'pptx',
      'txt',
      'html',
      'htm',
      'odt',
      'ods',
      'xls',
      'xlsx',
    ]);
    if (result != null) {
      isDoc = true;
      file = File(result.files.single.path!);
      debugPrint(file!.path);
      docName = Uri.file(file!.path).pathSegments.last;
      emit(AppSelectFileState());
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }

  void cancelSelectFile() {
    isImage = false;
    isVideo = false;
    isDoc = false;
    file = null;
    emit(AppCancelSelectFileState());
  }

  double? percentage;

  void sendMediaMessage({
    required String friendToken,
    required String friendID,
    required MediaSource mediaSource,
    required bool isFirstMessage,
  }) async {
    final Directory? directory = await getExternalStorageDirectory();
    debugPrint(file!.path);
    file!.copySync(
        "${directory!.path}/${Uri.file(file!.path).pathSegments.last}");
    FirebaseStorage.instance
        .ref("media/${Uri.file(file!.path).pathSegments.last}")
        .putFile(file!)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          percentage = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          emit(AppSendMediaMessageLoadingState());
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          taskSnapshot.ref.getDownloadURL().then((value) {
            sendMessage(
              friendToken: friendToken,
                friendID: friendID,
                isFirstMessage: isFirstMessage,
                mediaSource: mediaSource,
                file: value,
                message: Uri.file(file!.path).pathSegments.last);
            percentage = 0;
            isImage = false;
            isVideo = false;
            isDoc = false;
            debugPrint("MEDIA SENT ${file!.path}");
            emit(AppSendMediaMessageState());
          }).catchError((error) {
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

  }) {
    emit(AppDeleteMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .collection('messages')
        .doc(messageID)
        .delete()
        .then((value) {
      if (lastMessageModel != null) {
        updateLastMessageInDelete(
          friendID: friendID,
          lastMessageModel: lastMessageModel,
          messageModel: null,
          isForEveryone: false,
        );
      } else {
        emit(AppDeleteMessageState());
      }
    }).catchError((error) {
      printError("deleteMessageForMe", error.toString());
      emit(AppErrorState());
    });
  }

  void deleteMessageForEveryone({
    required String friendID,
    required MessageModel messageModel,
    required String messageID,
    required LastMessageModel? lastMessageModel,
  }) {
    emit(AppDeleteMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .collection('messages')
        .doc(messageID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(friendID)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .doc(messageID)
          .update({"isDeleted":true})
          .then((value) {
        if (messageModel.isImage == true ||
            messageModel.isVideo == true ||
            messageModel.isDoc == true) {
          deleteMediaMessage(
              media: messageModel.media!,
              lastMessageModel: lastMessageModel,
              messageModel: messageModel,
              friendID: friendID,
              messageID: messageID,
              isVideo: messageModel.isVideo!);
        } else {
          if (lastMessageModel != null) {
            updateLastMessageInDelete(
              friendID: friendID,
              lastMessageModel: lastMessageModel,
              messageModel: messageModel,
              isForEveryone: true,
            );
          } else {
            emit(AppDeleteMessageState());
          }
        }
      }).catchError((error) {
        printError("deleteMessageForMe", error.toString());
        emit(AppErrorState());
      });
    }).catchError((error) {
      printError("deleteMessageForMe", error.toString());
      emit(AppErrorState());
    });
  }

  void updateLastMessageInDelete({
    required String friendID,
    required LastMessageModel? lastMessageModel,
    required MessageModel? messageModel,
    required bool isForEveryone,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .update(lastMessageModel!.toJson())
        .then((value) {
      if (isForEveryone) {
        LastMessageModel friendLastMessageModel = LastMessageModel(
          senderID: messageModel!.senderID,
          receiverID: messageModel.receiverID,
          message: messageModel.message,
          media: messageModel.media,
          isImage: messageModel.isImage,
          isVideo: messageModel.isVideo,
          isDoc: messageModel.isDoc,
          date: messageModel.date,
          isRead: false,
          isDeleted: true
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(friendID)
            .collection('chats')
            .doc(uId)
            .update(friendLastMessageModel.toJson())
            .then((value) {
          debugPrint("MESSAGE DELETED AND LAST MESSAGE UPDATED");
          emit(AppDeleteMessageState());
        }).catchError((error) {
          printError("deleteMessage", error.toString());
          emit(AppErrorState());
        });
      } else {
        debugPrint("MESSAGE DELETED AND LAST MESSAGE UPDATED");
        emit(AppDeleteMessageState());
      }
    }).catchError((error) {
      printError("deleteMessage", error.toString());
      emit(AppErrorState());
    });
  }

  void deleteMediaMessage({
    required String friendID,
    required String media,
    required LastMessageModel? lastMessageModel,
    required MessageModel messageModel,
    required bool isVideo,
    required String messageID,
  }) {
    String mediaName =
        media.substring(media.indexOf("image_picker"), media.indexOf('?'));
    FirebaseStorage.instance.ref('media/$mediaName').delete().then((value) {
      if (isVideo == true) {
        DefaultCacheManager().removeFile(messageID);
      }
      if (lastMessageModel != null) {
        updateLastMessageInDelete(
          friendID: friendID,
          lastMessageModel: lastMessageModel,
          messageModel: messageModel,
          isForEveryone: true,
        );
      } else {
        debugPrint("MEDIA MESSAGE DELETED AND LAST MESSAGE UPDATED");
        emit(AppDeleteMessageState());
      }
    }).catchError((error) {
      printError("deleteMessageForMe", error.toString());
      emit(AppErrorState());
    });
  }

  Future<Directory?>? future;

  void test() {
    future = getExternalStorageDirectory();
    emit(AppTestState());
  }

  File? profileImage;
  double? profileImagePercentage;

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppPickProfileImageState());
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }

  void removeProfileImage() {
    profileImage = null;
    emit(AppPickProfileImageState());
  }

  void updateProfileImage() {
    FirebaseStorage.instance
        .ref("profile_image/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          profileImagePercentage =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          emit(AppUpdateProfileImageLoadingState());
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          taskSnapshot.ref.getDownloadURL().then((value) {
            profileImagePercentage = null;
            profileImage = null;
            setProfileImage(image: value);
          }).catchError((error) {
            printError("updateProfileImage", error.toString());
            emit(AppErrorState());
          });
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          profileImagePercentage = null;
          profileImage = null;
          printError("updateProfileImage", TaskState.error.toString());
          emit(AppErrorState());
          break;
      }
    });
  }

  void setProfileImage({required String image}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId!)
        .update({"image": image}).then((value) {
      debugPrint("PROFILE IMAGE SENT");
      getUserData();
      // emit(AppUpdateProfileImageState());
    }).catchError((error) {
      printError("updateProfileImage", error.toString());
      emit(AppErrorState());
    });
  }

  void updateName({required String name}) {
    emit(AppUpdateNameLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update({"name": name}).then((value) {
      debugPrint("NAME UPDATED");
      emit(AppUpdateNameState());
    }).catchError((error) {
      printError("updateName", error.toString());
      emit(AppErrorState());
    });
  }

  File? storyFile;

  Future<void> pickStoryImage() async {

    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      storyFile = File(pickedFile.path);
      emit(AppPickStoryImageState());
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }

  Future<void> pickStoryVideo() async {

    final pickedFile = await picker.pickVideo(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      storyFile = File(pickedFile.path);
      emit(AppPickStoryVideoState());
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }


  double? storyFilePercentage;

  void uploadMediaLastStory({
    required String phone,
    required MediaSource mediaSource,
    String? text,
  }) {
    emit(AppSendLastStoryLoadingState());
    FirebaseStorage.instance
        .ref("stories/$uId/${Uri.file(storyFile!.path).pathSegments.last}")
        .putFile(storyFile!)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          storyFilePercentage =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          emit(AppSendLastStoryLoadingState());
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          taskSnapshot.ref.getDownloadURL().then((value) {
            storyFilePercentage = null;
            storyFile = null;
            debugPrint("MEDIA SENT");
            sendLastStory(
                phone: phone,
                text: text,
                media: value,
                mediaSource: mediaSource);
            // emit(AppSendLastStoryState());
          }).catchError((error) {
            printError("uploadMediaLastStory", error.toString());
            emit(AppErrorState());
          });
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          storyFilePercentage = null;
          storyFile = null;
          printError("uploadMediaLastStory", TaskState.error.toString());
          emit(AppErrorState());
          break;
      }
    });
  }

  String? videoDuration;
  void setVideoDuration(String duration){
    videoDuration = duration;
    emit(AppSetVideoDurationState());
  }

  void sendLastStory({
    required String phone,
    String? text,
    String? media,
    MediaSource? mediaSource,
  }) {
    emit(AppSendLastStoryLoadingState());
    StoryModel storyModel = StoryModel(
      phone: phone,
      date: DateTime.now().toString(),
      text: text ?? "",
      media: media ?? "",
      isImage: mediaSource != null ? mediaSource == MediaSource.image : false,
      isVideo: mediaSource != null ? mediaSource == MediaSource.video : false,
      videoDuration: mediaSource == MediaSource.video ? videoDuration!:"0",
      isRead: false,
      viewers: [],
      canView: usersID
    );
    FirebaseFirestore.instance
        .collection('stories')
        .doc(uId)
        .set(storyModel.toJson())
        .then((value) {
      sendStory(storyModel: storyModel);
    }).catchError((error) {
      printError("sendLastStory", error.toString());
      emit(AppErrorState());
    });
  }

  void sendStory({
    required StoryModel storyModel,
  }) {
    FirebaseFirestore.instance
        .collection("stories")
        .doc(uId)
        .collection("currentStories")
        .add(storyModel.toJson())
        .then((value) {

      DateTime storyDate = DateTime.parse(storyModel.date!);
      DateTime validStoryDate =
      DateTime.parse(storyModel.date!).add(const Duration(days: 1));
      debugPrint("STORY UPLOADED");
      Timer(
          Duration(seconds: validStoryDate.difference(storyDate).inSeconds),
              () {deleteStory(
                userID: uId!,
              storyID: value.id,
              media: storyModel.media
          );}
      );
      emit(AppSendLastStoryState());
    }).catchError((error) {
      printError("sendLastStory", error.toString());
      emit(AppErrorState());
    });
  }



  void deleteStory({
    required String userID,
    required String storyID,
    required String? media
  }){
    FirebaseFirestore.instance.collection("stories").doc(userID)
        .collection("currentStories")
        .doc(storyID)
        .delete()
        .then((value){
          if(media!=null){
            String uri = Uri.parse(media).pathSegments.last;
            deleteStoryFromStorage(uri: uri);
          }else{
            debugPrint("STORY DELETED");
            emit(AppDeleteStoryState());
          }
    }).catchError((error){
      printError("deleteStory", error.toString());
      emit(AppErrorState());
    });
  }

  void deleteStoryFromStorage({required String uri}){
    FirebaseStorage.instance.ref(uri)
        .delete()
        .then((value){
      debugPrint("STORY DELETED");
      emit(AppDeleteStoryState());
    }).catchError((error){
      printError("deleteStory", error.toString());
      emit(AppErrorState());
    });
  }

  int storyCurrentIndex = 0;
  bool closeStory = false;
  void changeStoryIndex({required int index}){
    storyCurrentIndex = index;
    debugPrint(storyCurrentIndex.toString());
    emit(AppChangeStoryIndexState());
  }

  void zeroStoryIndex(){
    storyCurrentIndex = 0;
    emit(AppChangeStoryIndexState());
  }

  void viewStory({
  required String userID,
  required String storyID,
  required List<String> viewers,
  required bool isLast,
}){
    FirebaseFirestore.instance.collection('stories')
        .doc(userID)
        .collection('currentStories')
        .doc(storyID)
        .update({'viewers':viewers})
        .then((value){
          if(isLast){
            FirebaseFirestore.instance.collection('stories')
                .doc(userID)
                .update({'viewers':viewers})
                .then((value){
              debugPrint("ADDED TO VIEWERS LAST");
              emit(AppViewStoryState());
            }).catchError((error){
              printError("viewStory", error.toString());
              emit(AppErrorState());
            });
          }else{
            debugPrint("ADDED TO VIEWERS");
            emit(AppViewStoryState());
          }
    }).catchError((error){
      printError("viewStory", error.toString());
      emit(AppErrorState());
    });
  }

  void generateChannelToken({
    required String receiverId,
    required String userToken,
  }){
    emit(AppGenerateChannelTokenLoadingState());
    AgoraServer.getToken(receiverId: receiverId)
    .then((value){
      if(userToken!=userModel!.token) {
        DioHelper.pushCallNotification(
          userToken: userToken,
          channelToken: value.data['token'],
          myPhoneNumber: userModel!.phone!,
          receiverID: receiverId)
      .then((v){
        print("ALL WORKS SUCCESSFULLY ${value.data}");
        Get.to(()=>CallContentScreen(
            senderID: uId!,
            token: value.data['token'],
            channelName: "$uId$receiverId")
        );
        emit(AppGenerateChannelTokenState());
      }).catchError((error){
        printError("pushCallNotification", error.toString());
        emit(AppErrorState());
      });
      }else{
        print("THEY HAVE THE SAME TOKEN");
        emit(AppGenerateChannelTokenState());
      }
    }).catchError((error){
      printError("generateChannelToken", error.toString());
      emit(AppErrorState());
    });
  }


  void updateInCallStatus({required bool isTrue,bool? isOpening}){
    if(isOpening!=true) {
      emit(AppUpdateInCallStatusLoadingState());
    }
    Map<String,bool> map = {'inCall':isTrue?true:false};
    FirebaseFirestore.instance.collection('users')
    .doc(uId!)
    .update(map)
    .then((value){
      debugPrint("========> IN CALL UPDATED = $isTrue");
      if(isOpening!=true){
        if(isTrue) {
          emit(AppUpdateInCallStatusTrueState());
        }else{
          emit(AppUpdateInCallStatusFalseState());
        }
      }
    }).catchError((error){
      printError("updateInCallStatus", error.toString());
      emit(AppErrorState());
    });
  }

}
