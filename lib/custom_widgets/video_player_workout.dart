import 'dart:io';

import 'package:fitness/model/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWorkout extends StatefulWidget {
  const VideoPlayerWorkout({super.key, required this.workoutModel, required this.ready});

  final WorkOutModel workoutModel;
  final Function ready;

  @override
  State<VideoPlayerWorkout> createState() => _VideoPlayerWorkoutState();
}

class _VideoPlayerWorkoutState extends State<VideoPlayerWorkout> {

  late VideoPlayerController _controller;
  bool isSetVideo = false;
  @override
  void initState() {
    _controller = VideoPlayerController.asset("assets/videos/training/${widget.workoutModel.id}.mp4")
      ..initialize().then((_) => {
        _controller.play(),
        _controller.setLooping(true),
        widget.ready(),
        setState(() {})
      });
    // initVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: getApplicationDocumentsDirectory(),
    //   builder: (context, snapshot) {
    //     if (snapshot.data != null &&
    //             snapshot.connectionState ==
    //                 ConnectionState.done && !isSetVideo)
    //
    //     {
    //       final url = "${snapshot.data?.path}/training_video/${widget.workoutModel.id}.mp4";
    //             _controller =
    //             VideoPlayerController.file(File(url))
    //               ..initialize().then((_) => {
    //                 _controller.play(),
    //                 _controller.setLooping(true),
    //                 isSetVideo = true,
    //                 widget.ready(),
    //                 setState(() {})
    //               });
    //       return VideoPlayer(_controller);
    //     } else if (snapshot.data == null ||
    //         snapshot.connectionState ==
    //             ConnectionState.waiting){
    //       return SizedBox();
    //     }
    //     else
    //       return VideoPlayer(_controller);
    //   }
    // );
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void initVideo() async {
  //   final files = await getApplicationDocumentsDirectory();
  //   final url = "${files.path}/training_video/${widget.workoutModel.id}.mp4";
  //   _controller = VideoPlayerController.file(File(url))
  //     ..initialize().then((_) => {
  //       _controller.play(),
  //       _controller.setLooping(true),
  //       widget.ready(),
  //       setState(() {})
  //     });
  //
  // }
}
