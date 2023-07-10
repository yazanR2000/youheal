import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/custom_elevated_button.dart';

import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';
import 'package:youhealmobile/views/calculate_carb/widgets/gender.dart';

import '../../components/custom_scaffold.dart';
import '../../components/response/handle_response_msg.dart';
import 'person_data_need_screen/person_data_need.dart';
import 'widgets/age.dart';
import 'widgets/exercise_type.dart';
import 'widgets/weight_and_height.dart';

class CalculateCarb extends StatefulWidget {
  const CalculateCarb({super.key});

  @override
  State<CalculateCarb> createState() => _CalculateCarbState();
}

class _CalculateCarbState extends State<CalculateCarb> {
  final _formKey = GlobalKey<FormState>();

  Future _calculateCarb(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final carbProvider = Provider.of<CarbViewModel>(context, listen: false);
      if (carbProvider.personData['gender'] == null) {
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: 'pleaseSelectYourGender',
          statusCode: 400,
        );
        return;
      } else if(carbProvider.personData['type'] == null) {
        HandleResponseMsg.showSnackBar(
          context: context,
          msg: 'pleaseSelectType',
          statusCode: 400,
        );
        return;
      }
      carbProvider.calculatePersonDataNeed(context: context);
      NavigationController.navigatorRoute(
        context: context,
        page: const PersonDataNeed(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final carbProvider = Provider.of<CarbViewModel>(context,listen: false);
    carbProvider.personData['gender'] = null;
    carbProvider.personData['type'] = null;
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.15,
            horizontal: screenSize.width * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gender(),
              const SizedBox(
                height: 20,
              ),
              const Age(),
              const SizedBox(
                height: 30,
              ),
              const WeightAndHeight(),
              const SizedBox(
                height: 20,
              ),
              ExerciseType(),
              const SizedBox(
                height: 40,
              ),
              CustomElevatedButton(
                width: double.infinity,
                onPressed: () => _calculateCarb(context),
                child: Text(
                  tr('calculate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
