import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/carb_view_model.dart';

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  
  @override
  Widget build(BuildContext context) {
    final carbProvider = Provider.of<CarbViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('gender'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  carbProvider.personData['gender'] = 'm';
                });
              },
              child: Row(
                children: [
                  Radio(
                    value: 'm',
                    groupValue: carbProvider.personData['gender'],
                    onChanged: (value) {
                      setState(() {
                        carbProvider.personData['gender'] = value;
                      });
                    },
                  ),
                  Text(
                    tr('male'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  carbProvider.personData['gender'] = 'f';
                });
              },
              child: Row(
                children: [
                  Radio(
                    value: 'f',
                    groupValue: carbProvider.personData['gender'],
                    onChanged: (value) {
                      setState(() {
                        carbProvider.personData['gender'] = value;
                      });
                    },
                  ),
                  Text(
                    tr('female'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
