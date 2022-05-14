import 'dart:io';
import 'package:chat/cubit/login/login_cubit.dart';
import 'package:chat/screens/home/home_screen.dart';
import 'package:chat/screens/login/login_screen.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/themes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'cubit/app/app_cubit.dart';
import 'cubit/app/app_states.dart';
import 'cubit/app/bloc_observer.dart';
import 'firebase_options.dart';
import 'translation/translations.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final String defaultLocale = Platform.localeName.substring(0, 2);
  defaultLang = defaultLocale;
  lang = GetStorage().read('lang')??(defaultLang=='ar'?'ar':'en');
  uId = GetStorage().read('uId')??"";
  contactsPermission = GetStorage().read('contactsPermission')??false;
  Widget? homeWidget;
  if(uId!.isNotEmpty){
    homeWidget=const HomeScreen();
  }else{
    homeWidget=const LoginScreen();
  }

  BlocOverrides.runZoned(
        () {runApp(MyApp(homeWidget: homeWidget!,));},
    blocObserver: MyBlocObserver(),
  );

  // runApp(DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(homeWidget: homeWidget!,), // Wrap your app
  //   ));


}

class MyApp extends StatelessWidget {
  final Widget homeWidget;
  const MyApp({Key? key, required this.homeWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context)=>AppCubit()..getContacts()..getUserData(isOpening: true),
          ),
          BlocProvider(create: (BuildContext context)=>LoginCubit(),),
        ],
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){},
          builder: (context,state){
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              useInheritedMediaQuery: true,
              builder: DevicePreview.appBuilder,
              theme: darkTheme,
              translations: Translation(),
              //locale: Locale(languageFun(ar: 'ar', en: 'en')),
              locale: const Locale('en'),
              fallbackLocale: const Locale('en'),
              home: Sizer(
                builder: (context, orientation, screenType) {
                  return const LoginScreen();
                },
              ),
            );
          },
        )
    );
  }
}