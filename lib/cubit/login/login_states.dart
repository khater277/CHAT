abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}

class LoginGetContactsState extends LoginStates{}

class LoginPhoneValidationState extends LoginStates{}

class LoginPhoneAuthState extends LoginStates{}

class LoginVerificationCompletedState extends LoginStates{}

class LoginCodeSentState extends LoginStates{}

class LoginSubmitOtpState extends LoginStates{}

class LoginCreateUserState extends LoginStates{}

class LoginSelectProfileImageState extends LoginStates{}

class LoginUploadProfileImageState extends LoginStates{}

class LoginCheckUserState extends LoginStates{}
