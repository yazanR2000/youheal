import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/navigator.dart';
import '../../languages/languages.dart';

class ProfileSettingsTiles extends StatelessWidget {
  const ProfileSettingsTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow:  [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 0),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Tile(
            leadingIcon: Icons.language,
            title: tr("language"),
            navigateScreen: const Languages(),
          ),
          //  Tile(
          //   leadingIcon: Icons.dark_mode_outlined,
          //   title: tr("darkMode"),
          //   navigateScreen: Container(),
          // ),
          // Tile(
          //   leadingIcon: Icons.help_outline_outlined,
          //   title: tr("help"),
          //   navigateScreen: Container(),
          // ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget navigateScreen;
  const Tile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.navigateScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      onTap: () => NavigationController.navigatorRoute(
        context: context,
        page: navigateScreen,
      ),
      leading: Icon(leadingIcon,color: AppColors.primaryColor,size: 30,),
      title: Text(title),
      trailing: Icon(Icons.arrow_right_rounded,color: AppColors.primaryColor),
    );
  }
}
