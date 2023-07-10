import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/components/response/handle_response_msg.dart';
import 'package:youhealmobile/models/plan_model.dart';

import '../models/current_user.dart';
import '../utils/check_internet_connection.dart';
import '../utils/navigator.dart';
import '../views/calculate_carb/plan_screen/plan.dart';

class CarbViewModel with ChangeNotifier {
  Map<String, dynamic> plan = {};
  List<dynamic> nutritionData = [];

  bool isLoading = true;
  void notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  final Map<String, dynamic> personData = {
    'gender': null,
    'age': 0,
    'height': 0.0,
    'weight': 0.0,
    'type': null,
    'values': {
      'Sedentary (little or no exercise)': 1.2,
      'Lightly active (light exercise/sports 1-3 days/week)': 1.375,
      'Moderately active (moderate exercise/sports 3-5 days/week)': 1.55,
      'Very active (hard exercise/sports 6-7 days a week)': 1.725,
      'If you are extra active (very hard exercise/sports & a physical job)':
          1.9,
      //arabic
      "المستقرة (القليل من التمارين أو بدونها)": 1.2,
      "نشط قليلاً (تمارين خفيفة / رياضات 1-3 أيام / أسبوع)": 1.375,
      "نشط بشكل معتدل (تمرين معتدل / رياضة 3-5 أيام / أسبوع)": 1.55,
      "نشط للغاية (تمارين شاقة / رياضة 6-7 أيام في الأسبوع)": 1.725,
      "إذا كنت نشيطًا جدًا (تمرين شاق جدًا / رياضة ووظيفة بدنية)": 1.9
    },

    //     "Sedentary (little or no exercise)": "المستقرة (القليل من التمارين أو بدونها)",
    // "Lightly active (light exercise/sports 1-3 days/week)": "نشط قليلاً (تمارين خفيفة / رياضات 1-3 أيام / أسبوع)",
    // "Moderately active (moderate exercise/sports 3-5 days/week)" : "نشط بشكل معتدل (تمرين معتدل / رياضة 3-5 أيام / أسبوع)",
    // "Very active (hard exercise/sports 6-7 days a week)": "نشط للغاية (تمارين شاقة / رياضة 6-7 أيام في الأسبوع)",
    // "If you are extra active (very hard exercise/sports & a physical job)": "إذا كنت نشيطًا جدًا (تمرين شاق جدًا / رياضة ووظيفة بدنية)",
  };

  final Map<String, dynamic> personDataNeed = {
    'calorie': 0.0,
    'protein': '',
    'carbohydrate': 0.0,
    'fat': 0.0
  };
  final genders = {"Male": "m", "Female": "f", "ذكر": "m", "انثى": "f"};

  void calculatePersonDataNeed({required BuildContext context}) {
    // For Men  BMR = 66.5 + (13.75 × weight in kg) + (5
    //.003 × height in cm) - (6.75 × age)
    // For Women  BMR = 655.1 + (9.563 × weight in kg) + (1.850 × height in cm) - (4.676 × age)
    if (personData['gender'] == null) {
      HandleResponseMsg.showSnackBar(
        context: context,
        msg: 'pleaseSelectYourGender',
        statusCode: 400,
      );
      return;
    }

    double bmr = 0;
    if (personData['gender'] == 'm') {
      bmr = (10 * personData['weight']) +
          (6.25 * personData['height']) -
          (5 * personData['age']) +
          5;
    } else {
      bmr = (10 * personData['weight']) +
          (6.25 * personData['height']) -
          (5 * personData['age']) -
          161;
    }
    //Calculate the adjusted BMR
    final type = personData['type'];
    personDataNeed['calorie'] = bmr * personData['values'][type];

    //carbs need
    _calculateBasedOnType(minRange: 0.45, maxRange: 0.65, type: 'carbohydrate');
    //proteins need
    _calculateBasedOnType(minRange: 0.1, maxRange: 0.35, type: 'protein');
    //fats need
    _calculateBasedOnType(minRange: 0.2, maxRange: 0.35, type: 'fat');

    print(personDataNeed);
  }

  void _calculateBasedOnType(
      {required String type,
      required double minRange,
      required double maxRange}) {
    Map<String, dynamic> minAndMaxCarbs = {'min': '', 'max': ''};
    minAndMaxCarbs['min'] =
        (personDataNeed['calorie']! * minRange / 4).toStringAsFixed(2);
    minAndMaxCarbs['max'] =
        (personDataNeed['calorie']! * maxRange / 4).toStringAsFixed(2);
    personDataNeed[type] =
        '${minAndMaxCarbs['min']} - ${minAndMaxCarbs['max']}';
  }

  Future getPlan({required BuildContext context}) async {
    nutritionData.clear();
    plan.clear();
    notify();
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      print(userToken);
      double calories = 0;
      if (personDataNeed['calorie'] < 1000) {
        calories = 1000;
      } else if (personDataNeed['calorie'] > 3000) {
        calories = 3000;
      } else {
        calories = personDataNeed['calorie'];
      }
      final lang = EasyLocalization.of(context)!.currentLocale ==
              const Locale('ar', 'EG')
          ? 'ar'
          : 'en';
      // print(lang);
      final response = await PlanModel.getPlan(
        token: userToken,
        calories: calories,
        lang: lang,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      final responseData = json.decode(response.body);
      // print(responseData);
      final data = responseData['meals'] as List<dynamic>;

      nutritionData = responseData['nutritionData'] as List<dynamic>;

      // print(nutritionData);
      _fixPlanData(data: data);
      // ignore: use_build_context_synchronously
      NavigationController.navigatorRoute(
        context: context,
        page: const Plan(),
      );
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    notify();
  }

  void _fixPlanData({required List<dynamic> data}) {
    for (var element in data) {
      final keys = element.keys.toList();
      final List<Map<String, dynamic>> dayRecords = [];
      for (int i = keys.length - 1; i >= 0; i--) {
        final key = keys[i];
        if (!key.contains("Day")) {
          final Map<String, dynamic> record = {
            key: element[key],
          };
          dayRecords.add(record);
        } else {
          final days = element[key].toString().split('&');
          if (days.length > 1) {
            element['Days'] = days[0];
            for (int i = 1; i < days.length; i++) {
              final Map<String, dynamic> newDay = {};
              newDay.addAll(element);
              newDay['Days'] = 'Day ${days[i]}';
              plan.putIfAbsent(
                  newDay['Days'], () => dayRecords.reversed.toList());
            }
          }
        }
      }
      plan.putIfAbsent(element['Days'], () => dayRecords.reversed.toList());
    }
    
    plan = Map.fromEntries(
      plan.entries.toList()
        ..sort(
          (e1, e2) {
            int num1 = int.parse(e1.key.split(" ")[1]);
            int num2 = int.parse(e2.key.split(" ")[1]);
            if (num1 < num2) {
              return -1;
            } else if (num1 > num2) {
              return 1;
            } else {
              return 0;
            }
          },
        ),
    );
  }

  Future setLastPlan() async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setString('lastPlan', json.encode(plan));
    notifyListeners();
  }

  Future getLastPlan() async {
    final prefrences = await SharedPreferences.getInstance();
    if (prefrences.containsKey('lastPlan')) {
      plan = json.decode(prefrences.getString('lastPlan')!);
      nutritionData = json.decode(prefrences.getString('nutritionData')!);
      notifyListeners();
    }
  }
}
