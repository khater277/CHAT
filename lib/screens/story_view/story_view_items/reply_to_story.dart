import 'package:chat/screens/story_view/story_view_items/reply_story_textfield.dart';
import 'package:chat/screens/story_view/story_view_items/reply_to_text_story.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:story_view/controller/story_controller.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../cubit/app/app_states.dart';
import '../../../shared/colors.dart';
import 'reply_to_media_story.dart';

class ReplyToStory extends StatefulWidget {
  final AppCubit cubit;
  final AppStates state;
  final StoryController storyController;
  final String userID;
  final String name;
  final String storyMedia;
  final String storyDate;
  final MediaSource? mediaSource;
  const ReplyToStory({Key? key, required this.storyController, required this.cubit,
    required this.state, required this.userID, required this.storyMedia,
    required this.mediaSource, required this.name, required this.storyDate}) : super(key: key);

  @override
  State<ReplyToStory> createState() => _ReplyToStoryState();
}

class _ReplyToStoryState extends State<ReplyToStory> {

  final TextEditingController _messageController = TextEditingController();


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Padding(
          padding:  EdgeInsets.only(bottom: 2.h),
          child: GestureDetector(
            onTap: (){
              widget.storyController.pause();
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.lightBlack,
                            borderRadius: BorderRadius.circular(5.sp)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 2.h,
                              bottom: 1.h,
                              left: 4.w,
                              right: 4.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(widget.mediaSource==null)
                                ReplyToTextStory(name: widget.name,)
                              else if (widget.mediaSource==MediaSource.image)
                                ReplyToMediaStory(
                                  name: widget.name,
                                  storyMedia: widget.storyMedia,
                                  isVideo: false,)
                              else
                              ReplyToMediaStory(
                                name: widget.name,
                                  storyMedia: widget.storyMedia,
                                  isVideo: true,),
                              SizedBox(height: 2.h,),
                              ReplyStoryTextField(
                                cubit: widget.cubit,
                                  state: widget.state,
                                  messageController: _messageController,
                              userID: widget.userID,
                              storyMedia: widget.storyMedia,
                              storyDate: widget.storyDate,
                              mediaSource: widget.mediaSource,)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
              ).whenComplete((){
                _messageController.clear();
                widget.storyController.play();
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    IconBroken.Arrow___Up_2,
                    color: MyColors.grey,
                    size: 18.sp,
                  ),
                  Text(
                    "REPLY",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(
                      fontSize: 11.5.sp,
                      color: MyColors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
