import 'package:flutter/material.dart';

class NavigationController {
  static void navigatorRoute({required BuildContext context,required Widget page}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        ),
      );
  }
}