import 'package:flutter/material.dart';
import 'package:youhealmobile/utils/app_colors.dart';

import '../costum_page_views/custom_page_view_for_post_files.dart';
import '../custom_list_view_for_audios.dart';


class Comment extends StatelessWidget {
  final bool isMe;
  final double screenWidth;
  final Map<String, dynamic> comment;
  const Comment({
    super.key,
    required this.isMe,
    required this.screenWidth,
    required this.comment,
  });

  bool isImage({required String url}) {
    return !url.contains("mp4");
  }

  String getCommentTime() {
    final date = DateTime.parse(comment['createdAt']);
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute < 10 ? "0${date.minute}" : date.minute}";
  }

  List<dynamic> _getFilesBasedOnType({required bool audio}) {
    print(audio);
    List<dynamic> files = [];
    List<dynamic> postFiles = comment['uploadComments'];
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
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment['user']['full_name'],
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Container(
          constraints: comment['uploadComments'].length == 0
              ? null
              : BoxConstraints(maxWidth: screenWidth * 0.8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color:
                isMe ? const Color(0xff29AC98).withOpacity(0.35) : AppColors.commentContainerColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                child: Text(
                  comment['content'],
                  style: TextStyle(color: isMe ? Colors.black : Colors.black),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (comment['uploadComments'].length != 0)
                CustomPageViewForPostFiles(
                  files: _getFilesBasedOnType(audio: false),
                  isMe: isMe,
                ),
              if (comment['uploadComments'].length != 0)
                CustomListViewForAudios(
                  urls: _getFilesBasedOnType(audio: true),
                  // isMe: isMe,
                ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  getCommentTime(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
