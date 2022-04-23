import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../styles/icons_broken.dart';

class AnimatedControllerBuilder extends StatelessWidget {
  final AppCubit cubit;
  final ValueNotifier showAnimatedContainer;
  final TextEditingController messageController;
  const AnimatedControllerBuilder({Key? key,required this.cubit,
    required this.showAnimatedContainer, required this.messageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: messageController,
      builder: (BuildContext context, TextEditingValue v, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: showAnimatedContainer,
          builder: (BuildContext context, value, Widget? child) {
            return showAnimatedContainer.value && v.text.isNotEmpty?
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: AnimatedContainer(
                  width: double.infinity,height: 12.h,
                  duration: const Duration(seconds: 2),
                  curve: Curves.elasticInOut,
                  decoration: BoxDecoration(
                      color: MyColors.lightBlack,
                      borderRadius: BorderRadius.circular(10.sp)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: (){
                          cubit.selectMessageImage(mediaSource: MediaSource.image);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Image,size: 22.sp,
                              color: MyColors.blue.withOpacity(0.8),
                            ),
                            SizedBox(height: 1.h,),
                            Text(
                              "Photo",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 14,color: MyColors.blue
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          cubit.selectMessageImage(mediaSource: MediaSource.video);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Video,size: 22.sp,
                              color: MyColors.blue.withOpacity(0.8),
                            ),
                            SizedBox(height: 1.h,),
                            Text(
                              "Video",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 14,color: MyColors.blue
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          //cubit.selectMessageImage();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconBroken.Folder,size: 22.sp,
                              color: MyColors.blue.withOpacity(0.8),
                            ),
                            SizedBox(height: 1.h,),
                            Text(
                              "Documentation",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 14,color: MyColors.blue
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                :
            const DefaultNullWidget();
          },
        );
      },
    );
  }
}
