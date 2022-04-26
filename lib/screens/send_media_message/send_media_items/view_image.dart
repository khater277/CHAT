import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ViewImage extends StatelessWidget {
  final File file;
  const ViewImage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
            file,
          width: double.infinity,
          height: 25.h,
        )
    );
  }
}
