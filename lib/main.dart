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
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'cubit/app/app_cubit.dart';
import 'cubit/app/app_states.dart';
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
  loggedIn = GetStorage().read('loggedIn')??false;
  contactsPermission = GetStorage().read('contactsPermission')??false;
  Widget? homeWidget;
  if(loggedIn==true){
    homeWidget=const HomeScreen();
  }else{
    homeWidget=const LoginScreen();
  }
  runApp(MyApp(homeWidget: homeWidget,));
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
          BlocProvider(create: (BuildContext context)=>AppCubit()..getContacts(),),
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
              locale: Locale(languageFun(ar: 'ar', en: 'en')),
              fallbackLocale: const Locale('en'),
              home: ResponsiveSizer(
                builder: (context, orientation, screenType) {
                  return homeWidget;
                },
              ),
            );
          },
        )
    );
  }
}