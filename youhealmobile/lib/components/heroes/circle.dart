import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  const Circle({super.key});

  @override
  Widget build(BuildContext context) {
    return  Positioned(
      top: -40,
      left: -80,
      child: Opacity(
        opacity: 0.3,
        child: Hero(
          tag:'circle',
          child: const Image(
            image: AssetImage('assets/images/circle.png'),
          ),
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            return const Opacity(
              opacity: 0.3,
              child: Image(
                image: AssetImage('assets/images/circle.png'),
              ),
            );
          },
        ),
      ),
    );
  }
}
