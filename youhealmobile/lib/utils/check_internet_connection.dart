import 'dart:io';


import 'package:flutter/material.dart';


import '../components/response/handle_response_msg.dart';

class InternetConnection{
  static Future checkUserConnection({required BuildContext context}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        HandleResponseMsg.showSnackBar(context: context, msg: 'somthingWentWrong', statusCode: 400);
      }
    } on SocketException catch (_) {
      HandleResponseMsg.showSnackBar(context: context, msg: 'internetConnection', statusCode: 400);
    }
  }
}