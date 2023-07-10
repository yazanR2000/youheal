import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/add_post_or_comment/widgets/files_view.dart';

import 'package:youhealmobile/components/record_timer.dart';
import 'package:youhealmobile/providers/add_post_or_comment_to_cummunity.dart';
import 'package:youhealmobile/utils/add_post_comment_enum.dart';
import 'package:youhealmobile/utils/app_colors.dart';

import '../players/custom_video_player.dart';


class AddPostOrComment extends StatefulWidget {
  final PostOrComment value;
  final int? postId;
  const AddPostOrComment({super.key, required this.value, this.postId});

  @override
  State<AddPostOrComment> createState() => _AddPostOrCommentState();
}

class _AddPostOrCommentState extends State<AddPostOrComment> {
  final TextEditingController _controller = TextEditingController();

  IconData _postIconBasedOnCurrentLang() {
    if (context.locale == const Locale('en', 'US')) {
      return Icons.arrow_circle_right;
    }
    return Icons.arrow_circle_left;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<AddPostOrCommentToCommunity>(context, listen: false)
          .recorder
          .init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final addPostOrCommentProvider = Provider.of<AddPostOrCommentToCommunity>(context,listen: false);
    return Container(
      color: Colors.white.withOpacity(0.65),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          FilesView(files: addPostOrCommentProvider.uploads['attaches'], type: 'attaches'),
          FilesView(files: addPostOrCommentProvider.uploads['records'], type: 'records'),
          
          const SizedBox(
            height: 5,
          ),
          Consumer<AddPostOrCommentToCommunity>(
            builder: (context, provider, _) => provider.isRecording
                ? const RecordTimer()
                : Row(
                    children: [
                      Badge(
                        label: Text(
                          provider.uploads['attaches']!.isEmpty
                              ? ""
                              : "${provider.uploads['attaches']!.length}",
                        ),
                        backgroundColor: provider.uploads['attaches']!.isEmpty
                            ? Colors.transparent
                            : Colors.red,
                        child: InkWell(
                          onLongPress: () {},
                          onTap: () async {
                            await provider.uploadFile(
                              fileType: FileType.attach,
                              context: context,
                            );
                          },
                          child: Icon(
                            Icons.attach_file,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Badge(
                        label: Text(
                          provider.uploads['records']!.isEmpty
                              ? ""
                              : "${provider.uploads['records']!.length}",
                        ),
                        backgroundColor: provider.uploads['records']!.isEmpty
                            ? Colors.transparent
                            : Colors.red,
                        child: InkWell(
                          // onLongPress: () {},
                          onTap: () async {
                            await provider.uploadFile(
                              fileType: FileType.record,
                              context: context,
                            );
                          },
                          child: Icon(
                            Icons.keyboard_voice_rounded,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: _controller,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffE4E9F2).withOpacity(0.3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            suffixIcon: Consumer<AddPostOrCommentToCommunity>(
                              builder: (context, provider, _) => IconButton(
                                color: AppColors.primaryColor,
                                onPressed: provider.isLoading
                                    ? null
                                    : () async {
                                        final String path = widget.value ==
                                                PostOrComment.post
                                            ? '/post/add'
                                            : '/comment/add/${widget.postId}';
                                        await provider.addNewPostOrComment(
                                          context: context,
                                          content: _controller.text,
                                          path: path,
                                        );
                                        _controller.clear();
                                      },
                                icon: Icon(_postIconBasedOnCurrentLang()),
                              ),
                            ),
                            hintText: tr(widget.postId == null
                                ? "descriptionPlaceholder"
                                : "addComment"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xffE4E9F2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
