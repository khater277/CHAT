// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../shared/constants.dart';
import 'login_states.dart';


class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);


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
}

