import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_elevated_button.dart';
import 'package:youhealmobile/utils/app_colors.dart';

import '../../../components/alert_container.dart';
import '../../../components/custom_scaffold.dart';
import '../../../view_model/carb_view_model.dart';
import 'widgets/data_for_single_type.dart';

class PersonDataNeed extends StatefulWidget {
  const PersonDataNeed({super.key});

  @override
  State<PersonDataNeed> createState() => _PersonDataNeedState();
}

class _PersonDataNeedState extends State<PersonDataNeed> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final carbProvider = Provider.of<CarbViewModel>(context, listen: false);
    carbProvider.isLoading = true;
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.15,
          horizontal: screenSize.width * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AlertContainer(
              backgroundColor: AppColors.commentContainerColor,
              content: tr('planAlert'),
              points: [
                tr("planAlert1"),
                tr("planAlert2"),
                tr("planAlert3"),
                tr("planAlert4"),
              ],
              onPressed: () {
                Provider.of<CarbViewModel>(context, listen: false).notify();
              },
            ),
            DataForSingleType(
              type: 'calorieNeed',
              unitPerDay: tr('Cal/Day'),
              value: 'calorie',
            ),
            const SizedBox(
              height: 30,
            ),
            DataForSingleType(
              type: 'proteinNeed',
              unitPerDay: tr('gm/Day'),
              value: 'protein',
            ),
            const SizedBox(
              height: 30,
            ),
            DataForSingleType(
              type: 'carbohydrateNeed',
              unitPerDay: tr('gm/Day'),
              value: 'carbohydrate',
            ),
            const SizedBox(
              height: 30,
            ),
            DataForSingleType(
              type: 'fatNeed',
              unitPerDay: tr('gm/Day'),
              value: 'fat',
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Consumer<CarbViewModel>(
                builder: (context, viewModel, _) => CustomElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          await viewModel.getPlan(context: context);
                        },
                  child: Text(
                    tr('showPlan'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
