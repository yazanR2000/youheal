import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/screen_header_box.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/resources.dart';
import 'package:youhealmobile/views/medical_history/widgets/medical_records.dart';

import '../../components/custom_elevated_button.dart';
import '../../components/custom_scaffold.dart';
import '../../providers/pdf_plan.dart';
import '../../view_model/medicla_history_view_model.dart';

class MedicalHistory extends StatefulWidget {
  const MedicalHistory({super.key});

  @override
  State<MedicalHistory> createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<MedicalHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MedicalHistoryViewModel>(context, listen: false)
          .getMedicalHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            screenSize.width * 0.06,
            screenSize.height * 0.15,
            screenSize.width * 0.06,
            screenSize.height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: ScreenHeaderBox(
                imagePath: Resources.pill,
                icon: Icons.medical_services_outlined,
                title: tr("medicalHistory"),
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const MedicalRecords(),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              // padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
              width: double.infinity,
              child: Consumer2<PdfPlan, MedicalHistoryViewModel>(
                builder: (context, pdfProvider, medicalHistoryProvider, _) =>
                    CustomElevatedButton(
                  onPressed:
                      pdfProvider.isLoading || medicalHistoryProvider.isLoading
                          ? null
                          : medicalHistoryProvider.readings.isEmpty
                              ? null
                              : () async {
                                  await pdfProvider.downloadPdfPlan(
                                      plan: medicalHistoryProvider
                                          .filterRecordsBaedOnDay(),
                                      ctx: context,
                                      name: "Blood Sugar Readings report");
                                },
                  child: Text(
                    tr('downloadMedicalRecords'),
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
