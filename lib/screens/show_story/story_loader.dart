import 'dart:async';

import 'package:flutter/material.dart';

class StoryLoader extends StatelessWidget {
  final int length;
  const StoryLoader({Key? key, required this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Stream<int> stream = Stream.periodic(
        const Duration(milliseconds: 10), ((a)  => a)).take(3001);
    return StreamBuilder<int>(
        stream: stream,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            double? percentage = snapshot.data!/3000;
            // return Text("${micros}");
            return Column(
              children: [
                Text("${snapshot.data!/100}"),
                LinearProgressIndicator(value: percentage,),
              ],
            );
          }else{
            return const LinearProgressIndicator(value: 0.0);
          }
        }
    );
  }
}

