import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../shared/colors.dart';

class SendFileMessage extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  const SendFileMessage({Key? key, required this.cubit, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is AppSelectFileState || cubit.isDoc) {
      return Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Container(
                width: double.infinity,
                height: 12.h,
                decoration: BoxDecoration(
                    color: MyColors.lightBlack,
                    borderRadius: BorderRadius.circular(10.sp)),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Row(
                            children: [
                              Icon(IconBroken.Document,color: MyColors.blue,size: 20.sp,),
                              SizedBox(width: 2.w,),
                              Expanded(
                                child: Text(
                                    "${cubit.docName}",
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 15.sp
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if(state is AppSendMediaMessageLoadingState)
                                DefaultUploadIndicator(percentage: cubit.percentage!),
                            ],
                          ),
                        )
                    ),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                        child: GestureDetector(
                          onTap: (){cubit.cancelSelectFile();},
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
                            child: Icon(IconBroken.Close_Square,color: Colors.red,size: 16.sp,),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
    } else {
      return const DefaultNullWidget();
    }
  }
}
