import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/add_media_story/add_media_story_items/add_text.dart';
import 'package:chat/screens/add_media_story/add_media_story_items/send_story_button.dart';
import 'package:chat/screens/home/stories_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../shared/default_widgets.dart';

class AddTextStoryScreen extends StatefulWidget {
  const AddTextStoryScreen({Key? key}) : super(key: key);

  @override
  State<AddTextStoryScreen> createState() => _AddTextStoryScreenState();
}

class _AddTextStoryScreenState extends State<AddTextStoryScreen> {

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppSendLastStoryState){
          Get.back();
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: const DefaultBackButton(),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: TextStory(controller: _controller,),
            ),
            floatingActionButton: state is AppSendLastStoryLoadingState?
            SizedBox(
              width: 30.sp,height: 30.sp,
              child: const CircularProgressIndicator(),
            )
              :
            SendStoryButton(
                cubit: cubit,
                state: state,
                controller: _controller,
                mediaSource: null),
          ),
        );
      },
    );
  }
}
