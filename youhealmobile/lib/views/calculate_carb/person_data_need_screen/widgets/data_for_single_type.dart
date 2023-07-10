import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/form_field.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';

class DataForSingleType extends StatelessWidget {
  final String type;
  final String unitPerDay;
  final String value;
  const DataForSingleType(
      {super.key, required this.type, required this.unitPerDay,required this.value});

  @override
  Widget build(BuildContext context) {
    final personDataNeed =
        Provider.of<CarbViewModel>(context, listen: false).personDataNeed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(type),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                child: CustomFormField(
                  textEditingController: TextEditingController(text: personDataNeed[value].toString()),
                  hintText: '',
                  enabled: false,
                  initialValue: personDataNeed[value].toString(),
                ),
              ),
            ),
            Container(
              height: 60,
              // width: 30,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                unitPerDay,
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
