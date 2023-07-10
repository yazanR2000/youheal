import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youhealmobile/models/current_user.dart';
import 'package:youhealmobile/models/reading_model.dart';

import '../utils/check_internet_connection.dart';

class MedicalHistoryViewModel with ChangeNotifier {
  List<dynamic> readings = [];
  bool isLoading = false;

  void notifyAll(){
    notifyListeners();
  }
  _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future getMedicalHistory(BuildContext context) async {
    _notify();
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];

      final response =
          await ReadingModel.getMedicalHistory(token: userToken).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      readings = json.decode(response.body);
      print(readings);
      // print(json.decode(response.body));
    } catch (err) {
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Map<String, List<Map<String, String>>> filterRecordsBaedOnDay() {
    final records = readings;
    print(records);
    Map<String, List<Map<String, String>>> readingsArch = {};

    for (var element in records) {
      final key = DateTime.parse(element['updatedAt'].toString())
          .toLocal()
          .toString()
          .split(' ');
      print(key);
      final time = key[1].split('.')[0];

      if (readingsArch.containsKey(key[0])) {
        readingsArch[key[0]]!.add(
          {
            "${_getReadingId(reading: element['type'].toString())} | $time":
                element['value'].toString(),
          },
        );
      } else {
        readingsArch.putIfAbsent(
          key[0],
          () => [
            {
              "${_getReadingId(reading: element['type'].toString())} | $time":
                  element['value'].toString(),
            },
          ],
        );
      }
    }
    return readingsArch;
  }

  String _getReadingId({required String reading}) {
    Map<String, String> readingTypes = {
      "0": tr("Random reading"),
      "1": tr("Fasting blood sugar (at least 8 hours)"),
      "2": tr("Tow hours after meals"),
      "3": tr("Before the meal"),
      "4": tr("Before exercise"),
      "5": tr("At bedtime"),
      "6": tr("After exercise")
    };
    return readingTypes[reading]!;
  }
}
