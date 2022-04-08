import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SetNameTextFiled extends StatelessWidget {
  final TextEditingController nameController;
  const SetNameTextFiled({Key? key, required this.nameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      autofocus: true,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: 13.sp
      ),
      decoration: InputDecoration(
        hintText: "enter your name",
        hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: Colors.grey,
          fontSize: 12.sp
        ),
      ),
    );
  }
}
