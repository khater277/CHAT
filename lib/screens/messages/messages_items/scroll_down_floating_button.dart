import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../shared/default_widgets.dart';
import '../../../styles/icons_broken.dart';

class ScrollDownFloatingButton extends StatelessWidget {
  final ValueNotifier valueNotifier;
  final ScrollController scrollController;
  const ScrollDownFloatingButton({Key? key, required this.valueNotifier, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, value, Widget? child) {
        return value!=true && scrollController.position.pixels!=0.0?
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5.w,vertical: 1.5.h),
            child: SizedBox(
              width: 27.sp,height: 27.sp,
              child: FloatingActionButton(
                onPressed: (){scrollDown(scrollController);},
                shape: const CircleBorder(),
                backgroundColor: MyColors.lightBlack,
                child: Icon(IconBroken.Arrow___Down_2,size: 13.sp,color: MyColors.blue,),
              ),
            ),
          ),
        )
            :
        const DefaultNullWidget();
      },
    );
  }
}