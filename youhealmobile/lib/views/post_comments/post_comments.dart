import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/components/spinkit.dart';
import 'package:youhealmobile/utils/add_post_comment_enum.dart';
import 'package:youhealmobile/view_model/post_comments_view_model.dart';
import '../../components/add_post_or_comment/add_post_or_comment.dart';
import '../../components/commnets/comments.dart';
import '../../utils/constants.dart';

class PostComments extends StatefulWidget {
  final int postId;
  const PostComments({super.key, required this.postId});

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PostCommentsViewModel>(context, listen: false)
          .getCommentsByPostId(
        postId: widget.postId,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Consumer<PostCommentsViewModel>(
        builder: (context, viewModel, _) => viewModel.isLoading
            ? Center(
                child: Spinkit.spinKit(),
              )
            : Column(
                children: [
                  Expanded(
                    child: Comments(
                        postId: widget.postId,
                        comments: viewModel.comments,
                        paginationFunction: () async {
                          await viewModel.getCommentsByPagination(
                            page: (viewModel.comments.length /
                                        Constants.paginationLimit)
                                    .ceil() +
                                1,
                            context: context,
                            postId: widget.postId,
                          );
                        }),
                  ),
                  AddPostOrComment(
                    value: PostOrComment.comment,
                    postId: widget.postId,
                  ),
                ],
              ),
      ),
    );
  }
}
