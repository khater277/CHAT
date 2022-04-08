import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'country_info.dart';
import 'phone_info.dart';


class CountryAndPhone extends StatelessWidget {
  final TextEditingController phoneController;
  const CountryAndPhone({Key? key, required this.phoneController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        const CountryInfo(),
        SizedBox(width: 3.5.w,),
        PhoneInfo(phoneController: phoneController),
      ],
    );
  }
}
