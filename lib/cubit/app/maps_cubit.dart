import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';

import '../../shared/constants.dart';
import 'maps_states.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);

  void logOut(){
    emit(AppLoadingState());
    FirebaseAuth.instance.signOut().then((value){
      otp=null;
      GetStorage().remove('loggedIn');
      emit(AppLogoutState());
    }).catchError((error){
      emit(AppErrorState(error));
    });
  }
}