import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CallStatusIcon extends StatelessWidget {
  final String callStatus;
  const CallStatusIcon({Key? key, required this.callStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late int _quarter;
    late String _icon;
    late Color _iconColor;

    if(callStatus=="outcoming"){
      _quarter = 0;
      _icon = "assets/images/inbound.png";
      _iconColor = Colors.green;
    }else if(callStatus=="incoming"){
      _quarter = 2;
      _icon = "assets/images/inbound.png";
      _iconColor = Colors.green;
    }else if(callStatus=="no response"){
      _quarter = 2;
      _icon = "assets/images/missed.png";
      _iconColor = Colors.red;
    }else{
      _quarter = 0;
      _icon = "assets/images/missed.png";
      _iconColor = Colors.red;
    }

    return RotatedBox(
      quarterTurns: _quarter,
      child: ImageIcon(
        AssetImage(_icon),
        color: _iconColor,
        size: 10.sp,
      ),
    );
  }
}
