import 'package:flutter/material.dart';

class VideoPlayerProvider with ChangeNotifier{
  bool stopAllVideos = false;
  void stopVideos() {
    stopAllVideos = true;
    notifyListeners();
  }
}