import 'package:chat/shared/colors.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchStatus extends StatelessWidget {
  final String text;
  final IconData icon;
  const SearchStatus({Key? key, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: NoItemsFounded(
            text: text,
            widget: Icon(
              icon,
              color: MyColors.grey.withOpacity(0.3),
              size: 200.sp,
            )
        ),
      ),
    );
  }
}
