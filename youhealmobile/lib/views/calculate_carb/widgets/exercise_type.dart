import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';

import '../../../components/custom_drop_down.dart';

class ExerciseType extends StatefulWidget {
  ExerciseType({super.key});

  @override
  State<ExerciseType> createState() => _ExerciseTypeState();
}

class _ExerciseTypeState extends State<ExerciseType> {
//   -	Sedentary (little or no exercise): calories = BMR × 1.2
  List<String> _types = [
    'Sedentary (little or no exercise)',
    'Lightly active (light exercise/sports 1-3 days/week)',
    'Moderately active (moderate exercise/sports 3-5 days/week)',
    'Very active (hard exercise/sports 6-7 days a week)',
    'If you are extra active (very hard exercise/sports & a physical job)'
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // final currentLocale = EasyLocalization.of(context)!.currentLocale;
      // if (currentLocale != Locale('en', 'US')) {
      //   setState(() {
      //     _types = _types.map((e) => tr(e)).toList();
      //     final carbProvider =
      //         Provider.of<CarbViewModel>(context, listen: false);
      //     carbProvider.personData['type'] = _types[0];
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbProvider = Provider.of<CarbViewModel>(context, listen: false);
    return CustomDropDown(
      from: 'Carb',
      hintText: tr("select"),
      isVisible: true,
      options: _types.map((e) => tr(e)).toList(),
      selectedValue: carbProvider.personData['type'],
      onChange: (value) {
        carbProvider.personData['type'] = value;
      },
    );
  }
}
