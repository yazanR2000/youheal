import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/form_field.dart';
import '../../../view_model/carb_view_model.dart';

class WeightAndHeight extends StatelessWidget {
  const WeightAndHeight({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RowItem(
          text: 'height',
          unit: 'cm',
        ),
        RowItem(
          text: 'weight',
          unit: 'kg',
        )
      ],
    );
  }
}

class RowItem extends StatelessWidget {
  final String text;
  final String unit;
  const RowItem({super.key, required this.text, required this.unit});

  bool _isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(text),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: CustomFormField(
                errorStyle: const TextStyle(height: 0),
                hintText: '',
                textInputType: TextInputType.number,
                isFinalNode: true,
                validator: (String? value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.startsWith('0') ||
                      !_isNumeric(value)) {
                    return '';
                  }
                  return null;
                },
                onSave: (value) {
                  Provider.of<CarbViewModel>(context, listen: false)
                      .personData[text] = double.parse(value);
                },
              ),
            ),
            Container(
              height: 50,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff19769F).withOpacity(0.5),
                    const Color(0xff35D8A6).withOpacity(0.5),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff0000001c).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                tr(unit),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
