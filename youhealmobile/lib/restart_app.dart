import 'package:flutter/material.dart';

import 'main.dart';

class RestartApp extends StatefulWidget {
  const RestartApp({super.key});

  @override
  State<RestartApp> createState() => _RestartAppState();
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartAppState>()!.restartApp();
  }
}

class _RestartAppState extends State<RestartApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: const MyApp(),
    );
  }
}