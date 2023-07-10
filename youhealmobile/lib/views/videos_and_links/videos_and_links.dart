
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/components/spinkit.dart';
import 'package:youhealmobile/components/players/youtube_video.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/view_model/videos_and_links_view_model.dart';
import '../../components/screen_header_box.dart';
import '../../utils/constants.dart';

class VideosAndLinks extends StatefulWidget {
  static const routeName = 'VideosAndLinksScreen';

  final bool isVideos;
  const VideosAndLinks({super.key, required this.isVideos});

  @override
  State<VideosAndLinks> createState() => _VideosAndLinksState();
}

class _VideosAndLinksState extends State<VideosAndLinks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<VideosAndLinksViewModel>(context, listen: false)
          .getAllVideosOrLinks(
        context: context,
        type: widget.isVideos ? VideosOrLinks.videos : VideosOrLinks.links,
      );
    });
  }

  Future<void> _launchUrl({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Consumer<VideosAndLinksViewModel>(
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
                      final dataLength = viewModel.data.length;
                      if (dataLength % Constants.paginationLimit == 0) {
                        // viewModel.getVideosOrLinksByPagination(
                        //   type: widget.isVideos
                        //       ? VideosOrLinks.videos
                        //       : VideosOrLinks.links,
                        //   page: (viewModel.data.length /
                        //               Constants.paginationLimit)
                        //           .ceil() +
                        //       1,
                        // );
                      }
                    }
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: screenSize.height * 0.15),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.06,
                        ),
                        child: ScreenHeaderBox(
                          imagePath: widget.isVideos
                              ? Resources.videos
                              : Resources.links,
                          icon: widget.isVideos
                              ? Icons.video_library_outlined
                              : Icons.link_rounded,
                          title: widget.isVideos ? "videos" : "links",
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => Container(
                          height: screenSize.height * 0.2,
                          width: screenSize.width,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  // padding: const EdgeInsets.all(20),
                                  alignment: Alignment.bottomLeft,
                                  width: screenSize.width * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.black,
                                    image: widget.isVideos
                                        ? null
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              viewModel.data[index]
                                                  ['uploadLinkImage']['url'],
                                            ),
                                          ),
                                  ),
                                  child: widget.isVideos
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: YoutubeVideo(
                                            videoId: viewModel.data[index]
                                                ['url'],
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            await _launchUrl(
                                              url: viewModel.data[index]['url'],
                                            );
                                          },
                                          child: Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                100,
                                              ),
                                            ),
                                            child: Text(
                                              viewModel.data[index]['title'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shadowColor: Colors.black26,
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    //print('yazan');
                                  },
                                  child: Icon(
                                    widget.isVideos
                                        ? Icons.videocam
                                        : Icons.link,
                                    color: widget.isVideos
                                        ? Colors.red
                                        : const Color(0xff4565AF),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                        itemCount: viewModel.data.length,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
