import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../models/StoryModel.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../styles/icons_broken.dart';
import '../../story_view/story_view_screen.dart';

class AddMyStoryProfileImage extends StatelessWidget {
  final String? image;
  final List<StoryModel> stories;

  const AddMyStoryProfileImage({Key? key, required this.image, required this.stories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image == "" && stories.isEmpty) {
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
              // if(stories.isEmpty)
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
      return stories.isEmpty?
      NoStoryExist(image: image)
      :
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircleAvatar(
            radius: 24.sp,
            backgroundColor: Colors.grey.withOpacity(0.7),
          ),
          CircleAvatar(
            radius: 22.sp,
            backgroundColor: image==""?MyColors.lightBlack:MyColors.blue.withOpacity(0.2),
            backgroundImage: image==""?null:
            CachedNetworkImageProvider("$image"),
            child: image!=""?null:
            const Icon(IconBroken.Profile),
          ),
        ],
      );
    }
  }
}

class NoStoryExist extends StatelessWidget {
  final String? image;


  const NoStoryExist({Key? key, required this.image, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
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
        Padding(
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
      ],
    );
  }
}

class MyStory extends StatelessWidget {
  final String userToken;
  final String? image;
  final List<StoryModel> stories;
  const MyStory({Key? key, required this.image, required this.stories, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(stories.isEmpty) {
          AppCubit.get(context).pickStoryImage();
        }else{
          AppCubit.get(context).zeroStoryIndex();
          Get.to(()=>StoryViewScreen(
            stories: stories,
            profileImage: image!,
            name: "My Story",
            userID: uId!,
            userToken: userToken,
            storiesIDs: null,
          ));
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            AddMyStoryProfileImage(image: image,stories: stories,),
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
                stories.isNotEmpty?
                MyStoryDate(stories: stories):const TabToAddStoryText(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyStoryDate extends StatelessWidget {
  final List<StoryModel> stories;
  const MyStoryDate({Key? key, required this.stories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream stream = Stream.periodic(const Duration(seconds: 1),(a)=>a);
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        String text = DateFormatter().storyDate(stories[stories.length-1].date!);
        return Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontSize: 11.5.sp, color: MyColors.grey),
          overflow: TextOverflow.ellipsis,
        );
      }
    );
  }
}

class TabToAddStoryText extends StatelessWidget {
  const TabToAddStoryText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "tab to add stories update",
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(fontSize: 11.5.sp, color: MyColors.grey),
      overflow: TextOverflow.ellipsis,
    );
  }
}
