import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../shared/default_widgets.dart';

class ShowStoryImage extends StatelessWidget {
  final String imgUrl;
  const ShowStoryImage({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // return ErrorImage(
    //     width: width,
    //     height: height/2);
    return CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder:(context,s)=> LoadingImage(width: width, height: height/2),
        fit: BoxFit.cover,
        errorWidget:(context,s,d)=>ErrorImage(
            width: width,
            height: height/2)
    );
  }

}
