import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youhealmobile/utils/app_colors.dart';

class HandleResponseMsg {
  static void showSnackBar({
    required BuildContext context,
    required String msg,
    required int statusCode,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          tr(msg),
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _getSnackBarBackgroundColor(statusCode),
      ),
    );
  }

  static showMaterialBanner({
    required BuildContext context,
    required String msg,
    required int statusCode,
  }) {
    Timer(Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        // duration: const Duration(seconds: 2),
        leading: Icon(Icons.warning,color: AppColors.warning,),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: Text(
              tr('ok'),
            ),
          ),
        ],
        content: Text(
          tr(msg),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: _getSnackBarBackgroundColor(statusCode),
      ),
    );
  }

  static Color _getSnackBarBackgroundColor(int statusCode) {
    if (statusCode < 300) {
      return const Color(0xff23B89A);
    } else if (statusCode == 500) {
      return const Color(0xffD72535);
    }
    return const Color(0xffED1C24);
  }
}
