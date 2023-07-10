import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/providers/add_post_or_comment_to_cummunity.dart';

class RecordTimer extends StatefulWidget {
  const RecordTimer({super.key});

  @override
  State<RecordTimer> createState() => _RecordTimerState();
}

class _RecordTimerState extends State<RecordTimer> {
  Timer? _timer;
  int seconds = 0;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
        if (seconds == 60) {
          min++;
          if (min == 5) {
            _stopRecording();
          }
          seconds = 0;
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  int min = 0;

  void _stopRecording() async {
    await Provider.of<AddPostOrCommentToCommunity>(context, listen: false)
        .uploadFile(
      fileType: FileType.record,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            await Provider.of<AddPostOrCommentToCommunity>(context,
                    listen: false)
                .uploadFile(
              fileType: FileType.record,
              context: context,
            );
          },
          icon: const Icon(Icons.stop),
        ),
        Expanded(
          child: Chip(
            padding: const EdgeInsets.symmetric(vertical: 10),
            label: Center(
              child: Text("$min:${seconds < 10 ? "0$seconds" : "$seconds"}"),
            ),
          ),
        ),
      ],
    );
  }
}
