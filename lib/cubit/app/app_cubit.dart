import 'dart:async';
import 'dart:io';

import 'package:chat/models/LastMessageModel.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:chat/models/MessageModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/story/story_screen.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/contacts/contacts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  List<Contact> contacts = [];
  List<String> usersID = [];
  List<UserModel> users = [];

  void getContacts() {
    if (contactsPermission!) {
      emit(AppLoadingState());
      ContactsService.getContacts().then((contactList) {
        for (var element in contactList) {
          FirebaseFirestore.instance.collection('users').get().then((value) {
            if (element.phones!.isNotEmpty) {
              for (var e in value.docs) {
                UserModel user = UserModel.fromJson(e.data());
                // print(user.name);
                if (element.phones![0].value!.length >= 11) {
                  if ((phoneFormat(phoneNumber: element.phones![0].value!) ==
                      phoneFormat(phoneNumber: user.phone!))) {
                    // print(user.name);
                    // print(element.displayName);
                    usersID.add(e.id);
                    users.add(UserModel(
                        name: element.displayName,
                        uId: user.uId,
                        phone: user.phone,
                        image: user.image));
                    contacts.add(element);
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
        getChats();
        //emit(AppGetContactsState());
      }).catchError((error) {
        emit(AppErrorState());
      });
    }
  }

  void addNewContact(Contact contact) {
    ContactsService.addContact(contact).then((value) {
      debugPrint("NEW CONTACT ADDED");
      getContacts();
      emit(AppAddNewContactState());
    }).catchError((error) {
      emit(AppErrorState());
    });
  }

  void sendMessage({
    required String friendID,
    required String message,
    bool? isFirstMessage,
    MediaSource? mediaSource,
    String? file,
  }) {
    //emit(AppLoadingState());
    ///message model which will be stored in my firestore
    MessageModel myMessageModel = MessageModel(
        senderID: uId,
        receiverID: friendID,
        message: message,
        media: file ?? "",
        isImage: mediaSource == MediaSource.image,
        isVideo: mediaSource == MediaSource.video,
        isDoc: mediaSource == MediaSource.doc,
        date: DateTime.now().toString());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .collection('messages')
        .add(myMessageModel.toJson())
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(friendID)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(myMessageModel.toJson())
          .then((value) {
        sendLastMessage(
            friendID: friendID,
            message: message,
            file: file,
            mediaSource: mediaSource);
        debugPrint("MESSAGE SENT");
        if (isFirstMessage == true) {
          getChats(firstMessage: true);
        } else {
          emit(AppSendMessageState());
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
        date: DateTime.now().toString(),
        isRead: false);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(friendID)
        .set(myLastMessageModel.toJson())
        .then((value) {
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

  void getChats({bool? firstMessage}) {
    if (firstMessage != true) {
      emit(AppLoadingState());
    }
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
              uId: userModel.uId,
              phone: userModel.phone,
              image: userModel.image);
          chats.add(finalUserModel);
          if (v.size == chats.length) {
            emit(AppGetChatsState());
          }
        }).catchError((error) {
          printError("getChatsLoop", error.toString());
          emit(AppErrorState());
        });
      }
      debugPrint("GET CHATS");
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
      print(file!.path);
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
    required String friendID,
    required MediaSource mediaSource,
    required bool isFirstMessage,
  }) async {
    final Directory? directory = await getExternalStorageDirectory();
    print(file!.path);
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
          .delete()
          .then((value) {
        if (messageModel.isImage! ||
            messageModel.isVideo! ||
            messageModel.isDoc!) {
          deleteMediaMessage(
              media: messageModel.media!,
              lastMessageModel: lastMessageModel,
              friendID: friendID,
              messageID: messageID,
              isVideo: messageModel.isVideo!);
        } else {
          if (lastMessageModel != null) {
            updateLastMessageInDelete(
              friendID: friendID,
              lastMessageModel: lastMessageModel,
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
        FirebaseFirestore.instance
            .collection('users')
            .doc(friendID)
            .collection('chats')
            .doc(uId)
            .update(lastMessageModel.toJson())
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
          isForEveryone: true,
        );
      } else {
        debugPrint("MESSAGE DELETED AND LAST MESSAGE UPDATED");
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
      print("NAME UPDATED");
      emit(AppUpdateNameState());
    }).catchError((error) {
      printError("updateName", error.toString());
      emit(AppErrorState());
    });
  }

  File? storyImage;

  Future<void> pickStoryImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      storyImage = File(pickedFile.path);
      emit(AppPickStoryImageState());
    } else {
      debugPrint("NOT SELECTED");
      emit(AppErrorState());
    }
  }


  UserModel? userModel;

  void getUserData({bool? isOpening}) {
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

  double? storyImagePercentage;

  void uploadMediaLastStory({
    required String phone,
    required MediaSource mediaSource,
    String? text,
  }) {
    emit(AppSendLastStoryLoadingState());
    FirebaseStorage.instance
        .ref("stories/$uId/${Uri.file(storyImage!.path).pathSegments.last}")
        .putFile(storyImage!)
        .snapshotEvents
        .listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          storyImagePercentage =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          emit(AppSendLastStoryLoadingState());
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          taskSnapshot.ref.getDownloadURL().then((value) {
            storyImagePercentage = null;
            storyImage = null;
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
          storyImagePercentage = null;
          storyImage = null;
          printError("uploadMediaLastStory", TaskState.error.toString());
          emit(AppErrorState());
          break;
      }
    });
  }


  void sendLastStory({
    required String phone,
    String? text,
    String? media,
    MediaSource? mediaSource,
  }) {
    StoryModel storyModel = StoryModel(
      phone: phone,
      date: DateTime.now().toString(),
      text: text ?? "",
      media: media ?? "",
      isImage: mediaSource != null ? mediaSource == MediaSource.image : false,
      isVideo: mediaSource != null ? mediaSource == MediaSource.video : false,
      isRead: false,
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
      emit(AppSendLastStoryState());
      Timer(
          Duration(seconds: validStoryDate.difference(storyDate).inSeconds),
              () {deleteStory(
                  id: value.id,
                media: storyModel.media
              );}
      );
    }).catchError((error) {
      printError("sendLastStory", error.toString());
      emit(AppErrorState());
    });
  }

  void deleteStory({
    required String id,
    String? media
  }){
    FirebaseFirestore.instance.collection("stories").doc(uId)
        .collection("currentStories")
        .doc(id)
        .delete()
        .then((value){
          if(media!=null){
            String uri = Uri.parse(media).pathSegments.last;
            deleteStoryFromStorage(uri: uri);
          }else{
            print("STORY DELETED");
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
      print("STORY DELETED");
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
    print(storyCurrentIndex);
    emit(AppChangeStoryIndexState());
  }
}
