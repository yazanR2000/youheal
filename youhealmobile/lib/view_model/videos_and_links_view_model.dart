import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youhealmobile/models/videos_and_links_model.dart';
import 'package:youhealmobile/utils/check_internet_connection.dart';

import '../models/current_user.dart';

enum VideosOrLinks { videos, links }

class VideosAndLinksViewModel with ChangeNotifier {
  final List<dynamic> data = [];

  bool isLoading = false;
  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future getAllVideosOrLinks(
      {required BuildContext context, required VideosOrLinks type}) async {
    _notify();
    try {

      data.clear();
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response = type == VideosOrLinks.links
          ? await VideosAndLinksModel.getAllLinks(page: 1,token: userToken)
          : await VideosAndLinksModel.getAllVideos(page: 1,token: userToken);
      final responseData = json.decode(response.body);
      print(responseData);
      data.addAll(responseData);
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future getVideosOrLinksByPagination(
      {required int page, required VideosOrLinks type}) async {
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response = type == VideosOrLinks.links
          ? await VideosAndLinksModel.getAllLinks(page: page,token: userToken)
          : await VideosAndLinksModel.getAllVideos(page: page,token: userToken);
      final data = json.decode(response.body);
      data.addAll(data['posts']);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}
