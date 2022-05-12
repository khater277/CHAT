import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: MyColors.lightBlack),
        child: IconButton(
            onPressed: () {
              Get.back();
              // AppCubit.get(context).cleanStoryFile();
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 20.sp,
            )),
      ),
    );
  }
}
