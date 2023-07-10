import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/views/videos_and_links/videos_and_links.dart';

import '../../../components/players/youtube_video.dart';

class ThreeVideosAndLinks extends StatelessWidget {
  final String title;
  final bool isVideos;
  final List<dynamic> links;
  final Size screenSize;
  const ThreeVideosAndLinks({
    super.key,
    required this.title,
    required this.isVideos,
    required this.links,
    required this.screenSize,
  });

  Future<void> _launchUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr(title),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    NavigationController.navigatorRoute(
                      context: context,
                      page: VideosAndLinks(isVideos: isVideos),
                    );
                  },
                  child: Text(
                    tr("showAll"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: screenSize.height * 0.2,
            width: double.infinity,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 30),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                alignment: context.locale == const Locale('ar', 'EG')
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                // padding: const EdgeInsets.all(20),
                height: screenSize.height * 0.2,
                width: screenSize.width * 0.8,
                decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  image: isVideos
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            links[index]['uploadLinkImage']['url'],
                          ),
                        ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: isVideos
                      ? YoutubeVideo(videoId: links[index]['url'])
                      : InkWell(
                          onTap: () async {
                            await _launchUrl(url: links[index]['url']);
                          },
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Text(
                                links[index]['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(
                width: 10,
              ),
              itemCount: links.length,
            ),
          ),
        ],
      ),
    );
  }
}
