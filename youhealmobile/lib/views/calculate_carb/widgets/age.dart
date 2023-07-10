import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/form_field.dart';
import '../../../view_model/carb_view_model.dart';

class Age extends StatelessWidget {
  bool _isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  const Age({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('age'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(
          width: 100,
          height: 50,
          child: CustomFormField(
            errorStyle: const TextStyle(height: 0),
            hintText: '',
            textInputType: TextInputType.number,
            validator: (String? value) {
              if (value == null || value.isEmpty || value.startsWith('0') || !_isNumeric(value)) {
                return '';
              }
              return null;
            },
            onSave: (value){
              Provider.of<CarbViewModel>(context,listen: false).personData['age'] = int.parse(value);
            },
          ),
        ),
      ],
    );
  }
}
