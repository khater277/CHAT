import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../shared/colors.dart';

class ReplyToMediaStory extends StatefulWidget {
  final String name;
  final String storyMedia;
  final bool isVideo;
  const ReplyToMediaStory({Key? key, required this.storyMedia, required this.isVideo,
    required this.name}) : super(key: key);

  @override
  State<ReplyToMediaStory> createState() => _ReplyToMediaStoryState();
}

class _ReplyToMediaStoryState extends State<ReplyToMediaStory> {

  String? fileName;

  @override
  void initState() {
    if(widget.isVideo) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
        VideoThumbnail.thumbnailFile(
          video: widget.storyMedia,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.WEBP,
          maxHeight: 64,
          quality: 75,
        ).then((value){
          setState(() {
            fileName = value!;
          });
          return null;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "${widget.name} ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                          fontSize: 12.sp,
                          color: MyColors.blue
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 1.5.sp,
                    backgroundColor: MyColors.blue,
                  ),
                  Text(
                    " Story",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(
                        fontSize: 12.sp,
                        color: MyColors.blue
                    ),
                  ),
                  SizedBox(width: 2.w,)
                ],
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    widget.isVideo?IconBroken.Video:IconBroken.Image_2,
                    color: Colors.grey,size: 13.sp,
                  ),
                  SizedBox(width: 1.w,),
                  Text(
                    widget.isVideo?"video":"photo",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(
                        fontSize: 12.sp,
                        color: Colors.grey
                    ),

                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          color: MyColors.lightBlack,
          width: fileName==null?20.sp:40.sp,height: fileName==null?20.sp:40.sp,
          child: widget.isVideo?
          fileName==null?
          CircularProgressIndicator(strokeWidth: 2.sp,)
              // Icon(IconBroken.Video,color: MyColors.blue,size: 25.sp,)
          :
          Image.file(File(fileName!))
          :
          CachedNetworkImage(
            imageUrl:widget.storyMedia,
            fit: BoxFit.cover,
          )
        )
      ],
    );
  }
}
