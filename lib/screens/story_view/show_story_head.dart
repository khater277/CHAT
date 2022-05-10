import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/StoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../shared/colors.dart';
import '../../shared/constants.dart';
import '../../shared/date_format.dart';
import '../../styles/icons_broken.dart';

class ShowStoryHead extends StatelessWidget {
  final AppCubit cubit;
  final StoryModel story;
  final String profileImage;
  const ShowStoryHead({Key? key, required this.cubit,required this.profileImage,
    required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: (){
              Get.back();
              },
            icon: Icon(
              languageFun(ar: IconBroken.Arrow___Right_2, en: IconBroken.Arrow___Left_2),
              size: 15.sp,
            ),
          ),
          StoryHeadProfileImage(profileImage: profileImage),
          SizedBox(width: 2.w,),
          ShowStoryNameAndDate(story: story)
        ],
      ),
    );
  }
}

class StoryHeadProfileImage extends StatelessWidget {
  final String profileImage;
  const StoryHeadProfileImage({Key? key, required this.profileImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.sp,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: CircleAvatar(
        radius: 19.sp,
        backgroundColor: MyColors.blue.withOpacity(0.2),
        backgroundImage: CachedNetworkImageProvider(profileImage),
      ),
    );
  }
}

class ShowStoryNameAndDate extends StatelessWidget {
  final StoryModel story;
  const ShowStoryNameAndDate({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ShowMyStoryDate(story: story),
      ],
    );
  }
}

class ShowMyStoryDate extends StatelessWidget {
  final StoryModel story;
  const ShowMyStoryDate({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream stream = Stream.periodic(const Duration(seconds: 1),(a)=>a);
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          String text = DateFormatter().storyDate(story.date!);
          return Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: 10.sp, color: MyColors.grey),
            overflow: TextOverflow.ellipsis,
          );
        }
    );
  }
}
