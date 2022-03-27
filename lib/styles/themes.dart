import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

ThemeData darkTheme=ThemeData(
    primarySwatch: GenerateMaterialColor().generateMaterialColor(MyColors.blue),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
        bodyText1: const TextStyle(
          color: Colors.white,
          //fontWeight: FontWeight.w600,
          fontFamily: "SF-PRO-MEDIUM",
          fontSize: 20,
        ),
        bodyText2: const TextStyle(
          color: Colors.white,
          fontFamily: "SF-PRO-REGULAR",
          //fontWeight: FontWeight.w200,
          fontSize: 20,
        ),
        caption: TextStyle(
            color: Colors.white.withOpacity(0.5)
        )
    ),
    scaffoldBackgroundColor: MyColors.black,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Color(0xff333739),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Color(0xff333739),
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'SF-Pro-Display',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        )
    ),
    cardColor: const Color(0xff333739),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: const Color(0xff333739),
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey[500],
    )
);

ThemeData lightTheme=ThemeData(
  primarySwatch: GenerateMaterialColor()
      .generateMaterialColor(Colors.black87),
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black87,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyText1:TextStyle(
        color: Colors.black87,
        //fontWeight: FontWeight.w600,
        fontFamily: "Avenir-Medium",
        fontSize: 20,
      ),
      bodyText2: TextStyle(
        color: Colors.black87,
        fontFamily: "Avenir-Black",
        //fontWeight: FontWeight.w200,
        fontSize: 20,
      ),
    ),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'SF-Pro-Display',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey[500],
    )
);