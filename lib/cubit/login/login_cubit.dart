// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/home/home_screen.dart';
import '../../screens/set_image/set_image_screen.dart';
import '../../shared/constants.dart';
import 'login_states.dart';


class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);


  void getContacts(context){
    emit(LoginLoadingState());
    ContactsService.getContacts().then((contactList){
      for (var element in contactList) {
        FirebaseFirestore.instance.collection('users')
            .get()
            .then((value){
          if(element.phones!.isNotEmpty){
            for (var e in value.docs) {
              UserModel user = UserModel.fromJson(e.data());
              if(element.phones![0].value!.length>=11){
                if((phoneFormat(phoneNumber: element.phones![0].value!)==
                    phoneFormat(phoneNumber: user.phone!))){
                  AppCubit.get(context).users.add(UserModel(
                      name: element.displayName,
                      uId: user.uId,
                      phone: user.phone,
                      image: user.image
                  ));
                  AppCubit.get(context).contacts.add(element);
                }
              }
            }
          }
        }).catchError((error){
          printError("getContacts",error.toString());
          emit(LoginErrorState(error.toString()));
        });
      }
      print("=============GET CONTACTS=============");
      emit(LoginGetContactsState());
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }

  bool phoneTextFieldValidate = false;
  String validationMsg = "please enter your phone number!";
  void phoneValidation({
    @required String? phone,
  }){

    List<String> validNumbers = ["010","011","012","015"];

    if(phone!.isEmpty) {
      phoneTextFieldValidate = false;
      validationMsg = "please enter your phone number !";
    }else{
      if(phone.length<11){
        phoneTextFieldValidate=false;
        validationMsg = "too short for a phone number";
      }else if(phone.length>11){
        phoneTextFieldValidate=false;
        validationMsg = "too long for a phone number";
      }else {
        if(validNumbers.contains(phone.substring(0,3))) {
          phoneTextFieldValidate=true;
        }else{
          phoneTextFieldValidate=false;
          validationMsg = "wrong phone number";
        }
      }
    }
    print(phoneTextFieldValidate);
    emit(LoginPhoneValidationState());
  }


  late String verificationId;
  Future<void> phoneAuth({@required String? phoneNumber})async{
    //otp=null;
    emit(LoginLoadingState());
   return await FirebaseAuth.instance.verifyPhoneNumber(
     phoneNumber: '+2${phoneNumber!}',
     verificationCompleted: verificationCompleted,
     verificationFailed: verificationFailed,
     codeSent: codeSent,
     timeout: const Duration(seconds: 60),
     codeAutoRetrievalTimeout: (String verificationId) {},
   );
 }

 void verificationCompleted (PhoneAuthCredential credential) {
   FirebaseAuth.instance.signInWithCredential(credential)
       .then((value){
     print("verificationCompleted");
     emit(LoginVerificationCompletedState());
   }).catchError((error){
     printError("verificationCompleted", error.toString());
     emit(LoginErrorState(error));
   });
 }

 void verificationFailed (FirebaseAuthException error) {
     emit(LoginErrorState(error.toString()));
 }

 void codeSent(String verificationId, int? resendToken) {
     this.verificationId = verificationId;
     print("code sent");
     emit(LoginCodeSentState());

 }

 void submitOtp(String smsCode){
   emit(LoginLoadingState());
   PhoneAuthCredential credential = PhoneAuthProvider
       .credential(verificationId: verificationId, smsCode: smsCode);
   FirebaseAuth.instance.signInWithCredential(credential)
       .then((value){
         uId=value.user!.uid;
         GetStorage().write('uId', uId);
     print(value.user!.phoneNumber!);
     emit(LoginSubmitOtpState());
   }).catchError((error){
     //printError("submitOtp", error.toString());
     emit(LoginErrorState(error.toString()));
   });
 }

  User getLoggedUser(){
    User user = FirebaseAuth.instance.currentUser!;
    return user;
  }

  ImagePicker picker = ImagePicker();
  File? image;
  Future<void> selectProfileImage()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      image = File(pickedFile.path);
      emit(LoginSelectProfileImageState());
    }else{
      emit(LoginErrorState("ERROR"));
      print("NOT SELECTED");
    }
  }

  void uploadProfileImage({
    @required String? name,
    bool? isOpening
  }){
    emit(LoginLoadingState());
    FirebaseStorage.instance
        .ref("profile_image/${Uri.file(image!.path).pathSegments.last}")
    .putFile(image!)
    .then((p0){
      p0.ref.getDownloadURL().then((value){
        if(isOpening==true){
          createUser(image: value,name: name!);
        }else{
          emit(LoginUploadProfileImageState());
        }
        print("IMAGE UPLOADED");
      }).catchError((error){
        emit(LoginErrorState(error.toString()));
      });
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }

  void test(context){
    AppCubit.get(context).getUserData(isOpening: true);
    AppCubit.get(context).getChats();
    // AppCubit.get(context).getContacts();
  }

  void checkUser(String phoneNumber,context){
    emit(LoginLoadingState());
    FirebaseFirestore.instance.collection('users')
        .get()
        .then((value){
      bool exist = false;
      for (var element in value.docs) {
        UserModel user = UserModel.fromJson(element.data());
        String? phone = phoneFormat(phoneNumber: user.phone!);
        print("=================> $phone");
        if(phone==phoneFormat(phoneNumber: phoneNumber)){
          exist=true;
        }
        if(exist){
          break;
        }
      }
      print("=========checkUser========> $exist");
      if(exist){
        test(context);
        Get.offAll(()=> const HomeScreen());
      }else{
        Get.offAll(()=> SetImageScreen(phone: phoneNumber,));
      }
      emit(LoginCheckUserState());
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }

  void createUser({
    String? name,
    String? image
  }){
    emit(LoginLoadingState());
    UserModel userModel = UserModel(
      name: name??"user",
      uId: uId,
      phone: getLoggedUser().phoneNumber!,
      image: image??""
    );
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .set(userModel.toJson())
    .then((value){
      print("USER CREATED");
      emit(LoginCreateUserState());
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }
}

