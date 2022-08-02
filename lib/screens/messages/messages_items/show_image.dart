import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ShowImage extends StatelessWidget {
  final String image;
  const ShowImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, s) =>
                LoadingImage(width: 100.w, height: 100.h),
            errorWidget: (
              BuildContext context,
              String url,
              dynamic error,
            ) {
              return ErrorImage(
                height: 100.h,
                width: 100.w,
              );
            },
          ),
        ),
      ),
    );
  }
}
//ErrorImage(height: 100.h, width: 100.w,)