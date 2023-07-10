import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/navigator.dart';
import '../views/post_comments/post_comments.dart';

class FirebaseMessagingService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> displayNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Aisscco',
      'YouHeal',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    
    
    final title = await TranslateTitle.getTranslateTitle();
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  Future<void> configureFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Received a message in the foreground: ${message.notification?.body}');
      displayNotification(message);
    });
  }
}

class TranslateTitle {
  static Future<String> getTranslateTitle() async {
    final prefrences = await SharedPreferences.getInstance();
    Locale currentLang = const Locale('ar', 'EG');
    if (prefrences.containsKey('youhealLang')) {
      final key = prefrences.getString('youhealLang');
      if (currentLang.toString() != key) {
        currentLang = const Locale('en', 'US');
      }
    }
    final notificationTitle = currentLang == const Locale('ar', 'EG')
        ? "احدهم علق على منشورك"
        : "Someone Commented on Your Post";
    return notificationTitle;
  }
}
