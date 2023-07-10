import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:youhealmobile/utils/constants.dart';
import 'package:youhealmobile/utils/enums.dart';

import 'package:http/http.dart' as http;

class UserModel {
  static Future authentication(
    AuthType type,
    Map<String, dynamic> userData,
  ) async {
    userData['phone'] = "+962${userData['phone']}";
    String authUrl = Constants.baseUrl;
    authUrl += type == AuthType.login ? '/auth/login' : '/auth/sign-up';
    // userData['remember'] = userData['remember'].toString();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    userData['fcmToken'] = fcmToken;
    print(authUrl);
    print(userData);

    return await http.post(
      Uri.parse(authUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(userData),
    );
  }

  static Future resetPassword({required String phone}) async {
    phone = "+962$phone";
    final data = json.encode({"phone": phone});
    final url = Uri.parse("${Constants.baseUrl}/auth/resetPassword");
    return await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
  }

  static Future updatePssword(
      {required String phone, required String newPassword}) async {
    phone = "+962$phone";
    final url = Uri.parse("${Constants.baseUrl}/auth/newPassword");
    return await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {"phone": phone, "newPassword": newPassword},
      ),
    );
  }
}
