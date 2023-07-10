import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/models/current_user.dart';
import 'package:youhealmobile/view_model/community_view_model.dart';

import '../utils/constants.dart';
import 'heroes/single_post.dart';

class Posts extends StatelessWidget {
  final List<dynamic> posts;
  final Function paginationFunction;
  Posts({super.key, required this.posts,required this.paginationFunction});

  final currentUser = CurrentUser.currentUser!.userData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SinglePost(
          profileImage: 'https://avatars.githubusercontent.com/u/1071625?v=4',
          post: posts[index],
          isMyPost: posts[index]['user']['id'] == currentUser!['userId'],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemCount: posts.length,
    );
  }
}
