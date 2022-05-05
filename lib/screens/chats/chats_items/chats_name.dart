import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/colors.dart';
import '../../../shared/date_format.dart';

class ChatsName extends StatelessWidget {
  final UserModel userModel;
  final String date;
  const ChatsName({Key? key, required this.userModel, required this.date,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // String? name;
    // bool isContact = AppCubit.get(context).usersID.contains(userModel.uId);
    // name = isContact?AppCubit.get(context).users.firstWhere((element) =>
    // element.uId==userModel.uId).name!:userModel.name!;


    return Row(
      children: [
        Expanded(
          child: Text(
            "${userModel.name}",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 12.sp
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          DateFormatter().lastMessageDate(date),
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 10.8.sp,
              color: MyColors.grey
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
