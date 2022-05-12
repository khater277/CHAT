import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/default_widgets.dart';

class TextStory extends StatelessWidget {
  final TextEditingController controller;
  const TextStory({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextFormFiled(
      controller: controller,
      textColor: MyColors.white,
      inputType: TextInputType.text,
      hint: "Type Story...",
      hintColor: Colors.grey,
      rounded: 0.sp,
      focusBorder: Colors.transparent,
      border: Colors.transparent,
      textSize: 20.sp,
      formatters: [NoLeadingSpaceFormatter()],
      fillColor: Colors.transparent,
      heightPadding: 1.h,
      widthPadding: 4.w,
      maxLines: 20,
    );
  }
}
