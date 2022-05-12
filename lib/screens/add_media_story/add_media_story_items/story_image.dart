import 'package:flutter/material.dart';

import '../../../cubit/app/app_cubit.dart';
import '../../../shared/default_widgets.dart';

class StoryImage extends StatefulWidget {
  final AppCubit cubit;

  const StoryImage({Key? key, required this.cubit}) : super(key: key);

  @override
  State<StoryImage> createState() => _StoryImageState();
}
class _StoryImageState extends State<StoryImage> {
  double? width;
  double? height;

  @override
  void initState() {
    decodeImageFromList(widget.cubit.storyFile!.readAsBytesSync())
        .then((value) {
      setState(() {
        width = value.width + 0.0;
        height = value.height + 0.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    if (width != null && height != null) {
      return SizedBox(
        width: deviceWidth,
        height: deviceHeight,
        child: widget.cubit.storyFile != null
            ? Image.file(
          widget.cubit.storyFile!,
          fit: width!>=deviceWidth?BoxFit.fitWidth:
          height!>=deviceHeight?BoxFit.fitHeight:null,
        )
            : null,
      );
    } else {
      return const DefaultNullWidget();
    }
  }
}