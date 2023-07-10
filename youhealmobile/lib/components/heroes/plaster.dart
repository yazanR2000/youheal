import 'package:flutter/material.dart';

class Plaster extends StatelessWidget {
  const Plaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -15,
      right: -15,
      child: Opacity(
        opacity: 0.3,
        child: Hero(
          tag: 'plaster',
          child: const Image(
            image: AssetImage('assets/images/plaster.png'),
          ),
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            return const Opacity(
              opacity: 0.3,
              child: Image(
                image: AssetImage('assets/images/plaster.png'),
              ),
            );
          },
        ),
      ),
    );
  }
}
