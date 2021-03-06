import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../cubit/login/login_cubit.dart';
import '../../../shared/default_widgets.dart';


class PhoneInfo extends StatelessWidget {
  final TextEditingController phoneController;
  const PhoneInfo({Key? key, required this.phoneController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: DefaultTextFiled(
        formatters: [FilteringTextInputFormatter.deny(RegExp('[ ]')),],
        controller: phoneController,
        validate: true,
        hint: "",
        hintSize: 0,
        height: 2.h,
        suffix: const Text(""),
        focusBorder: Colors.blue.withOpacity(0.7),
        border: Colors.blue.withOpacity(0.7),
        autoFocus: true,
        cursorColor: MyColors.white,
        rounded: 3.sp,
        letterSpacing: 2,
        inputType: TextInputType.phone,
        onChanged: (value){
          LoginCubit.get(context).phoneValidation(phone: phoneController.text);
        },
      ),
    );
  }
}

