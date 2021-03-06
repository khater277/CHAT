import 'package:chat/cubit/app/app_cubit.dart';
import 'package:flutter/material.dart';

import '../../../cubit/app/app_states.dart';
import '../../../shared/colors.dart';
import '../../../shared/constants.dart';
import '../../../styles/icons_broken.dart';

class SendStoryButton extends StatelessWidget {
  final AppCubit cubit;
  final AppStates state;
  final TextEditingController controller;
  final MediaSource? mediaSource;
  const SendStoryButton({Key? key, required this.cubit, required this.state,
    required this.controller, required this.mediaSource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: MyColors.blue, shape: BoxShape.circle),
      child: IconButton(
        onPressed: state is! AppSendLastStoryLoadingState
            ? () {
          mediaSource!=null?
          cubit.uploadMediaLastStory(
              phone: cubit.userModel!.phone!,
              text: controller.text,
              mediaSource: mediaSource!)
          :
          cubit.sendLastStory(phone: cubit.userModel!.phone!,text: controller.text);
          controller.clear();
        }
            : null,
        icon: const Icon(
          IconBroken.Send,
          color: MyColors.white,
        ),
      ),
    );
  }
}
