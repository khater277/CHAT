import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


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

    return Expanded(
      flex: 1,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 3.5.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          child: Text("${countryFlag()}  +20",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 17.sp,
            ),),
        ),
      ),
    );
  }
}
