import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginWith extends StatelessWidget {
  const LoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const FaIcon(FontAwesomeIcons.facebook),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
