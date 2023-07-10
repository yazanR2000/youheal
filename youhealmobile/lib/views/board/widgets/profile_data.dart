import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';
import 'package:youhealmobile/views/calculate_carb/plan_screen/plan.dart';
import 'package:youhealmobile/views/reading/reading.dart';

import '../../../models/current_user.dart';
import '../../../utils/resources.dart';

class ProfileData extends StatelessWidget {
  final double height;
  ProfileData({super.key, required this.height});

  final currentUser = CurrentUser.currentUser;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xff29AC98).withOpacity(0.35),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  currentUser!.userData!['gender'] == 'f' ? Resources.female : Resources.male,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Text(
                  currentUser!.userData!['user'],
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xffC63737),
                        side: const BorderSide(color: Color(0xffC63737), width: 2.0),
                      ),
                      onPressed: () => NavigationController.navigatorRoute(
                        context: context,
                        page: const Reading(),
                      ),
                      child: Text(
                        tr("addNewReading"),
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              Consumer<CarbViewModel>(
                builder: (context, carbViewModel, _) => carbViewModel.plan.isEmpty ? const SizedBox() : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor.withOpacity(0.75),
                          // side:  BorderSide(color: AppColors.primaryColor, width: 2.0),
                        ),
                        onPressed: () => NavigationController.navigatorRoute(
                          context: context,
                          page: const Plan(),
                        ),
                        child: FittedBox(
                          child: Text(
                            tr("lastPlan"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
