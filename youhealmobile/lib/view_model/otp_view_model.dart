import 'package:flutter/material.dart';

import 'package:youhealmobile/models/otp_model.dart';
import 'package:youhealmobile/utils/check_internet_connection.dart';
import 'package:youhealmobile/views/auth/login.dart';

import 'package:youhealmobile/views/new_password/new_password.dart';

import '../components/response/handle_response_msg.dart';


class OTPViewModel with ChangeNotifier {
  bool isLoading = false;
  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future verifyAccount(
      {required int userId,
      required String code,
      required BuildContext context}) async {
    _notify();
    try {
      final response =
          await OTPModel.verifyOTP(userId: userId, code: code).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      if (response.statusCode >= 400) {
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: "wrongOTP",
          statusCode: response.statusCode,
        );
      } else {
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: "accountVerifiedSuccessfully",
          statusCode: response.statusCode,
        );
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
          (route) => false,
        );
      }
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future verifyResetPassword(
      {required String phone, required String otp,required BuildContext context}) async {
    _notify();
    try {
      final response =
          await OTPModel.verifyResetPassword(phone: phone, otp: otp).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      if (response.statusCode >= 400) {
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: "wrongOTP",
          statusCode: response.statusCode,
        );
      }else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => NewPassword(phone: phone),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      }
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }
}
