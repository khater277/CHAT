import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/story_view/story_view_items/my_story_items/viewer_details.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewersBottomSheet extends StatelessWidget {
  final List<UserModel> users;
  final List<String> viewsDateTime;
  const ViewersBottomSheet({Key? key,required this.users, required this.viewsDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Container(
        decoration: BoxDecoration(
            color: MyColors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.sp),
              topRight: Radius.circular(10.sp),
            )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
              child: Text(
                "Total viewers ${users.length}",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 14.sp,
                    color: MyColors.blue.withOpacity(0.7),
                    letterSpacing: 1
                ),),
            ),
            SizedBox(
              height: users.length<5?(users.length*10).h:50.h,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.8.h,horizontal: 2.w),
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: ViewerDetails(
                          user: users[index],
                          viewDateTime: viewsDateTime[index],),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 1.h,
                    );
                  },
                  itemCount: users.length),
            ),
          ],
        ),
      ),
    );
  }
}
