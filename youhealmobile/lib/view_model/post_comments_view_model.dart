import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youhealmobile/models/community_model.dart';

import '../models/current_user.dart';
import '../utils/check_internet_connection.dart';

class PostCommentsViewModel with ChangeNotifier {
  final List<dynamic> comments = [];
  bool isLoading = false;
  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future getCommentsByPostId(
      {required int postId, required BuildContext context}) async {
    _notify();
    try {
      comments.clear();
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response = await CommunityModel.getCommentsByPostId(
          postId: postId, page: 1, token: userToken);
      final data = json.decode(response.body);
      // print(data);
      comments.addAll(data['comments']);
      print(comments.length);
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future getCommentsByPagination(
      {required int postId,
      required BuildContext context,
      required int page}) async {
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response = await CommunityModel.getCommentsByPostId(
          postId: postId, page: page, token: userToken);
      final data = json.decode(response.body);
      comments.addAll(data['comments']);
      notifyListeners();
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
  }

  void addNewComment({required Map<String, dynamic> comment}) {
    comments.add(comment);
    notifyListeners();
  }
}
