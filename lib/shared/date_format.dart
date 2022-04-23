import 'package:chat/shared/constants.dart';

class DateFormatter {

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

  String messageTimeFormat(String dateTime){
    DateTime date = DateTime.parse(dateTime);
    String? min= date.minute.toString().length==1?
    "0${date.minute.toString()}":date.minute.toString();
    String? hour= date.hour.toString().length==1?
    "0${date.hour.toString()}":date.hour.toString();

    String x="";
    if(hour.startsWith('0')||hour=="10"||hour=="11"){
      x=languageFun(ar: 'ص',en: "AM");
    }else{
      x=languageFun(ar: 'م',en: "PM");
    }
    return "${period[hour]}:$min $x";
  }

  Map<String,String>? dateFormat(String? dateTime){
    String? day=dateTime!.substring(8,10);
    if(day[0]=='0'){
      day=day[1];
    }
    String? month=dateTime.substring(5,7);
    String? year=dateTime.substring(0,4);
    String? hour=dateTime.substring(11,13);
    String? min=dateTime.substring(14,16);
    String x="";
    if(hour.startsWith('0')||hour=="10"||hour=="11"){
      x=languageFun(ar: 'ص',en: "AM");
    }else{
      x=languageFun(ar: 'م',en: "PM");
    }
    return {
      'date':languageFun(
          ar: "$day ${calAr[month]} $year في ${period[hour]}:$min $x",
          en: "$day ${cal[month]} $year at ${period[hour]}:$min $x"
      ),
      'year':year
    };
  }

  String time(String dateTime){
    String date = dateFormat(dateTime)!['date']!;
    int atIndex = date.indexOf('at');
    int fiIndex = date.indexOf('في');
    return languageFun(
        ar: date.substring(fiIndex+3,date.length),
        en: date.substring(atIndex+3,date.length)
    );
  }

  String lastMessageDate(String date){

    String? finalDate;
    DateTime messageDate = DateTime.parse(date);
    DateTime nowDate = DateTime.now();


    DateTime messageDayDate = DateTime(messageDate.year,messageDate.month,messageDate.day);
    DateTime todayDate = DateTime(nowDate.year,nowDate.month,nowDate.day);
    DateTime yesterdayDayDate = todayDate.subtract(const Duration(days: 1));


    String? min= messageDate.minute.toString().length==1?
    "0${messageDate.minute.toString()}":messageDate.minute.toString();
    String? hour= messageDate.hour.toString().length==1?
    "0${messageDate.hour.toString()}":messageDate.hour.toString();
    String x="";
    if(hour.startsWith('0')||hour=="10"||hour=="11"){
      x=languageFun(ar: 'ص',en: "AM");
    }else{
      x=languageFun(ar: 'م',en: "PM");
    }
    String today = "${period[hour]}:$min $x";
    String yesterday = "Yesterday";
    String completeDate = "${messageDate.day}/${messageDate.month}/${messageDate.year}";
    finalDate = messageDayDate==todayDate?today:
    messageDayDate==yesterdayDayDate?yesterday:completeDate;

    return finalDate;
  }

  String messageDate(String date){

    String? finalDate;
    DateTime messageDate = DateTime.parse(date);
    DateTime nowDate = DateTime.now();


    DateTime messageDayDate = DateTime(messageDate.year,messageDate.month,messageDate.day);
    DateTime todayDate = DateTime(nowDate.year,nowDate.month,nowDate.day);
    DateTime yesterdayDayDate = todayDate.subtract(const Duration(days: 1));


    String? month= messageDate.month.toString().length==1?
    "0${messageDate.month.toString()}":messageDate.month.toString();
    String? hour= messageDate.hour.toString().length==1?
    "0${messageDate.hour.toString()}":messageDate.hour.toString();
    String x="";
    if(hour.startsWith('0')||hour=="10"||hour=="11"){
      x=languageFun(ar: 'ص',en: "AM");
    }else{
      x=languageFun(ar: 'م',en: "PM");
    }
    String today = "Today";
    String yesterday = "Yesterday";
    String completeDate = "${messageDate.day} ${cal[month]} ${messageDate.year}";
    finalDate = messageDayDate==todayDate?today:
    messageDayDate==yesterdayDayDate?yesterday:completeDate;

    return finalDate;
  }

  String checkYear(String date){
    return (dateFormat(DateTime.now().toString())!['year']!)==
        dateFormat(date)!['year']?"":
    " ${dateFormat(date)!['year']}";
  }
}