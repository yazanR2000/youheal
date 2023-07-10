import 'package:flutter/material.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/components/my_app_bar/my_app_bar.dart';
import 'package:youhealmobile/components/my_drawer/my_drawer.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/views/profile_settings/widgets/profile_settings_tiles.dart';

import '../../components/screen_header_box.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.15,
          horizontal: screenSize.width * 0.06,
        ),
        child:  Column(
          children: [
            ScreenHeaderBox(
              color: AppColors.primaryColor,
              imagePath: Resources.settingsIcon,
              icon: Icons.settings_outlined,
              title: "settings",
            ),
            SizedBox(height: 40,),
            ProfileSettingsTiles(),
          ],
        ),
      ),
    );
  }
}
