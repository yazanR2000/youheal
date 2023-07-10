import 'package:flutter/material.dart';
import 'package:youhealmobile/models/current_user.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/views/profile_settings/profile_settings.dart';

class InfoBox extends StatelessWidget {
  InfoBox({super.key});

  final currentUser = CurrentUser.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.3,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xff4565AF),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                    
                     currentUser!.userData!['gender'] == 'f' ? Resources.female : Resources.male,
                    ),
                  ),
                  Text(
                    currentUser!.userData!['user'],
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    currentUser!.userData!['phone'].toString().replaceAll('+', "00"),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => NavigationController.navigatorRoute(
              context: context,
              page: const ProfileSettings(),
            ),
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
