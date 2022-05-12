import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/default_widgets.dart';

class AddCaptionTextField extends StatelessWidget {
  final TextEditingController controller;
  const AddCaptionTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTextFormFiled(
        controller: controller,
        textColor: MyColors.white,
        inputType: TextInputType.text,
        hint: "add a caption...",
        hintColor: Colors.grey,
        rounded: 30.sp,
        focusBorder: MyColors.lightBlack,
        border: MyColors.lightBlack,
        textSize: 13.sp,
        formatters: [NoLeadingSpaceFormatter()],
        fillColor: MyColors.lightBlack,
        heightPadding: 1.h,
        widthPadding: 4.w,
      ),
    );
  }
}
