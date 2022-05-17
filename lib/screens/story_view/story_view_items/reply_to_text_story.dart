import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../styles/icons_broken.dart';

class ReplyToTextStory extends StatelessWidget {
  final String name;
  final String text;
  const ReplyToTextStory({Key? key, required this.name, required this.text}) : super(key: key);

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
                      "$name ",
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
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  overflow: TextOverflow.ellipsis
                ),

              )
            ],
          ),
        ),
        SizedBox(width: 2.w,),
        Container(
            color: MyColors.lightBlack,
            width: 40.sp,height: 40.sp,
            child: Icon(IconBroken.Edit,color: MyColors.blue,size: 25.sp,)
        )
      ],
    );
  }
}
