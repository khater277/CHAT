import 'package:flutter/material.dart';

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
        const SizedBox(width: 8,),
        PhoneInfo(phoneController: phoneController),
      ],
    );
  }
}
