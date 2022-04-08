import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class CountryInfo extends StatelessWidget {
  const CountryInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String countryFlag(){
      String countryCode = 'eg';
      String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
              (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
      return flag;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 3.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(3.sp),
      ),
      child: Text("${countryFlag()}  +20",
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 11.sp,
        ),),
    );
  }
}
