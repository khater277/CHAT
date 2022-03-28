import 'package:chat/screens/add_story/add_story_screen.dart';
import 'package:chat/screens/chats/chats_screen.dart';
import 'package:chat/screens/contacts/contacts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
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
      GetStorage().remove('loggedIn');
      emit(AppLogoutState());
    }).catchError((error){
      emit(AppErrorState(error));
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
  void getContacts(){
    if(contactsPermission!){
      emit(AppLoadingState());
      ContactsService.getContacts().then((value){
        contacts=value;
        print(contacts[10].displayName);
        print("=============GET CONTACTS=============");
        emit(AppGetContactsState());
      }).catchError((error){
        emit(AppErrorState(error.toString())
        );
      });
    }
  }


  void addNewContact(Contact contact){
    ContactsService.addContact(contact)
        .then((value){
          print("NEW CONTACT ADDED ===> $value");
          getContacts();
        emit(AppAddNewContactState());
    }).catchError((error){
      emit(AppErrorState(error.toString()));
    });
  }

}