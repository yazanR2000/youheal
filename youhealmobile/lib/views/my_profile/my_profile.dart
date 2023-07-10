import 'package:flutter/material.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';

import 'widgets/info_box.dart';
import 'widgets/profile_tiles.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.15,
          horizontal: screenSize.width * 0.06,
        ),
        child: Column(
          children: [
            InfoBox(),
            const SizedBox(height: 20,),
            ProfileTiles()
          ],
        ),
      ),
    );
  }
}
