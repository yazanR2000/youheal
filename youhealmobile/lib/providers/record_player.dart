import 'package:flutter/material.dart';

class RecordPlayer with ChangeNotifier {
  int playingId = -1;
  void stopRecords({required int id}) {
    playingId = id;
    notifyListeners();
  }
}