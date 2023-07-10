import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../providers/video_player.dart';



class CustomVideoPlayer extends StatefulWidget {
  final String path;
  const CustomVideoPlayer({super.key, required this.path});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print(widget.path);
    if (widget.path.startsWith("http")) {
      _controller = VideoPlayerController.network(widget.path);
    } else {
      _controller = VideoPlayerController.file(File(widget.path));
    }
    // ignore: avoid_single_cascade_in_expression_statements
    _controller
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    print("dispose");
    if (_controller.value.isPlaying) _controller.pause();
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Consumer<VideoPlayerProvider>(
            builder: (context, provider, _) {
              if(provider.stopAllVideos && _controller.value.isPlaying){
                setState(() {
                  _controller.pause();
                });
              }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    provider.stopAllVideos = false;
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(_controller),
                      !_controller.value.isPlaying
                          ? const Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}
