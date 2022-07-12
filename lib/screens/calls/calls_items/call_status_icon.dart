import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallStatusIcon extends StatelessWidget {
  const CallStatusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      const AssetImage("assets/images/inbound.png"),
      color: Colors.green,
      size: 10.sp,);
  }
}
