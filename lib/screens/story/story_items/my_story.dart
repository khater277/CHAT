import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/screens/add_new_story/add_new_story_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../styles/icons_broken.dart';

class AddMyStoryProfileImage extends StatelessWidget {
  final String? image;

  const AddMyStoryProfileImage({Key? key, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image == "") {
      return SizedBox(
          width: 13.w,
          height: 6.5.h,
          child: Stack(
            children: [
              Align(
                  alignment: AlignmentDirectional.center,
                  child: Icon(
                    IconBroken.Profile,
                    color: MyColors.blue,
                    size: 30.sp,
                  )),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 0.2.h, horizontal: 0.3.w),
                  child: CircleAvatar(
                    radius: 7.5.sp,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: CircleAvatar(
                        radius: 6.sp,
                        backgroundColor: MyColors.blue.withOpacity(0.7),
                        child: Icon(
                          Icons.add,
                          color: MyColors.white,
                          size: 10.sp,
                        )),
                  ),
                ),
              ),
            ],
          ));
    } else {
      return SizedBox(
        width: 14.5.w,
        height: 7.5.h,
        child: Stack(
          // alignment: AlignmentDirectional.bottomEnd,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: CircleAvatar(
                radius: 21.sp,
                backgroundColor: MyColors.blue.withOpacity(0.2),
                backgroundImage: image==null?null:
                    CachedNetworkImageProvider("$image"),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.2.h,horizontal: 0.3.w),
                child: CircleAvatar(
                  radius: 7.5.sp,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  child: CircleAvatar(
                      radius: 6.sp,
                      backgroundColor: MyColors.blue.withOpacity(0.7),
                      child: Icon(Icons.add,color: MyColors.white,size: 10.sp,)
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

class MyStory extends StatelessWidget {
  final String? image;
  const MyStory({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        AppCubit.get(context).pickStoryImage();
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            AddMyStoryProfileImage(image: image),
            SizedBox(
              width: 4.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My story",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 13.sp),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 0.5.h,
                ),
                Text(
                  "tab to add stories update",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 11.5.sp, color: MyColors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
