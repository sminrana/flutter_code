import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HomeWidget extends StatefulWidget {
  @override
  _VideoWidget createState() => _VideoWidget();
}

class _VideoWidget extends State<HomeWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  bool isReady = false;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Container(
            height: 200,
            child: isReady == true
                ? Chewie(controller: chewieController)
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.videoPlayerController.dispose();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4");
    await Future.wait([videoPlayerController.initialize()]);

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        aspectRatio: 16 / 9,
        autoInitialize: true);

    setState(() {
      isReady = true;
    });

    chewieController.addListener(() {
      if (!chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }
}
