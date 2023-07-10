import 'package:flutter/material.dart';

class CircleTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  const CircleTitle({super.key, 
    required this.icon,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0000001c).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 50,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: color,
                ),
          )
        ],
      ),
    );
  }
}
