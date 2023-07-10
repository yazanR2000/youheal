import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/resources.dart';

class ScreenHeaderBox extends StatelessWidget {
  final IconData icon;
  final String? imagePath;
  final String title;
  final Color? color;

  const ScreenHeaderBox({
    super.key,
    required this.icon,
    required this.title,
    this.color,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (imagePath == null)
            Icon(
              icon,
              size: 90,
              color: color ?? AppColors.accentColor,
            ),
          if (imagePath != null)
            Image(
              image: AssetImage(imagePath!),
              height: 75,
              width: 75,
            ),
          const SizedBox(
            height: 20,
          ),
          Text(
            tr(title),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: color ?? AppColors.accentColor,
                ),
          ),
        ],
      ),
    );
  }
}
