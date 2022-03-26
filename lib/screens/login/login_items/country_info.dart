import 'package:flutter/material.dart';


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
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text("${countryFlag()}  +20",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16,
            ),),
        ),
      ),
    );
  }
}
