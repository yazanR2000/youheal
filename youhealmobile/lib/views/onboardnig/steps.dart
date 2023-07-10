import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'dart:math' as math;

import 'package:youhealmobile/views/auth/login.dart';

import 'widgets/step.dart';

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      noAppBar: true,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image(
                width: screenSize.width * 0.4,
                height: screenSize.height * 0.1,
                image: const AssetImage('assets/images/logo.png'),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  StepWidget(
                    isVisible: _currentIndex == 0,
                    mainText: tr('searchDoctors'),
                    secondryText: tr('getListOfBestDoctorNearbyYou'),
                    image: 'assets/images/steps1.png',
                  ),
                  StepWidget(
                    isVisible: _currentIndex == 1,
                    mainText: tr('bookAppointment'),
                    secondryText: tr('Book an appointment with a right doctor'),
                    image: 'assets/images/steps2.png',
                  ),
                  StepWidget(
                    isVisible: _currentIndex == 2,
                    mainText: tr('Book Diagonostic'),
                    secondryText: tr('Search and book diagnostic test'),
                    image: 'assets/images/undraw_alien_science_nonm.svg',
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                if (_currentIndex + 1 == 3) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => Login(),
                      transitionDuration: const Duration(milliseconds: 1500),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                    (route) => false,
                  );
                }
                setState(() {
                  _currentIndex++;
                });
              },
              child: Text(tr("next")),
            ),
          ],
        ),
      ),
    );
  }
}

class ClipContainer extends CustomClipper<Path> {
  final slice = math.pi;

  final Size screenSize;
  final int index;
  ClipContainer({required this.screenSize, required this.index});
  @override
  Path getClip(Size size) {
    Path path = Path();
    //print(move);
    final double dx = size.width;
    final double dy = size.height;

    if (index == 0) {
      path.moveTo(dx * 0.2, dy * 0.1);

      path.quadraticBezierTo(-20, dy * 0.25, dx * 0.12, dy * 0.40);

      path.quadraticBezierTo(dx * 0.2, dy * 0.55, dx * 0.05, dy * 0.7);

      path.quadraticBezierTo(0, dy * 0.75, dx * 0.05, dy * 0.82);
      path.quadraticBezierTo(dx * 0.4, dy + 10, dx * 0.95, dy * 0.82);

      path.quadraticBezierTo(dx, dy * 0.75, dx * 0.95, dy * 0.7);
      path.quadraticBezierTo(dx * 0.67, dy * 0.6, dx * 0.95, dy * 0.3);
      path.quadraticBezierTo(dx, dy * 0.1, dx * 0.8, dy * 0.15);
      path.quadraticBezierTo(dx * 0.6, dy * 0.15, dx * 0.4, dy * 0.12);
      path.quadraticBezierTo(dx * 0.25, dy * 0.07, dx * 0.2, dy * 0.1);

      //  path.close();
    } else if (index == 1) {
      path.moveTo(dx * 0.27, dy * 0.2);

      path.quadraticBezierTo(-20, dy * 0.1, dx * 0.12, dy * 0.40);

      path.quadraticBezierTo(dx * 0.2, dy * 0.55, dx * 0.1, dy * 0.68);

      path.quadraticBezierTo(0, dy * 0.85, dx * 0.15, dy * 0.85);

      path.quadraticBezierTo(dx * 0.6, dy * 0.7, dx * 0.91, dy * 0.9);

      path.quadraticBezierTo(dx, dy * 0.95, dx * 0.9, dy * 0.6);
      path.quadraticBezierTo(dx * 0.87, dy * 0.5, dx * 0.9, dy * 0.3);
      path.quadraticBezierTo(dx * 0.97, dy * 0.02, dx * 0.7, dy * 0.2);
      path.quadraticBezierTo(dx * 0.5, dy * 0.3, dx * 0.27, dy * 0.2);
      // path.quadraticBezierTo(dx * 0.25, dy * 0.07, dx * 0.2, dy * 0.1);
      //path.close();
    } else {
      path.moveTo(dx * 0.1, dy * 0.1);
      path.quadraticBezierTo(dx * 0.1, dy * 0.2, dx * 0.1, dy * 0.4);
      path.quadraticBezierTo(-50, dy * 0.8, dx * 0.35, dy * 0.75);
      path.quadraticBezierTo(dx + 100, dy * 0.9, dx * 0.86, dy * 0.3);
      path.quadraticBezierTo(dx * 0.1, -50, dx * 0.1, dy * 0.1);

      // path.lineTo(dx, dy);

      //path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
