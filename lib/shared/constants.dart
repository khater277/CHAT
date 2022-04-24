import 'dart:math';

import 'package:flutter/material.dart';


class GenerateMaterialColor{
  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(
      tintValue(color.red, factor),
      tintValue(color.green, factor),
      tintValue(color.blue, factor),
      1);

  int shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(
      shadeValue(color.red, factor),
      shadeValue(color.green, factor),
      shadeValue(color.blue, factor),
      1);

}


bool? contactsPermission;
bool? loggedIn;
String? uId;
String? otp;
String? lang;
String? defaultLang;
bool? isDarkMode;
bool? disableNotifications;

enum MediaSource {
  image,
  video,
  doc,
}


void scrollDown(ScrollController scrollController){
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    curve: Curves.easeOut,
    duration: const Duration(milliseconds: 500),
  );
}

String phoneFormat({required String phoneNumber}){
  return phoneNumber.replaceAll(' ', '').split('').reversed.join('').substring(0,11);
}

dynamic languageFun({
  @required ar,
  @required en,
}){
  return lang!=null?
  lang=='ar'?ar:en
      :(defaultLang=='ar'?ar:en);
}

void printError(String? funName,String? error){
  debugPrint("error in $funName ====> $error");
}

Map<String,String> cal={
  '01':'Jan', '02':'Feb',
  '03':'Mar', '04':'Apr',
  '05':'May','06':'Jun',
  '07':'Jul','08':'Aug',
  '09':'Sep','10':'Oct',
  '11':'Nov','12':'Dec',
};

Map<String,String> calAr={
  '01':'يناير', '02':'فبراير',
  '03':'مارس', '04':'ابريل',
  '05':'مايو','06':'يونيو',
  '07':'يونيه','08':'اغسطس',
  '09':'سبتمبر','10':'اكتوبر',
  '11':'نوفمبر','12':'ديسمبر',
};

Map<String,String> period={
  '00':'12', '01':'1', '02':'2', '03':'3',
  '04':'4','05':'5', '06':'6','07':'7',
  '08':'8','09':'9', '10':'10','11':'11',
  '12':'12', '13':'1', '14':'2', '15':'3',
  '16':'4','17':'5', '18':'6','19':'7',
  '20':'8','21':'9', '22':'10','23':'11',
};

//2022-02-12T12:30:00Z
String timeFormat(String time){
  String h = time.substring(11,13);
  String m = time.substring(13,16);
  int hour = int.parse(h)+2;
  String partOfDay = hour>=12?"PM":"AM";
  hour -= 12;
  return "$hour"+m+" $partOfDay";
}



String formatName(String name){
  List<int> capitalLettersIndex=[];
  for(int i=0;i<name.length;i++){
    if(name[i]==" "){
      capitalLettersIndex.add(i);
    }
  }
  for(int i=0;i<capitalLettersIndex.length;i++){
    String smallLetter = name.substring(
        capitalLettersIndex[i],capitalLettersIndex[i]+2);
    String capitalLetter = smallLetter.toUpperCase();
    name = name.replaceRange(
        capitalLettersIndex[i],
        capitalLettersIndex[i]+2,
        capitalLetter
    );
  }
  String firstLetter = name[0];
  name = name.replaceFirst(firstLetter, firstLetter.toUpperCase());
  return name;
}