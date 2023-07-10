import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/components/custom_elevated_button.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';

import '../../../components/custom_scaffold.dart';
import '../../../providers/pdf_plan.dart';
import './widgets/week_plan.dart';

class Plan extends StatelessWidget {
  const Plan({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final plan = Provider.of<CarbViewModel>(context, listen: false);
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          screenSize.width * 0.05,
          screenSize.height * 0.15,
          screenSize.width * 0.05,
          15
        ),
        child: Column(
          children: [
            Expanded(
              child: WeekPlan(
                weekPlan: plan.plan,
                weekDays: plan.plan.keys.toList(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              // padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              width: double.infinity,
              child: Consumer<PdfPlan>(
                builder:(context, provider, _) =>  CustomElevatedButton(
                  onPressed: provider.isLoading ? null : () async {
                    try{
                      await provider.downloadPdfPlan(plan: plan.plan, ctx: context,name: "Plan");
                      final prefrences = await SharedPreferences.getInstance();
                      await prefrences.setString("lastPlan", json.encode(plan.plan));
                      await prefrences.setString("nutritionData", json.encode(plan.nutritionData));
                    }catch(err){
                      print(err);
                    }
                  },
                  child: Text(
                    tr('downloadPlan'),
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
