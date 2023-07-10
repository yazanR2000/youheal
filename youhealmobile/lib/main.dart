import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/providers/record_player.dart';
import 'package:youhealmobile/utils/navigator.dart';

import 'package:youhealmobile/view_model/auth_view_model.dart';
import 'package:youhealmobile/view_model/medicla_history_view_model.dart';
import 'package:youhealmobile/view_model/my_posts_view_model.dart';
import 'package:youhealmobile/view_model/notifications_view_model.dart';
import 'package:youhealmobile/view_model/otp_view_model.dart';
import 'package:youhealmobile/view_model/post_comments_view_model.dart';
import 'package:youhealmobile/view_model/videos_and_links_view_model.dart';
import 'package:youhealmobile/views/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/views/splash/splash.dart';

import 'components/costum_page_views/custom_page_view.dart';
import 'firebase_options.dart';
import 'models/firebase_services.dart';
import 'providers/add_post_or_comment_to_cummunity.dart';
import 'providers/pdf_plan.dart';
import 'providers/video_player.dart';
import 'restart_app.dart';
import 'utils/app_theme.dart';
import 'view_model/carb_view_model.dart';
import 'view_model/community_view_model.dart';
import 'view_model/home_view_model.dart';
import 'view_model/reading_view_model.dart';
import 'views/home/home.dart';
import 'views/post_comments/post_comments.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Received a background message: ${message.notification?.body}');
  FirebaseMessagingService firebaseMessagingService =
      FirebaseMessagingService();
  await firebaseMessagingService.displayNotification(message);
}

void main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  final prefrences = await SharedPreferences.getInstance();
  Locale currentLang = const Locale('ar', 'EG');
  if (prefrences.containsKey('youhealLang')) {
    final key = prefrences.getString('youhealLang');
    if (currentLang.toString() != key) {
      currentLang = const Locale('en', 'US');
    }
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessagingService firebaseMessagingService =
      FirebaseMessagingService();
  await firebaseMessagingService.initialize();
  await firebaseMessagingService.configureFirebaseMessaging();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/langs',
      fallbackLocale: currentLang,
      child: const RestartApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: ReadingViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: CarbViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: MedicalHistoryViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: TextDayProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AddPostOrCommentToCommunity(),
        ),
        ChangeNotifierProvider.value(
          value: CommunityViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: HomeViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: MyPostsViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: PostCommentsViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: VideoPlayerProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PdfPlan(),
        ),
        ChangeNotifierProvider.value(
          value: OTPViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: VideosAndLinksViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: RecordPlayer(),
        ),
        ChangeNotifierProvider.value(
          value: NotificationsViewModel(),
        ),
      ],
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.theme,
          home: const SafeArea(child: Splash()),
          routes: {
            Home.routeName: (context) => const Home(),
            // VideosAndLinks.routeName: (context) =>  VideosAndLinks(),
            Auth.routeName: (context) => Auth()
          },
        ),
      ),
    );
  }
}
