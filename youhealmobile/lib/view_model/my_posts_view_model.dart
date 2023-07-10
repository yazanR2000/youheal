import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youhealmobile/models/community_model.dart';
import 'package:youhealmobile/view_model/community_view_model.dart';

import '../components/response/handle_response_msg.dart';
import '../models/current_user.dart';
import '../utils/check_internet_connection.dart';

class MyPostsViewModel with ChangeNotifier {
  final List<dynamic> myPosts = [];
  final Map<String,dynamic> postEdit = {
    "id": -1,
    "content": "",
    "uploads": []
  };
  bool isLoading = false;
  void _notify() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void enableEditOrDelete({required int postId}) {
    postEdit['id'] = postId;
    notifyListeners();
  }

  Future getMyPosts({required BuildContext context}) async {
    _notify();
     try {
      myPosts.clear();
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response =
          await CommunityModel.getMyPosts(page: 1,token: userToken)
              .timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            InternetConnection.checkUserConnection(context: context),
      );
      final data = json.decode(response.body);
      print(data);
      myPosts.addAll(data['posts']);
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
          await CommunityModel.getMyPosts(page: page,token: userToken);
      final data = json.decode(response.body);
      myPosts.addAll(data['posts']);
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
  Future deletePost(
      {required int postId, required BuildContext context}) async {
    _notify();
    try {
      final userToken = CurrentUser.currentUser!.userData!['access_token'];
      final response = await CommunityModel.deletePost(postId: postId, token: userToken);
      print(response);
      HandleResponseMsg.showSnackBar(
        context: context,
        msg: "postDeletedSuccessfully",
        statusCode: 200,
      );
      Provider.of<CommunityViewModel>(context, listen: false).deletePost(
        postId: postId,
      );
      myPosts.removeWhere((element) => element['id'] == postId);
    } catch (err) {
      print(err);
      InternetConnection.checkUserConnection(context: context);
    }
    _notify();
  }

  Future editPost() async {}
}
