import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/models/ViewerModel.dart';
import 'package:chat/screens/story_view/story_view_items/my_story_items/viewers_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../../../shared/colors.dart';

class MyStoryViewers extends StatelessWidget {
  final List<ViewerModel> viewers;
  final StoryController storyController;

  const MyStoryViewers(
      {Key? key, required this.viewers, required this.storyController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: GestureDetector(
          onTap: () {
            storyController.pause();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                /// use viewer id to get viewer data
                List<UserModel> users = [];
                List<String> viewsDateTime = [];
                for (var viewer in viewers) {
                  UserModel? userModel = AppCubit.get(context)
                      .users
                      .firstWhereOrNull((element) => element.uId == viewer.id);
                  if(userModel!=null) {
                    users.add(userModel);
                  }else{
                    UserModel notContactUser = UserModel(
                      uId: viewer.id,
                      name: viewer.phoneNumber,
                      phone: viewer.phoneNumber,
                      image: "",
                    );
                    users.add(notContactUser);
                  }
                  viewsDateTime.add(viewer.dateTime!);
                }
                return ViewersBottomSheet(
                  users: users,
                  viewsDateTime: viewsDateTime,);
              },
            ).then((value) => storyController.play());
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: MyColors.grey,
                  size: 19.sp,
                ),
                Text(
                  "${viewers.length}",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 11.5.sp,
                        color: MyColors.grey,
                      ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ));
  }
}
