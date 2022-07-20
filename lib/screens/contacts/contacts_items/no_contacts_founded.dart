import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NoContactsFounded extends StatelessWidget {
  const NoContactsFounded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconBroken.User1,
                    size: 100.sp,
                    color: MyColors.grey.withOpacity(0.4),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Flexible(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "add new ",
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 11.sp,
                                    color: MyColors.grey.withOpacity(0.5),
                                    height: 1.5
                                ),
                                children: [
                                  TextSpan(
                                    text: "NUNTUIS ",
                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        fontSize: 13.sp,
                                        color: MyColors.blue.withOpacity(0.7)
                                    ),
                                  ),
                                  TextSpan(
                                      text: "users to your contacts and start new conversations with them",
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                        fontSize: 11.sp,
                                        color: MyColors.grey.withOpacity(0.5),
                                        height: 1.5,
                                      )),
                                ]
                            )
                        ),
                      )
                    // Text(
                    //   text,
                    //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    //     color: Colors.grey.withOpacity(0.6),
                    //     fontSize: 14.sp,
                    //     height: 1.4,
                    //     letterSpacing: 0.8
                    // ),
                    //   textAlign: TextAlign.center
                    //   ,),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
