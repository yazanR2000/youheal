import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youhealmobile/utils/navigator.dart';
import 'package:youhealmobile/view_model/medicla_history_view_model.dart';
import 'package:youhealmobile/views/reading/reading.dart';

import '../../../components/costum_page_views/custom_page_view.dart';

import '../../../components/response/no_data_response.dart';
import '../../../components/spinkit.dart';

class MedicalRecords extends StatefulWidget {
  const MedicalRecords({super.key});

  @override
  State<MedicalRecords> createState() => _MedicalRecordsState();
}

class _MedicalRecordsState extends State<MedicalRecords> {
  final PageController _pageController = PageController(viewportFraction: 1);
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<MedicalHistoryViewModel>(context, listen: false)
    //       .getMedicalHistory(context);
    // });
    // TODO: implement initState
    super.initState();
  }
  String _getReadingId({required String reading}) {
    
    Map<String,String> readingTypes = {
      "0" : tr("Random reading"),
      "1" : tr("Fasting blood sugar (at least 8 hours)"),
      "2": tr("Tow hours after meals"),
      "3" : tr("Before the meal"),
      "4": tr("Before exercise"),
      "5" : tr("At bedtime"),
      "6" : tr("After exercise")
    };
    return readingTypes[reading]!;
  }
  Widget _filterRecordsBaedOnDay() {
    final readingProvider =
        Provider.of<MedicalHistoryViewModel>(context, listen: false);
    final records = readingProvider.readings;
    Map<String, List<Map<String, String>>> readingsArch = {};


    for (var element in records) {
      final key = DateTime.parse(element['createdAt'].toString())
          .toLocal()
          .toString()
          .split(' ');

      if (readingsArch.containsKey(key[0])) {
        readingsArch[key[0]]!.add(
          {
            _getReadingId(reading: element['type'].toString()): element['value'].toString(),
          },
        );
      } else {
        readingsArch.putIfAbsent(
          key[0],
          () => [
            {
              _getReadingId(reading: element['type'].toString()): element['value'].toString(),
            },
          ],
        );
      }
    }
    return CustomPageView(
      pageController: _pageController,
      readings: readingsArch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 0),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Consumer<MedicalHistoryViewModel>(
          builder: (context, viewModel,_) {
            if (viewModel.isLoading) {
              return Center(
                child: Spinkit.spinKit(),
              );
            } else {
              if (viewModel.readings.isEmpty) {
                return NoDataResponse(
                  title: tr("emptyMedicalHistory"),
                  onPressed: () => NavigationController.navigatorRoute(
                    context: context,
                    page: const Reading(),
                  ),
                  buttonText: tr("addNewReading"),
                );
              }
              return _filterRecordsBaedOnDay();
            }
          },
        ),
      ),
    );
  }
}
