import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/providers/record_player.dart';

class RecorderPlayer extends StatefulWidget {
  final Map<String,dynamic> path;
  const RecorderPlayer({super.key, required this.path});

  @override
  State<RecorderPlayer> createState() => _RecorderPlayerState();
}

class _RecorderPlayerState extends State<RecorderPlayer> {
  final audioPlayer = AudioPlayer();

  bool _isPlaying = false;

  void _playAudio() async {
    await audioPlayer.play(UrlSource(widget.path['url']));
    // setState(() {
    //   _isPlaying = !_isPlaying;
    // });
  }

  void _stopAudio() async {
    await audioPlayer.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        Provider.of<RecordPlayer>(context,listen: false).stopRecords(id: -1);
        // Playback completed
        // setState(() {
        //   _isPlaying = !_isPlaying;
        // });
      } else if (state == PlayerState.stopped) {
        
        // Playback stopped
        // setState(() {
        //   _isPlaying = !_isPlaying;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordPlayer>(
      builder: (context, provider, _) {
        if(provider.playingId == widget.path['id']){
          _playAudio();
        }else{
          _stopAudio();
        }
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(provider.playingId == widget.path['id'] ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  provider.stopRecords(id: provider.playingId == widget.path['id'] ? -1 : widget.path['id']);
                },
                label: Text(tr("audio")),
              ),
            ),
          ],
        );
      },
    );
  }
}
