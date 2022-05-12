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
                  return homeWidget;
                },
              ),
            );
          },
        )
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Shimmer',
//       routes: <String, WidgetBuilder>{
//         'loading': (_) => LoadingListPage(),
//         'slide': (_) => SlideToUnlockPage(),
//       },
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shimmer'),
//       ),
//       body: Column(
//         children: <Widget>[
//           ListTile(
//             title: const Text('Loading List'),
//             onTap: () => Navigator.of(context).pushNamed('loading'),
//           ),
//           ListTile(
//             title: const Text('Slide To Unlock'),
//             onTap: () => Navigator.of(context).pushNamed('slide'),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class LoadingListPage extends StatefulWidget {
//   @override
//   _LoadingListPageState createState() => _LoadingListPageState();
// }
//
// class _LoadingListPageState extends State<LoadingListPage> {
//   bool _enabled = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Loading List'),
//       ),
//       body: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             Expanded(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 enabled: _enabled,
//                 child: ListView.builder(
//                   itemBuilder: (_, __) => Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                           width: 48.0,
//                           height: 48.0,
//                           color: Colors.white,
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8.0),
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 width: double.infinity,
//                                 height: 8.0,
//                                 color: Colors.white,
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 2.0),
//                               ),
//                               Container(
//                                 width: double.infinity,
//                                 height: 8.0,
//                                 color: Colors.white,
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 2.0),
//                               ),
//                               Container(
//                                 width: 40.0,
//                                 height: 8.0,
//                                 color: Colors.white,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   itemCount: 6,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: FlatButton(
//                   onPressed: () {
//                     setState(() {
//                       _enabled = !_enabled;
//                     });
//                   },
//                   child: Text(
//                     _enabled ? 'Stop' : 'Play',
//                     style: Theme.of(context).textTheme.button!.copyWith(
//                         fontSize: 18.0,
//                         color: _enabled ? Colors.redAccent : Colors.green),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SlideToUnlockPage extends StatelessWidget {
//   final List<String> days = <String>[
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday'
//   ];
//   final List<String> months = <String>[
//     'January',
//     'February',
//     'March',
//     'April',
//     'May',
//     'June',
//     'July',
//     'August',
//     'September',
//     'October',
//     'November',
//     'December',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime time = DateTime.now();
//     final int hour = time.hour;
//     final int minute = time.minute;
//     final int day = time.weekday;
//     final int month = time.month;
//     final int dayInMonth = time.day;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Slide To Unlock'),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Image.asset(
//             'assets/images/background.jpg',
//             fit: BoxFit.cover,
//           ),
//           Positioned(
//             top: 48.0,
//             right: 0.0,
//             left: 0.0,
//             child: Center(
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '${hour < 10 ? '0$hour' : '$hour'}:${minute < 10 ? '0$minute' : '$minute'}',
//                     style: const TextStyle(
//                       fontSize: 60.0,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 4.0),
//                   ),
//                   Text(
//                     '${days[day - 1]}, ${months[month - 1]} $dayInMonth',
//                     style: const TextStyle(fontSize: 24.0, color: Colors.white),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//               bottom: 24.0,
//               left: 0.0,
//               right: 0.0,
//               child: Center(
//                 child: Opacity(
//                   opacity: 0.8,
//                   child: Shimmer.fromColors(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Image.asset(
//                           'assets/images/chevron_right.png',
//                           height: 20.0,
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 4.0),
//                         ),
//                         const Text(
//                           'Slide to unlock',
//                           style: TextStyle(
//                             fontSize: 28.0,
//                           ),
//                         )
//                       ],
//                     ),
//                     baseColor: Colors.black12,
//                     highlightColor: Colors.white,
//                     loop: 3,
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }