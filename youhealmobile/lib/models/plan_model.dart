import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class PlanModel {
  static Future getPlan({required double calories,required String token,required String lang}) async {
    final uri = Uri.parse("${Constants.baseUrl}/plan?lang=$lang");
    print(lang);
    return await http.post(
      uri,
      body: json.encode({
        'calories': calories.toString()
      }),
       headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }
}
