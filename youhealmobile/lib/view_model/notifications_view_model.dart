import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youhealmobile/models/notifications_model.dart';
import 'package:youhealmobile/utils/check_internet_connection.dart';

import '../models/current_user.dart';

class NotificationsViewModel with ChangeNotifier {
  final List<dynamic> notifications = [];

  bool isLoading = false;

  void _notify(){
    isLoading = !isLoading;
    notifyListeners();
  }


  Future getNotificationByUserId({required BuildContext context}) async {
    _notify();
    try{
      notifications.clear();
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response = await NotificationsModel.getNotificationByUserId(token: userToken, page: 1);
      final responseData = json.decode(response.body);
      print(responseData);
      notifications.addAll(responseData['notifications']);
    }catch(err){
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future getNewNotificationsPostsByPagination({required int page}) async {
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response =
          await NotificationsModel.getNotificationByUserId(page: page,token: userToken);
      final data = json.decode(response.body);
      notifications.addAll(data['notifications']);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}