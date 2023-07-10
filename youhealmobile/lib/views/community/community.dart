import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/posts.dart';
import 'package:youhealmobile/components/screen_header_box.dart';
import 'package:youhealmobile/components/spinkit.dart';
import 'package:youhealmobile/utils/add_post_comment_enum.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/constants.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/view_model/community_view_model.dart';

import '../../components/add_post_or_comment/add_post_or_comment.dart';
import '../../components/custom_scaffold.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.only(top: screenSize.height * 0.14),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Posts(),
            CommunityPosts(),
            AddPostOrComment(value: PostOrComment.post),
          ],
        ),
      ),
    );
  }
}

class CommunityPosts extends StatefulWidget {
  const CommunityPosts({super.key});

  @override
  State<CommunityPosts> createState() => _CommunityPostsState();
}

class _CommunityPostsState extends State<CommunityPosts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CommunityViewModel>(context, listen: false)
          .getCommunityPosts(page: 1, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Expanded(
      child: Consumer<CommunityViewModel>(
        builder: (context, viewModel, _) => viewModel.isLoading
            ? Center(
                child: Spinkit.spinKit(),
              )
            : NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge) {
                    bool isTop = metrics.pixels == 0;
                    if (isTop) {
                      // print('At the top');
                    } else {
                      final postsLength = viewModel.posts.length;
                      if (postsLength % Constants.paginationLimit == 0) {
                        viewModel.getNewPostsByPagination(
                          page: (viewModel.posts.length /
                                      Constants.paginationLimit)
                                  .ceil() +
                              1,
                        );
                      }
                    }
                  }
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<CommunityViewModel>(context,
                            listen: false)
                        .getCommunityPosts(page: 1, context: context);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.06,
                            
                          ),
                          child: ScreenHeaderBox(
                            imagePath: Resources.communityIcon,
                            color: AppColors.primaryColor,
                            icon: Icons.abc,
                            title: tr('community'),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Posts(
                            posts: viewModel.posts,
                            paginationFunction: () async {
                              await viewModel.getNewPostsByPagination(
                                page: (viewModel.posts.length /
                                            Constants.paginationLimit)
                                        .ceil() +
                                    1,
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
