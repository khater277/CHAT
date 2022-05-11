import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyName extends StatelessWidget {
  final AppCubit cubit;
  final String name;

  const MyName({Key? key, required this.name, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            IconBroken.Profile,
            size: 20.sp,
            color: MyColors.grey,
          ),
          SizedBox(
            width: 5.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 13.sp, color: Colors.white),
                ),
                SizedBox(
                  height: 0.3.h,
                ),
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 14.sp, color: MyColors.blue),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "This is not your username or pin. This name will be visible to your NUNTIUS contacts",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 10.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          EditMyName(
            cubit: cubit,
            name: name,
          ),
        ],
      ),
    );
  }
}

class EditMyName extends StatefulWidget {
  final AppCubit cubit;
  final String name;

  const EditMyName({Key? key, required this.cubit, required this.name}) : super(key: key);

  @override
  State<EditMyName> createState() => _EditMyNameState();
}

class _EditMyNameState extends State<EditMyName> {
  final TextEditingController _nameController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.name;
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                    color: MyColors.lightBlack,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.sp),
                      topRight: Radius.circular(5.sp),
                    )),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        "Enter your name",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 13.sp),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          children: [
                            EditNameTextField(nameController: _nameController),
                            SizedBox(
                              height: 2.h,
                            ),
                            CancelSaveButtons(nameController: _nameController),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        icon: Icon(
          IconBroken.Edit,
          size: 16.sp,
          color: MyColors.grey,
        ));
  }
}


class EditNameTextField extends StatelessWidget {
  final TextEditingController nameController;
  const EditNameTextField({Key? key, required this.nameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [NoLeadingSpaceFormatter()],
      controller: nameController,
      maxLength: 25,
      style: Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(fontSize: 13.sp, letterSpacing: 1),
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: MyColors.grey,),
        suffixStyle: TextStyle(
            color: MyColors.grey,
            fontSize: 13.sp
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0.5.h, horizontal: 2.w),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.blue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.blue),
        ),
      ),
    );
  }
}



class CancelSaveButtons extends StatelessWidget {
  final TextEditingController nameController;
  const CancelSaveButtons({Key? key, required this.nameController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("CANCEL")),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameController,
          builder: (BuildContext context, value, Widget? child) {
            return TextButton(
                onPressed: () {
                  int endCnt=0;
                  if(value.text.endsWith(" ")){
                    for(int i=value.text.length-1;i>=0;i--){
                      if(value.text[i]==" "){
                        endCnt++;
                      }else{
                        break;
                      }
                    }
                  }
                  AppCubit.get(context).updateName(
                      name: nameController.text.substring(
                          0,nameController.text.length-endCnt)
                  );
                  Get.back();
                },
                child: const Text("SAVE"));
          },
        ),
      ],
    );
  }
}
