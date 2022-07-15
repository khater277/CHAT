import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/calls/calls_items/call_status_icon.dart';
import 'package:chat/screens/calls/calls_items/calls_name_and_caption.dart';
import 'package:chat/screens/calls/calls_items/calls_profile_image.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: MyColors.black,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const HomeAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.only(
                      right: 5.w,
                      left: 5.w,
                      top: 3.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                      child: Row(
                                        children: [
                                          CallsProfileImage(userID: cubit.calls[index].userID!,),
                                          SizedBox(width: 4.w,),
                                          CallsNameAndCaption(cubit: cubit,
                                            callModel: cubit.calls[index],),
                                          CallStatusIcon(callStatus: cubit.calls[index].callStatus!,)
                                        ],
                                      ),
                                    ),
                                    if(index==cubit.calls.length)
                                      SizedBox(height: 2.h,)
                                  ],
                                );
                              },
                              separatorBuilder: (context,index)=>Divider(
                                color: MyColors.grey.withOpacity(0.08),
                              ),
                              itemCount: cubit.calls.length
                          ),
                        )
                      ],
                    )
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
