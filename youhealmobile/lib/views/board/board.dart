import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';

import 'package:youhealmobile/view_model/home_view_model.dart';
import 'package:youhealmobile/views/board/widgets/card_button.dart';
import 'package:youhealmobile/views/board/widgets/profile_data.dart';
import 'package:youhealmobile/views/calculate_carb/calculate_carb.dart';
import 'package:youhealmobile/views/medical_history/medical_history.dart';

import '../../components/response/no_data_response.dart';
import '../../components/spinkit.dart';
import '../../models/firebase_services.dart';
import '../../utils/navigator.dart';
import '../post_comments/post_comments.dart';
import 'widgets/news.dart';
import 'widgets/three_videos_and_links.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessagingService firebaseMessagingService =
      FirebaseMessagingService();
  Future<void> displayNotification(RemoteMessage message) async {
    FirebaseMessagingService firebaseMessagingService =
        FirebaseMessagingService();
    await firebaseMessagingService.displayNotification(message);
    String postId = message.data['postId'];
    print("============================");
    print(postId);
    print("============================");
    // ignore: use_build_context_synchronously
    NavigationController.navigatorRoute(
      context: context,
      page: PostComments(
        postId: int.parse(postId),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeViewModel>(context, listen: false)
          .getHomeData(context: context);
      Provider.of<CarbViewModel>(context, listen: false).getLastPlan();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Received a message in the foreground: ${message.notification?.body}');
      displayNotification(message);
    });
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null) {
    //     print('A new onLaunch event was published!');
    //     displayNotification(message);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Center(
              child: Spinkit.spinKit(),
            );
          } else if (viewModel.homeData == null) {
            return NoDataResponse(
              onPressed: () => viewModel.getHomeData(context: context),
              title: tr("internetConnection"),
              buttonText: tr("tryAgain"),
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: screenSize.height * 0.15,bottom: 20),
            child: Column(
              children: [
                News(
                  screenHegiht: screenSize.height,
                  news: const [
                    "https://www.healthcareitnews.com/sites/hitn/files/Global%20healthcare_2.jpg",
                    "https://www.healthcareitnews.com/sites/hitn/files/Global%20healthcare_2.jpg",
                    "https://www.healthcareitnews.com/sites/hitn/files/Global%20healthcare_2.jpg",
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                ProfileData(height: screenSize.height * 0.42),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      CardButton(
                                        icon: Resources.calculateCrabNeed,
                                        page: const CalculateCarb(),
                                        title: "yourCarb",
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CardButton(
                                        icon: Resources.sugarLevel,
                                        page: const MedicalHistory(),
                                        title: "medicalHistory",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ThreeVideosAndLinks(
                          isVideos: true,
                          links: viewModel.homeData!['videos'],
                          screenSize: screenSize,
                          title: "videos",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ThreeVideosAndLinks(
                          isVideos: false,
                          links: viewModel.homeData!['links'],
                          screenSize: screenSize,
                          title: "links",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
