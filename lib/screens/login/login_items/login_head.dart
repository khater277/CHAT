import 'package:flutter/material.dart';

class LoginHead extends StatelessWidget {
  const LoginHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your phone number?",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 30,),
        Text(
          "please enter your phone number to verify your account",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: 16,
            color: Colors.grey.shade600
          ),
        ),
      ],
    );
  }
}
