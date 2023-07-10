import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/providers/record_player.dart';
import 'package:youhealmobile/providers/video_player.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/views/medical_history/medical_history.dart';
import 'package:youhealmobile/views/notifications/notifications.dart';

import '../../utils/app_colors.dart';
import '../board/board.dart';
import '../community/community.dart';
import '../my_profile/my_profile.dart';

class Home extends StatefulWidget {
  static const routeName = 'HomeScreen';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fiveTabNavKey = GlobalKey<NavigatorState>();
  CupertinoTabController? tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOfKeys = [
      firstTabNavKey,
      secondTabNavKey,
      thirdTabNavKey,
      fourTabNavKey,
      fiveTabNavKey
    ];
    tabController = CupertinoTabController(initialIndex: 0);
    tabController!.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    tabController!.removeListener(_handleTabChange);
    tabController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _handleTabChange() {
    Provider.of<VideoPlayerProvider>(context, listen: false).stopVideos();
    final recordsProvider = Provider.of<RecordPlayer>(context, listen: false);
    if (recordsProvider.playingId != -1) {
      recordsProvider.stopRecords(id: -1);
    }
    listOfKeys![tabController!.index]
        .currentState!
        .popUntil((route) => route.isFirst);
  }

  List<GlobalKey<NavigatorState>>? listOfKeys;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final bool canPop =
            listOfKeys![tabController!.index].currentState!.canPop();
        if (!canPop) {
          // ignore: use_build_context_synchronously
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(tr("exitApp")),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    exit(0);
                  },
                  child: Text(
                    tr("yes"),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    tr("no"),
                  ),
                ),
              ],
            ),
          );
        } else {
          return !await listOfKeys![tabController!.index]
              .currentState!
              .maybePop();
        }
        return Future.delayed(const Duration(seconds: 0));
      },
      child: CupertinoTabScaffold(
        controller: tabController,
        tabBar: CupertinoTabBar(
          onTap: (index) {
            if (index == tabController!.index) {
              setState(() {
                _currentIndex = index;
              });
              listOfKeys![tabController!.index]
                  .currentState!
                  .popUntil((route) => route.isFirst);
            }
          },
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          height: 80,
          activeColor: const Color(0xff205072),
          inactiveColor: AppColors.accentColor,
          iconSize: 40,
          items: [
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(Resources.home),
                height: 32,
                width: 32,
                color: _currentIndex == 0 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(Resources.healthCheckup),
                height: 35,
                width: 35,
                color: _currentIndex == 1 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(Resources.community),
                height: 40,
                width: 40,
                color: _currentIndex == 2 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(Resources.notifications),
                height: 35,
                width: 35,
                color: _currentIndex == 3 ? Colors.black : Colors.grey,
              ),
            ),
            BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(Resources.user),
                height: 35,
                width: 35,
                color: _currentIndex == 4 ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              {
                return CupertinoTabView(
                  navigatorKey: listOfKeys![index],
                  builder: (context) {
                    return const CupertinoPageScaffold(
                      child: Board(),
                    );
                  },
                );
              }
            case 1:
              {
                return CupertinoTabView(
                  navigatorKey: listOfKeys![index],
                  builder: (context) {
                    return const CupertinoPageScaffold(
                      child: MedicalHistory(),
                    );
                  },
                );
              }
            case 2:
              {
                return CupertinoTabView(
                  navigatorKey: listOfKeys![index],
                  builder: (context) {
                    return const CupertinoPageScaffold(child: Community());
                  },
                );
              }

            case 3:
              {
                return CupertinoTabView(
                  navigatorKey: listOfKeys![index],
                  builder: (context) {
                    return const CupertinoPageScaffold(child: Notifications());
                  },
                );
              }
            case 4:
              {
                return CupertinoTabView(
                  navigatorKey: listOfKeys![index],
                  builder: (context) {
                    return const CupertinoPageScaffold(child: MyProfile());
                  },
                );
              }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
