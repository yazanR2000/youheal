import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/community_model.dart';
import '../models/current_user.dart';
import '../utils/check_internet_connection.dart';

class CommunityViewModel with ChangeNotifier {
  bool isLoading = false;

  final List<dynamic> posts = [];

  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future getCommunityPosts(
      {required int page, required BuildContext context}) async {
    _notify();
    try {
      posts.clear();
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response =
          await CommunityModel.getCommunityPosts(token: userToken, page: page)
              .timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      final data = json.decode(response.body);
      posts.addAll(data['posts']);
      // print(json.decode(response.body));
    } catch (err) {
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future getNewPostsByPagination({required int page}) async {
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response =
          await CommunityModel.getCommunityPosts(token: userToken, page: page);
      final data = json.decode(response.body);
      posts.addAll(data['posts']);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  void deletePost({required int postId}) {
    int index = posts.indexWhere((element) => element['id'] == postId);
    if (index != -1) {
      posts.removeAt(index);
      notifyListeners();
    }
  }
  void addNewPost({required Map<String,dynamic> post}) {
    posts.insert(0,post);
    print("postAdded");
    notifyListeners();
  }
}
