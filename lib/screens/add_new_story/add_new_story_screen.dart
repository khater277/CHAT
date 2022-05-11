import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/add_new_story/add_new_story_items/add_caption.dart';
import 'package:chat/screens/add_new_story/add_new_story_items/send_story_button.dart';
import 'package:chat/screens/add_new_story/add_new_story_items/story_video.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../shared/constants.dart';
import 'add_new_story_items/story_image.dart';

class AddNewStoryScreen extends StatefulWidget {
  final MediaSource mediaSource;
  const AddNewStoryScreen({
    Key? key, required this.mediaSource,
  }) : super(key: key);

  @override
  State<AddNewStoryScreen> createState() => _AddNewStoryScreenState();
}

class _AddNewStoryScreenState extends State<AddNewStoryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppSendLastStoryState) {
          Get.back();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                if(widget.mediaSource == MediaSource.image)
                  StoryImage(cubit: cubit),
                if(widget.mediaSource == MediaSource.video)
                  StoryVideo(cubit: cubit,),
                const CloseButton(),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                    child: Row(
                      children: [
                        AddCaptionTextField(controller: _controller),
                        SizedBox(
                          width: 2.w,
                        ),
                        SendStoryButton(
                            cubit: cubit,
                            state: state,
                            controller: _controller,
                        mediaSource: widget.mediaSource,)
                      ],
                    ),
                  ),
                ),
                if (state is AppSendLastStoryLoadingState)
                  Center(
                      child: CircularProgressIndicator(
                    value: cubit.storyFilePercentage == 0.0
                        ? 0.05
                        : cubit.storyFilePercentage,
                    color: MyColors.blue,
                    backgroundColor: MyColors.grey,
                  )),
              ],
            ),
          ),
        );
      },
    );
  }
}



