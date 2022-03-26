import 'package:flutter/material.dart';


class OtpHead extends StatelessWidget {
  final String phoneNumber;
  const OtpHead({Key? key, required this.phoneNumber,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Verify your phone number",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 30,),
        RichText(
            text: TextSpan(
              text: "Enter your 6 digit code number sent to ",
              style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                height: 1.5
              ),
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: const TextStyle(
                      fontSize: 17,
                      color: Colors.blue
                  ),
                )
              ]
            )
        ),
      ],
    );
  }
}
