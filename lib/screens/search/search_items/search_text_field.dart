import 'package:chat/shared/colors.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  const SearchTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DefaultBackButton(),
        Expanded(
          child: DefaultTextFiled(
            controller: controller,
            autoFocus: true,
            fontSize: 12.sp,
            hint: "search...",
            hintSize: 12.sp,
            height: 5.h,
            prefix: Icon(
              IconBroken.Search,
              size: 20.sp,
              color: MyColors.white.withOpacity(0.7),
            ),
            suffix: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (BuildContext context, TextEditingValue value,
                  Widget? child) {
                if (value.text.isNotEmpty) {
                  return IconButton(
                    onPressed: () {
                      controller.clear();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red.withOpacity(0.7),
                      size: 15.sp,
                    ),
                  );
                }else{
                  return const DefaultNullWidget();
                }
              },
            ),
            focusBorder: MyColors.blue.withOpacity(0.4),
            border: MyColors.grey.withOpacity(0.3),
            inputType: TextInputType.text,
            formatters: [NoLeadingSpaceFormatter()],
            rounded: 20.sp,
            cursorColor: MyColors.blue.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
