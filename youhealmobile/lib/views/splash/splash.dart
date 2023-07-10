import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/models/current_user.dart';
import 'package:youhealmobile/views/auth/login.dart';
import 'package:youhealmobile/views/home/home.dart';

import '../onboardnig/steps.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        init = !init;
      });
      await SharedPreferences.getInstance().then((prefrences) async {
        Future.delayed(
          const Duration(seconds: 2),
        ).then((_) async {
          try {
            bool isUserLoggedIn = prefrences.containsKey('youhealUser');

            if (isUserLoggedIn) {
              final rememberMe = prefrences.getBool('rememberMe');
              print(rememberMe);
              if (rememberMe != null && rememberMe) {
                CurrentUser.setUserData(
                  json.decode(prefrences.getString("youhealUser")!),
                );
                print(CurrentUser.currentUser!.userData);
              } else {
                isUserLoggedIn = false;
              }
            }
            // final showOnboarding = prefrences.getBool("showOnboarding");
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => isUserLoggedIn
                    ? const Home() : Login(),
                    // : showOnboarding == null
                    //     ? const Steps()
                    //     : Login(),
                transitionDuration: const Duration(milliseconds: 1500),
                transitionsBuilder: (_, a, __, c) => FadeTransition(
                  opacity: a,
                  child: c,
                ),
              ),
            );
          } catch (err) {
            print(err);
          }
        });
      });
    });
    // TODO: implement initState
    super.initState();
  }

  bool init = true;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            AnimatedPositioned(
              height: init ? screenSize.height * 0.15 : screenSize.height * 0.4,
              left: init ? screenSize.width + 100 : -100,
              top: -100,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: const Opacity(
                opacity: 0.4,
                child: Image(
                  fit: BoxFit.fitHeight,
                  //width: screenSize.width * 0.8,
                  image: AssetImage('assets/images/circle.png'),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: AnimatedContainer(
                  width: init ? 0 : screenSize.width * 0.4,
                  height: init ? 0 : screenSize.height * 0.2,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.linear,
                  child: const Hero(
                    tag: 'logo',
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              height: screenSize.height * 0.3,
              bottom: init ? 150 : 0,
              right: -screenSize.width * 0.3,
              duration: const Duration(milliseconds: 800),
              curve: Curves.linear,
              child: const Opacity(
                opacity: 0.4,
                child: Image(
                  fit: BoxFit.fitHeight,
                  //width: screenSize.width * 0.8,
                  image: AssetImage('assets/images/plaster.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
