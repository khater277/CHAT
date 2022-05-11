import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../shared/colors.dart';

class StoriesFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tag;
  const StoriesFAB({Key? key, required this.onPressed, required this.icon, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38.sp,
      height: 38.sp,
      child: FloatingActionButton(
        heroTag: tag,
        onPressed: onPressed,
        backgroundColor: Colors.grey.shade800,
        child: Icon(
          icon,
          color: MyColors.white,
          size: 16.sp,
        ),
      ),
    );
  }
}
