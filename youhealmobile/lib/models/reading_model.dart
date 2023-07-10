import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ReadingModel {
  static String readingUrl = Constants.baseUrl;
  static Future addNewReading({
    required int reading,
    required String readingType,
    required String token,
  }) async {
    return http.post(
      Uri.parse('$readingUrl/reading/add'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
      body: json.encode({"value": reading, "type": readingType}),
    );
  }

  static Future getMedicalHistory({required String token,int page = 1}) async {
    print(token);
    final uri = Uri.parse("${Constants.baseUrl}/reading?page=$page");
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }
}
