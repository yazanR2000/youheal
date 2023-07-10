import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/my_posts_view_model.dart';

import '../../models/current_user.dart';
import '../../providers/add_post_or_comment_to_cummunity.dart';
import '../../utils/resources.dart';
import '../../views/post_comments/post_comments.dart';
import '../costum_page_views/custom_page_view_for_post_files.dart';
import '../custom_list_view_for_audios.dart';

enum UrlType { mp4, aac, image }

class SinglePost extends StatelessWidget {
  final String profileImage;
  final Map<String, dynamic> post;
  final bool isMyPost;

   SinglePost({
    super.key,
    required this.post,
    required this.profileImage,
    this.isMyPost = false,
  });

  List<dynamic> _getFilesBasedOnType({required bool audio}) {
    print(audio);
    List<dynamic> files = [];
    List<dynamic> postFiles = post['uploads'];
    print(postFiles);
    for (var url in postFiles) {
      print(url);
      if (audio) {
        if (url['url'].contains("aac")) {
          files.add(url);
        }
      } else {
        if (!url['url'].contains("aac")) {
          files.add(url);
        }
      }
    }
    print(files);
    return files;
  }

  final currentUser = CurrentUser.currentUser;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "postEdit${post['id']}",
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            if (isMyPost)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // OutlinedButton.icon(
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 15,
                  //       vertical: 10,
                  //     ),
                  //     backgroundColor: AppColors.primaryColor,
                  //   ),
                  //   onPressed: () {
                  //     NavigationController.navigatorRoute(
                  //       context: context,
                  //       page: EditPost(post: this),
                  //     );
                  //   },
                  //   icon: const Icon(
                  //     Icons.edit,
                  //     color: Colors.white,
                  //   ),
                  //   label: Text(
                  //     tr("edit"),
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  // const SizedBox(width: 5,),
                  // OutlinedButton.icon(
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 15,
                  //       vertical: 10,
                  //     ),
                  //   ),
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => DeleteDialog(postId: post['id']),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.delete),
                  //   label: Text(
                  //     tr("delete"),
                  //   ),
                  // ),
                  PopupMenuButton<dynamic>(
                    // Callback that sets the selected popup menu item.
                    onSelected: (item) {
                      // setState(() {
                      //   selectedMenu = item;
                      // });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<dynamic>>[
                      PopupMenuItem<dynamic>(
                        value: 1,
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) =>
                          //       DeleteDialog(postId: post['id']),
                          // );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(tr("edit")),
                          ],
                        ),
                      ),
                      PopupMenuItem<dynamic>(
                        value: 1,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                DeleteDialog(postId: post['id']),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.delete),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(tr("delete")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  // 'https://avatars.githubusercontent.com/u/1071625?v=4',
                  backgroundImage: AssetImage(
                    currentUser!.userData!['gender'] == 'f'
                        ? Resources.female
                        : Resources.male,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['user']['full_name'],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xffECECEC),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (post['content'] != '')
                              Text(
                                // 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                post['content'],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (post['content'] != '')
                              const SizedBox(
                                height: 10,
                              ),
                            if (post['uploads'].length != 0)
                              CustomPageViewForPostFiles(
                                files: _getFilesBasedOnType(audio: false),
                              ),
                            if (post['uploads'].length != 0)
                              CustomListViewForAudios(
                                urls: _getFilesBasedOnType(audio: true),
                              ),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      Row(
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 15),
                            ),
                            onPressed: () {
                              Provider.of<AddPostOrCommentToCommunity>(context,
                                      listen: false)
                                  .clearUploads();
                              NavigationController.navigatorRoute(
                                context: context,
                                page: PostComments(postId: post['id']),
                              );
                            },
                            child: Text(
                                "${tr('showComments')} (${post['comments'].length})"),
                            // child: Text(tr('showComments')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final int postId;
  const DeleteDialog({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(tr("deletePost")),
      content: Text(tr("areYouSureToDeletePost")),
      actions: [
        TextButton(
          onPressed: () async {
            await Provider.of<MyPostsViewModel>(context, listen: false)
                .deletePost(postId: postId, context: context);
            Navigator.of(context).pop();
          },
          child: Text(
            tr("yes"),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            tr("no"),
          ),
        ),
      ],
    );
  }
}
