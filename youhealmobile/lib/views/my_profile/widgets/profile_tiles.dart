import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/view_model/auth_view_model.dart';
import 'package:youhealmobile/views/medical_history/medical_history.dart';

import '../../../models/current_user.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/navigator.dart';
import '../../my_posts/my_posts.dart';
import '../../notifications/notifications.dart';

class ProfileTiles extends StatelessWidget {
  final currentUser = CurrentUser.currentUser;

  ProfileTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
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
            leadingIcon: Icons.person_pin_outlined,
            title: currentUser!.userData!['user'],
          ),
          Tile(
            leadingIcon: Icons.history,
            title: tr("medicalHistory"),
            navigateScreen: const MedicalHistory(),
          ),
          Tile(
            leadingIcon: Icons.collections_outlined,
            title: tr("myPosts"),
            navigateScreen: const MyPosts(),
          ),
          // Tile(
          //   leadingIcon: Icons.notifications_none_outlined,
          //   title: tr("notifications"),
          //   navigateScreen: const Notifications(),
          // ),
          ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    tr("logout"),
                  ),
                  content: Text(tr("sureLogout"),),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Provider.of<AuthViewModel>(context, listen: false)
                            .logout(context);
                        final prefrences = await SharedPreferences.getInstance();
                        await prefrences.setBool("rememberMe", false);
                      },
                      child: Text(
                        tr("yes"),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        tr("no"),
                      ),
                    ),
                  ],
                ),
              );
            },
            leading: Icon(
              Icons.logout,
              color: AppColors.primaryColor,
              size: 30,
            ),
            title: Text(tr("logout")),
            trailing:
                Icon(Icons.arrow_right_rounded, color: AppColors.primaryColor),
          )
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Widget? navigateScreen;
  const Tile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      this.navigateScreen});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      onTap: navigateScreen == null
          ? null
          : () => NavigationController.navigatorRoute(
                context: context,
                page: navigateScreen!,
              ),
      leading: Icon(
        leadingIcon,
        color: AppColors.primaryColor,
        size: 30,
      ),
      title: Text(title),
      trailing: navigateScreen == null
          ? null
          : Icon(Icons.arrow_right_rounded, color: AppColors.primaryColor),
    );
  }
}
