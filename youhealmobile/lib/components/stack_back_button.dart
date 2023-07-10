import 'package:flutter/material.dart';

class StackBackButton extends StatelessWidget {
  const StackBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: screenSize.width * 0.05,
      top: screenSize.height * 0.1,
      child: IconButton(
        onPressed: ()=> Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: const Color(0xff929497),
        disabledColor: const Color(0xff929497),
      ),
    );
  }
}
