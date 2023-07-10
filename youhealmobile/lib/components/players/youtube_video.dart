import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../providers/video_player.dart';

class YoutubeVideo extends StatefulWidget {
  final String videoId;

  const YoutubeVideo({super.key, required this.videoId});

  @override
  State<YoutubeVideo> createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  YoutubePlayerController? _controller;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
        disableDragSeek: true,
        mute: false,
        hideControls: true,
        // showLiveFullscreenButton: false
      ),
    );

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoPlayerProvider>(
      builder: (context, provider, _) {
        if (provider.stopAllVideos && _controller!.value.isPlaying) {
          setState(() {
            _controller!.pause();
          });
        }
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => YoutubePlayerDialog(
                videoId: widget.videoId,
              ),
            ).then((value) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: YoutubePlayer(
                  
                  controller: _controller!,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class YoutubePlayerDialog extends StatefulWidget {
  final String videoId;
  const YoutubePlayerDialog({super.key, required this.videoId});

  @override
  State<YoutubePlayerDialog> createState() => _YoutubePlayerDialogState();
}

class _YoutubePlayerDialogState extends State<YoutubePlayerDialog> {
  YoutubePlayerController? _controller;
  @override
  void initState() {
    // print(widget.videoId);
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
        disableDragSeek: true,
        mute: false,

        // hideControls: true,
        // showLiveFullscreenButton: false
      ),
    )..addListener(() {
        if (_controller!.value.isFullScreen) {
          setState(() {
            // _controller!.fitHeight(Size.infinite);
            // _controller!.fitWidth(Size.infinite);
          });
        } else {
          setState(() {
            // _controller!.fitWidth(Size.infinite);
            // _controller!.reset();
          });
        }
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        child: YoutubePlayer(
          controller: _controller!,
        ),
      ),
    );
  }
}
