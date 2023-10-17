import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/const.dart';

class DownloadProgressIndicator extends StatefulWidget {
  const DownloadProgressIndicator({super.key, this.count, required this.close});

  final count;
  final Function() close;

  @override
  State<DownloadProgressIndicator> createState() => _DownloadProgressIndicatorState();
}

class _DownloadProgressIndicatorState extends State<DownloadProgressIndicator> {

  int prog = 0;

  @override
  void initState() {
    download((result){
      setState(() {
        prog = result;
        if(prog == 105)
          widget.close();
      });
    });
    super.initState();
  }

  final Reference ref = FirebaseStorage.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 10,),
        Text("Downloading your plan...", style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold
        ), textAlign: TextAlign.center,),
        SizedBox(height: 10,),
        Text("${(prog / 105 * 100).toStringAsFixed(2)}%", style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold
        ),)
      ],
    );
  }

  void download(Function(int) result) async {
    int length = widget.count;
    databaseHelper.getWorkoutModels().then((value) async {
      final dir = await getApplicationDocumentsDirectory();
      for(var item = length; item < value.length; item++){
        var video = ref.child("training_videos").child("${value[item].id}.mp4");
        // var image = ref.child("training_images").child("${value[item].id}.jpg");
        final fileVideo = File("${dir.path}/training_video/${video.name}");
        // final fileImage = File("${dir.path}/training_image/${image.name}");
        final a = await video.writeToFile(fileVideo);
        // final b = await image.writeToFile(fileImage);
        result(item);
        print(a);
        // print(b);
      }
      result(105);
    });
  }
}
