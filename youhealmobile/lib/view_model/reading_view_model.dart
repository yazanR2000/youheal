import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/view_model/medicla_history_view_model.dart';

import '../components/response/handle_response_msg.dart';
import '../models/reading_model.dart';
import '../utils/check_internet_connection.dart';
import 'package:provider/provider.dart';
class ReadingViewModel with ChangeNotifier {
  Map<String, dynamic> reading = {'reading': null, 'readingType': null};

  bool showWarning = false;

  String warningText = '';

  bool isLoading = false;
  void _notifyLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void _notifyWarning() {
    showWarning = !showWarning;
    notifyListeners();
    // showWarning = !showWarning;
  }

  Future addNewReading(BuildContext context) async {
    try {
      bool warningReading = false;
      if (reading['reading'] <= 59 || reading['reading'] >= 180) {
        warningReading = !warningReading;
        showWarning = false;
        warningText = reading['reading'] <= 59 ? 'lowSugar' : 'highSugar';
        _notifyWarning();
      }else{
        showWarning = false;
        notifyListeners();
      }
      _notifyLoading();
      final preferences = await SharedPreferences.getInstance();
      final user = json.decode(preferences.getString('youhealUser')!);
      final response = await ReadingModel.addNewReading(
        reading: reading['reading'],
        readingType: getReadingId(reading: reading['readingType']),
        token: user['access_token'],
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      if (!warningReading) {
        // ignore: use_build_context_synchronously
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: 'newReadingAdded',
          statusCode: response.statusCode,
        );
        warningReading = !warningReading;
      }
      
      reading['reading'] = null;
      reading['readingType'] = null;
      _notifyLoading();
      Provider.of<MedicalHistoryViewModel>(context,listen: false).getMedicalHistory(context);
    } catch (err) {
      _notifyLoading();
      InternetConnection.checkUserConnection(context: context);
    }
  }

  void _showWarning({required BuildContext context}) {
    String warningContent = reading['reading'] <= 59 ? 'lowSugar' : 'highSugar';
    HandleResponseMsg.showMaterialBanner(
      context: context,
      msg: warningContent,
      statusCode: 400,
    );
  }

  String getReadingId({required String reading}) {
    Map<String, String> readingTypes = {
      tr("Random reading"): "0",
      tr("Fasting blood sugar (at least 8 hours)"): "1",
      tr("Tow hours after meals"): "2",
      tr("Before the meal"): "3",
      tr("Before exercise"): "4",
      tr("At bedtime"): "5",
      tr("After exercise"): "6"
    };
    return readingTypes[reading]!;
  }
}
