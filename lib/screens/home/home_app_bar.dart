import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: false,
      expandedHeight: 12.h,
      flexibleSpace: FlexibleSpaceBar(
        background: Row(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 2.w),
              child: IconButton(
                  onPressed: (){},
                  icon: Icon(IconBroken.Edit_Square,size: 18.sp,color: MyColors.grey,)
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "NUNTIUS",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      letterSpacing: 2,
                      fontSize: 17.sp,
                      color: MyColors.blue.withOpacity(0.7)
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 2.w),
              child: IconButton(
                  onPressed: (){},
                  icon: Icon(IconBroken.Search,size: 18.sp,color: MyColors.grey,)
              ),
            )
          ],
        ),
      ),
    );
  }
}