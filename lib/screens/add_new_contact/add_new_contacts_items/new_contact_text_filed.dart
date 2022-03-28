import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../shared/colors.dart';
import '../../../shared/default_widgets.dart';

class NewContactTextFiled extends StatelessWidget {
  final bool isName;
  final TextEditingController controller;
  final TextInputType inputType;
  final String hint;
  final IconData icon;
  final List<TextInputFormatter> formatters;
  const NewContactTextFiled({Key? key,required this.isName,required this.inputType, required this.controller,
    required this.hint, required this.formatters, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormFiled(
      controller: controller,
      textColor: Theme.of(context).textTheme.bodyText1!.color!,
      inputType: inputType,
      hint: hint,
      hintColor: Colors.grey.withOpacity(0.5),
      rounded: 20.sp,
      focusBorder: MyColors.blue.withOpacity(0.5),
      border: Colors.grey.withOpacity(0.4),
      textSize: 17.sp,
      formatters: formatters,
      heightPadding: isName?2.h:2.4.h,
      cursorColor: MyColors.grey.withOpacity(0.5),
      validateText: "*required filed",
      prefix: Icon(icon,size: 18.sp,color: MyColors.grey.withOpacity(0.8),),
    );
  }
}
