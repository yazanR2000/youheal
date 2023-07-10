import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youhealmobile/utils/constants.dart';
class OTPModel {
  static Future verifyOTP({required int userId,required String code}) async {
    final url = Uri.parse("${Constants.baseUrl}/auth/verify/$userId/$code");
    return await http.post(url);
  }
  static Future verifyResetPassword({required String phone,required String otp}) async {
    phone = "+962$phone";
    final url = Uri.parse("${Constants.baseUrl}/auth/resetPassword/verify");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "phone":phone,
          "otp": otp
        },
      ),
    );
  }
}