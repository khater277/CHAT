import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/screens/profile/profile_screen.dart';
import 'package:chat/screens/search/search_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  onPressed: (){
                    Get.to(()=>const ProfileScreen());
                  },
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
                  onPressed: (){

                    Get.to(()=>const SearchScreen());

                    // StoryModel storyModel = StoryModel(
                    //   date: DateTime.now().toString(),
                    //   isImage: false,
                    //   isRead: false,
                    //   isVideo: false,
                    //   videoDuration: "0",
                    //   media: "",
                    //   phone: "+201022707328",
                    //   text: "test",
                    //   viewers: [
                    //     Viewers(id: uId!,dateTime: DateTime.now().toString()),
                    //     Viewers(id: uId!,dateTime: DateTime.now().toString()),
                    //   ],
                    //   canView: [uId!]
                    // );

                    // FirebaseFirestore.instance.collection('stories')
                    //     .doc("1O5pTx02tCXsKSl6PPSrEULtebe2")
                    // .set(storyModel.toJson())
                    // .then((value){
                    //   FirebaseFirestore.instance.collection('stories')
                    //       .doc("1O5pTx02tCXsKSl6PPSrEULtebe2")
                    //       .collection("currentStories")
                    //       .add(storyModel.toJson())
                    //       .then((value){
                    //         print("DONE");
                    //   }).catchError((error){
                    //     print("ERROR $error");
                    //   });
                    // }).catchError((error){
                    //   print("ERROR $error");
                    // });
                  },
                  icon: Icon(IconBroken.Search,size: 18.sp,color: MyColors.grey,)
              )
            )
          ],
        ),
      ),
    );
  }
}

