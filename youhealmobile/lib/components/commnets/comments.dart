import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/models/current_user.dart';
import 'package:youhealmobile/view_model/post_comments_view_model.dart';

import '../../utils/constants.dart';
import 'comment.dart';

class Comments extends StatelessWidget {
  final int postId;
  final List<dynamic> comments;
  final Function paginationFunction;
  Comments(
      {super.key,
      required this.comments,
      required this.paginationFunction,
      required this.postId});

  final currentUser = CurrentUser.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          bool isTop = metrics.pixels == 0;
          if (isTop) {
            // print('At the top');
          } else {
            final commentsLength = comments.length;
            if (commentsLength % Constants.paginationLimit == 0) {
              paginationFunction();
            }
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<PostCommentsViewModel>(context, listen: false)
              .getCommentsByPostId(
            postId: postId,
            context: context,
          );
        },
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(
            10,
            screenSize.height * 0.15,
            10,
            10,
          ),
          itemBuilder: (context, index) => Row(
            mainAxisAlignment: comments[index]['user']['id'].toString() ==
                    currentUser!.userData!['userId'].toString()
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Comment(
                isMe: comments[index]['user']['id'].toString() ==
                    currentUser!.userData!['userId'].toString(),
                screenWidth: screenSize.width,
                comment: comments[index],
              ),
            ],
          ),
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: comments.length,
        ),
      ),
    );
  }
}
