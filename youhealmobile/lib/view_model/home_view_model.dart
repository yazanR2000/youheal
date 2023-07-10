import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/models/home_model.dart';

import '../models/current_user.dart';
import '../utils/check_internet_connection.dart';

class HomeViewModel with ChangeNotifier {
  Map<String,dynamic>? homeData;
  bool isLoading = false;
  Map<String, List<Map<String, String>>>? lastPlan;
  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future getLastPlan() async {
    final prefrences = await SharedPreferences.getInstance();
    if(prefrences.containsKey('lastPlan')){
      lastPlan = json.decode(prefrences.getString('lastPlan')!) as Map<String, List<Map<String, String>>>;
    }
  }

  Future getHomeData({required BuildContext context}) async {
    _notify();
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response =
          await HomeModel.getHomeData(token: userToken)
              .timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      homeData = json.decode(response.body);
      print(homeData);
      // print(json.decode(response.body));
    } catch (err) {
      print("====================");
      print(err);
      print("====================");
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }
}
