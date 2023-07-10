import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final double? width;
  final double height;
  final VoidCallback? onPressed;
  final Widget child;

  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height = 44.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'CustomElevatedButton',
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff19769F).withOpacity(0.5),
              const Color(0xff35D8A6).withOpacity(0.5),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff0000001c).withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
