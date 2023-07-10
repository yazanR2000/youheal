import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youhealmobile/components/players/custom_video_player.dart';

import '../utils/enums.dart';

class PhotoAndVideoPreviewDialog extends StatefulWidget {
  final List<dynamic> urls;
  final int initialIndex;
  PhotoAndVideoPreviewDialog(
      {super.key, required this.urls, required this.initialIndex});

  @override
  State<PhotoAndVideoPreviewDialog> createState() =>
      _PhotoAndVideoPreviewDialogState();
}

class _PhotoAndVideoPreviewDialogState
    extends State<PhotoAndVideoPreviewDialog> {
  UrlType _isImage({required String url}) {
    if (url.contains("mp4")) {
      return UrlType.mp4;
    } else if (url.contains("aac")) {
      return UrlType.aac;
    }
    return UrlType.image;
  }

  PageController? _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.urls.length,
        itemBuilder: (context, index) => SizedBox(
          width: double.infinity,
          child: _isImage(url: widget.urls[index]['url']) == UrlType.mp4
              ? CustomVideoPlayer(path: widget.urls[index]['url'])
              : PhotoView(
                  tightMode: true,
                  wantKeepAlive: false,
                  imageProvider: NetworkImage(widget.urls[index]['url']),
                ),
        ),
      ),
    );
  }
}
