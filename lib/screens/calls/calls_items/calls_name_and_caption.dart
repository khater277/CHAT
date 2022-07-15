import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/CallModel.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/date_format.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CallsNameAndCaption extends StatelessWidget {
  final AppCubit cubit;
  final CallModel callModel;
  const CallsNameAndCaption({Key? key, required this.callModel, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late String name;

    UserModel? userModel = cubit.users.firstWhereOrNull((element) =>
    element.uId==callModel.userID);

    if(userModel==null){
      name = callModel.phoneNumber!;
    }else{
      name = userModel.name!;
    }

    IconData? _icon;

    if(callModel.callStatus=="incoming"||callModel.callStatus=="outcoming"){
      _icon = callModel.callType=="voice"?IconBroken.Call:IconBroken.Video;
    }else{
      _icon = callModel.callType=="voice"?IconBroken.Call_Missed:null;
    }
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 12.sp
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.4.h,),
          Row(
            children: [
              if(_icon!=null)
              Icon(
                _icon,
                size: 10.sp,
                color: MyColors.blue,)
              else
                ImageIcon(
                  const AssetImage("assets/images/missed-video-call.png"),
                  color: MyColors.blue,
                  size: 10.sp,
                ),
              SizedBox(width: 1.5.w,),
              Text(
                "${callModel.callStatus} - ${DateFormatter().lastMessageDate(callModel.dateTime!)}",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 10.5.sp,
                    color: MyColors.grey
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      ),
    );
  }
}
