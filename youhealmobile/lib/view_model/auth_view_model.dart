import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:youhealmobile/models/current_user.dart';

import 'package:youhealmobile/utils/enums.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/views/otp/otp.dart';
import 'package:youhealmobile/views/splash/splash.dart';
import '../components/response/handle_response_msg.dart';
import '../models/user_model.dart';
import '../utils/check_internet_connection.dart';
import '../views/auth/login.dart';
import '../views/home/home.dart';
class AuthViewModel with ChangeNotifier {
  AuthType authType = AuthType.login;
  bool isLoadingForAuth = false;

  final genders = {
    "Male": "m",
    "Female": "f",
    "ذكر": "m",
    "أنثى": "f"
  };


  final Map<String, dynamic> authenticateUserData = {
    'full_name': '',
    'phone': '',
    'password': '',
    'gender': null,
    'profile_img_url': 'image',
    'fcmToken': null
  };
  bool rememberMe = false;

  void changeAuthType(AuthType type) {
    authType = type;
    //notifyListeners();
  }

  Future authenticate(BuildContext context) async {
    print(authenticateUserData['gender']);
    if(authenticateUserData['gender'] == null && authType == AuthType.signup){
      HandleResponseMsg.showSnackBar(context: context, msg: 'pleaseSelectYourGender', statusCode: 400);
      return;
    }
    print(authenticateUserData['gender']);
    authenticateUserData['gender'] = genders[authenticateUserData['gender']];
    print(authenticateUserData['gender']);
    isLoadingForAuth = true;
    notifyListeners();

    //Auth request
    final bool remember = rememberMe;
    try {
      final response =
          await UserModel.authentication(authType, authenticateUserData)
              .timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      final responseData = json.decode(response.body);
      final prefrences = await SharedPreferences.getInstance();

      await prefrences.setBool("rememberMe", remember);
      // ignore: use_build_context_synchronously
      HandleResponseMsg.showSnackBar(
        context: context,
        msg: responseData['message'],
        statusCode: response.statusCode,
      );
      if (response.statusCode < 300 && authType == AuthType.signup) {
        // ignore: use_build_context_synchronously
        NavigationController.navigatorRoute(
          context: context,
          page: OTP(userId: responseData['userId']),
        );
        isLoadingForAuth = false;
        notifyListeners();
        return;
      }
      // ignore: use_build_context_synchronously

      if (response.statusCode == 200 && authType == AuthType.login) {
        _saveUserDataToLocalStorage(responseData);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const Home(),
            transitionDuration: const Duration(milliseconds: 1500),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
          (route) => false,
        );
      } else if (response.statusCode == 201 && authType == AuthType.login) {
        // ignore: use_build_context_synchronously
        NavigationController.navigatorRoute(
          context: context,
          page: OTP(userId: responseData['userId']),
        );
      }
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }

    isLoadingForAuth = false;
    notifyListeners();
  }

  Future resetPassword(
      {required String phone, required BuildContext context}) async {
        print(phone);
    isLoadingForAuth = true;
    notifyListeners();
    try {
      final response = await UserModel.resetPassword(phone: phone).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      if (response.statusCode < 400) {
        NavigationController.navigatorRoute(
          context: context,
          page: OTP(
            userId: 0,
            forgetPassword: true,
            phone: phone,
          ),
        );
      } else {
        InternetConnection.checkUserConnection(context: context);
      }
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    isLoadingForAuth = false;
    notifyListeners();
  }

  Future updatePassword(
      {required String phone,
      required String newPassword,
      required BuildContext context}) async {
    isLoadingForAuth = true;
    notifyListeners();
    try {
      final response =
          await UserModel.updatePssword(phone: phone, newPassword: newPassword)
              .timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      if (response.statusCode < 400) {
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: "passwordUpdatedSuccessfully",
          statusCode: 200,
        );
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Login(),
            transitionDuration: const Duration(milliseconds: 1500),
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
    isLoadingForAuth = false;
    notifyListeners();
  }

  Future logout(BuildContext context) async {
    final prefrences = await SharedPreferences.getInstance();
    prefrences.remove('youhealUser');
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Splash(),
        transitionDuration: const Duration(milliseconds: 1500),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
      (route) => false,
    );
  }

  Future _saveUserDataToLocalStorage(Map<String, dynamic> userData) async {
    final prefrences = await SharedPreferences.getInstance();
    prefrences.setString("youhealUser", json.encode(userData));
    CurrentUser.currentUser!.userData = userData;
  }
}
