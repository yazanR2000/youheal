import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/utils/app_colors.dart';

import '../../../providers/add_post_or_comment_to_cummunity.dart';
import '../../players/custom_video_player.dart';

class FilesView extends StatelessWidget {
  final List<dynamic> files;
  final String type;
  const FilesView({super.key, required this.files, required this.type});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Consumer<AddPostOrCommentToCommunity>(
      builder: (context, provider, _) => SizedBox(
        height: files.isEmpty ? 0 : type == 'records' ? screenSize.height * 0.05 : screenSize.height * 0.1,
        width: double.infinity,
        child: Container(
          margin: files.isEmpty ? EdgeInsets.only(top: 5) : EdgeInsets.zero,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (type == "records") {
                return Stack(
                  children: [
                    Container(
                      width: screenSize.height * 0.05,
                      height: screenSize.height * 0.05,
                      decoration: BoxDecoration(
                        color: AppColors.accentColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(Icons.mic),
                    ),
                    Positioned(
                      top: -15,
                      right: -15,
                      child: IconButton(
                        onPressed: () {
                          provider.deleteFile(
                            index: index,
                            fileType: FileType.record,
                          );
                        },
                        icon: const Icon(
                          Icons.cancel,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                );
              } else {
                final bool isVideo =
                    files[index].path.toString().split('/').last.contains("mp4");
                return SizedBox(
                  height: screenSize.height * 0.1,
                  width: screenSize.width * 0.3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: isVideo
                              ? CustomVideoPlayer(
                                  path: files[index].path,
                                )
                              : Image.file(
                                  File(
                                    files[index].path,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Icon(
                        isVideo
                            ? Icons.video_camera_back_outlined
                            : Icons.image_outlined,
                        color: Colors.white,
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: IconButton(
                          onPressed: () {
                            provider.deleteFile(
                              index: index,
                              fileType: FileType.attach,
                            );
                          },
                          icon: const Icon(
                            Icons.cancel,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: 10,
            ),
            itemCount: files.length,
          ),
        ),
      ),
    );
  }
}
