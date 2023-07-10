import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/view_model/community_view_model.dart';

import 'package:youhealmobile/view_model/my_posts_view_model.dart';

import '../../components/custom_scaffold.dart';
import '../../components/spinkit.dart';
import '../../components/heroes/single_post.dart';
import '../../utils/constants.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyPostsViewModel>(context, listen: false)
          .getMyPosts(context: context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: Consumer<MyPostsViewModel>(
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
                      final postsLength = viewModel.myPosts.length;
                      if (postsLength % Constants.paginationLimit == 0) {
                        viewModel.getNewPostsByPagination(
                          page: (viewModel.myPosts.length /
                                      Constants.paginationLimit)
                                  .ceil() +
                              1,
                        );
                      }
                    }
                  }
                  return true;
                },
                child: ListView.separated(
                  padding:
                      EdgeInsets.fromLTRB(20, screenSize.height * 0.15, 20, 20),
                  itemBuilder: (context, index) {
                    return SinglePost(
                      profileImage:
                          'https://avatars.githubusercontent.com/u/1071625?v=4',
                      post: viewModel.myPosts[index],
                      isMyPost: true,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 30,
                  ),
                  itemCount: viewModel.myPosts.length,
                ),
              ),
      ),
    );
  }
}
