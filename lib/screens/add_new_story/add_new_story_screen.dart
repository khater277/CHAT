import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/home/home_screen.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AddNewStoryScreen extends StatefulWidget {
  const AddNewStoryScreen({Key? key, }) : super(key: key);

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
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppSendLastStoryState){
          Get.back();
        }
      },
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                StoryImage(cubit: cubit),
                const CloseButton(),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultTextFormFiled(
                              controller: _controller,
                              textColor: MyColors.white,
                              inputType: TextInputType.text,
                              hint: "add a caption...",
                              hintColor: Colors.grey,
                              rounded: 30.sp,
                              focusBorder: MyColors.lightBlack,
                              border: MyColors.lightBlack,
                              textSize: 13.sp,
                              formatters: [NoLeadingSpaceFormatter()],
                            fillColor: MyColors.lightBlack,
                            heightPadding: 1.h,
                            widthPadding: 4.w,
                          ),
                        ),
                        SizedBox(width: 2.w,),
                        Container(
                          decoration: const BoxDecoration(
                            color: MyColors.blue,
                            shape: BoxShape.circle
                          ),
                          child: IconButton(
                            onPressed: (){
                                cubit.uploadMediaLastStory(
                                    phone: AppCubit.get(context).userModel!.phone!,
                                    text: _controller.text,
                                    mediaSource: MediaSource.image);
                            },
                            icon: const Icon(IconBroken.Send,color: MyColors.white,),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if(state is AppSendLastStoryLoadingState)
                Center(
                    child: CircularProgressIndicator(
                      value: cubit.storyImagePercentage==0.0?0.05:cubit.storyImagePercentage,
                      color: MyColors.blue,
                      backgroundColor: MyColors.grey,
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StoryImage extends StatelessWidget {
  final AppCubit cubit;
  const StoryImage({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.file(
        cubit.storyImage!,
        fit: BoxFit.cover,
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: MyColors.lightBlack
        ),
        child: IconButton(
            onPressed: (){
              Get.back();
              // AppCubit.get(context).cleanStoryFile();
            },
            icon: Icon(Icons.close,color: Colors.white,size: 20.sp,)
        ),
      ),
    );
  }
}
