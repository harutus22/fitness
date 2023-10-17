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

  @override
  void initState() {
    _controller = VideoPlayerController.asset("assets/videos/training/${widget.workoutModel.id}.mp4")
      ..initialize().then((_) => {
        _controller.play(),
        _controller.setLooping(true),
        widget.ready(),
        setState(() {})
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
