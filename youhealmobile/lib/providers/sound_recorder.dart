import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/providers/add_post_or_comment_to_cummunity.dart';
import 'dart:io';

class SoundRecorder {
  FlutterSoundRecorder? _recorder;

  bool _isRecorderInitialise = false;

  bool get isRecording => _recorder!.isRecording;

  File? audioFile;

  Future init() async {
    _recorder = FlutterSoundRecorder();
    // _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));
    await _recorder!.openRecorder();
  }

  Future<String> _getFilePath(int recordId) async {
    final directory =
        await getTemporaryDirectory(); // or getApplicationDocumentsDirectory()
    return '${directory.path}/audio_recording_$recordId.aac';
  }

  Future _startRecoring(int recordId) async {
    if (!_isRecorderInitialise) return;

    String path = await _getFilePath(recordId);
    await _recorder!.startRecorder(
      toFile: path,
    );
  }

  Future _stopRecoring(int recordId) async {

    if (!_isRecorderInitialise) return;
    await _recorder!.stopRecorder();
    audioFile = File(await _getFilePath(recordId));
  }

  Future toggleRecording(BuildContext context) async {
    final provider =
        Provider.of<AddPostOrCommentToCommunity>(context, listen: false);
    if (_recorder!.isStopped) {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission denied');
      }
      _isRecorderInitialise = true;
      provider.notifyRecord();
      await _startRecoring(provider.uploads['records'].length);
      
    } else {
      await _stopRecoring(provider.uploads['records'].length);
      provider.uploads['records'].add(audioFile);
      provider.notifyRecord();
    }
  }

  void dispose() {
    if (!_isRecorderInitialise) return;
    _recorder!.closeRecorder();
    _recorder = null;
    _isRecorderInitialise = false;
  }
}
