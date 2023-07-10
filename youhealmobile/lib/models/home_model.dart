import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class HomeModel {
  static Future getHomeData({required String token}) async {
    final uri = Uri.parse("${Constants.baseUrl}/home/");
    return await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json"
      },
    );
  }
}