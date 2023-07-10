import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? width,height;
  const Logo({super.key,this.height,this.width});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Hero(
      tag: 'logo',
      child: Image(
        width: width ?? screenSize.width * 0.4,
        height: height ?? screenSize.height * 0.1,
        image: const AssetImage('assets/images/logo.png'),
      ),
    );
  }
}
