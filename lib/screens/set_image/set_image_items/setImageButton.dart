import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../cubit/login/login_cubit.dart';
import '../../../cubit/login/login_states.dart';
import '../../../shared/colors.dart';
import '../../../shared/default_widgets.dart';


class SetImageButton extends StatelessWidget {
  final LoginCubit cubit;
  final LoginStates state;

  const SetImageButton({Key? key, required this.cubit, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: DefaultElevatedButton(
          child: state is! LoginLoadingState
              ? Text(
            "Next",
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: MyColors.black,
                fontSize: 17.sp
            ),
          )
              :
          DefaultButtonLoader(
              size: 20.sp, width: 6.5.sp, color: MyColors.black),
          color: MyColors.white,
          rounded: 10.sp,
          height: 5.8.h,
          width: 20.w,
          onPressed: () {
            cubit.uploadProfileImage(isOpening: true);
          }),
    );
  }
}
