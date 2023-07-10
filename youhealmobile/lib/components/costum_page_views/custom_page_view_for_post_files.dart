import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/enums.dart';
import '../photo_and_video_preview_dialog.dart';
import '../players/custom_video_player.dart';

class CustomPageViewForPostFiles extends StatefulWidget {
  final List<dynamic> files;
  final bool isMe;
  const CustomPageViewForPostFiles(
      {super.key, required this.files, this.isMe = false});

  @override
  State<CustomPageViewForPostFiles> createState() =>
      _CustomPageViewForPostFilesState();
}

class _CustomPageViewForPostFilesState
    extends State<CustomPageViewForPostFiles> {
  final PageController _pageController =
      PageController(viewportFraction: 0.85, initialPage: 0);

  int _currentPage = 0;

  UrlType isImage({required String url}) {
    if (url.contains("mp4")) {
      return UrlType.mp4;
    } else if (url.contains("aac")) {
      return UrlType.aac;
    }
    return UrlType.image;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: double.infinity,
      height: widget.files.isEmpty ? 0 : screenSize.height * 0.3,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                final urlType = isImage(url: widget.files[index]['url']);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  margin: EdgeInsets.all(
                    index != _currentPage ? 5 : 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: urlType == UrlType.mp4
                        ? CustomVideoPlayer(
                            path: widget.files[index]['url'],
                          )
                        : InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    PhotoAndVideoPreviewDialog(
                                  urls: widget.files,
                                  initialIndex: index,
                                ),
                              );
                            },
                            child: Image(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                widget.files[index]['url'],
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: Wrap(
              // : MainAxisAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: List.generate(
                widget.files.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: index == _currentPage ? 10 : 5,
                  width: index == _currentPage ? 10 : 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? widget.isMe
                            ? AppColors.accentColor
                            : AppColors.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
