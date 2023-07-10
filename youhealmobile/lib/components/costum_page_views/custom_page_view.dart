import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/view_model/carb_view_model.dart';

class CustomPageView extends StatelessWidget {
  final PageController pageController;
  final Color? inputDecoratorLabelColor;
  final Map<String, dynamic>? readings;
  final bool withNutritionData;
  const CustomPageView(
      {super.key,
      required this.pageController,
      this.inputDecoratorLabelColor,
      this.readings,
      this.withNutritionData = false});

  String _getTranlatedDay(String key){
    if(withNutritionData){

      return "${tr(key.split(" ")[0])} ${key.split(" ")[1]}";
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    List<String> keyList = readings!.keys.toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackAndForwordButton(
              icon: Icons.arrow_back_ios_outlined,
              isForword: false,
              controller: pageController,
            ),
            Consumer<TextDayProvider>(
              builder: (context, value, _) => Text(_getTranlatedDay(keyList[value.index])),
            ),
            BackAndForwordButton(
              icon: Icons.arrow_forward_ios_outlined,
              isForword: true,
              controller: pageController,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: (index) {
              Provider.of<TextDayProvider>(context, listen: false)
                  .notify(index);
            },
            itemBuilder: (context, index) {
              List<dynamic> singleDay = readings![keyList[index]]!;
              return DayRecords(
                dayRecords: singleDay,
                inputDecoratorLabelColor: inputDecoratorLabelColor,
                withNutritionData: withNutritionData,
              );
            },
            itemCount: keyList.length,
          ),
        ),
      ],
    );
  }
}

class BackAndForwordButton extends StatelessWidget {
  const BackAndForwordButton({
    super.key,
    required this.icon,
    required this.controller,
    required this.isForword,
  });
  final IconData icon;
  final PageController controller;
  final bool isForword;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        isForword
            ? await controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              )
            : await controller.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 0),
              blurRadius: 15,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 15,
        ),
      ),
    );
  }
}

class DayRecords extends StatelessWidget {
  final List<dynamic> dayRecords;
  final Color? inputDecoratorLabelColor;
  final bool withNutritionData;
  const DayRecords(
      {super.key,
      required this.dayRecords,
      this.inputDecoratorLabelColor,
      this.withNutritionData = false});

  Map<String, dynamic> _getNutrationData(
      {required String key, required BuildContext context}) {
    final nutritionData =
        Provider.of<CarbViewModel>(context, listen: false).nutritionData;
    Map<String, dynamic> data = {};
    data = nutritionData.firstWhere((element) => element['meal'] == key);
    return data;
  }

  Widget _nutriationTable(
      Map<String, dynamic> tableData, BuildContext context) {
    final columns = tableData.keys.toList();
    final values = tableData.values.toList();
    columns.removeAt(0);
    values.removeAt(0);
    return Table(
      border: TableBorder.all(color: Colors.black),
      // defaultVerticalAlignment: TableCellVerticalAlignment.fill,
      // defaultColumnWidth: TableColumnWidth,
      children: [
        TableRow(
          children: [
            ...columns
                .map(
                  (e) => Container(
                    alignment: Alignment.center,
                    height:35,
                    color: const Color(0xff29AC98).withOpacity(0.35),
                    padding: const EdgeInsets.all(8),
                    child: FittedBox(
                      child: Text(
                        tr(e),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
        TableRow(
          children: [
            ...values
                .map(
                  (e) => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      e.toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                )
                .toList()
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemBuilder: (context, index) => Container(
        color: const Color(0xffFBFBFB),
        child: InputDecorator(
          decoration: InputDecoration(
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.accentColor,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff0000001c).withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: FittedBox(
                  child: Text(
                withNutritionData ? tr(dayRecords[index].keys.toList()[0].toString()) : dayRecords[index].keys.toList()[0].toString(),
                style: const TextStyle(color: Colors.white),
              )),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xffD6D6D6),
              ),
            ),
          ),
          child: Column(
            children: [
              Text(dayRecords[index].values.toList()[0].toString()),
              if (withNutritionData)
                const SizedBox(
                  height: 20,
                ),
              if (withNutritionData)
                _nutriationTable(
                    _getNutrationData(
                      context: context,
                      key: dayRecords[index].keys.toList()[0].toString(),
                    ),
                    context),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 25,
      ),
      itemCount: dayRecords.length,
    );
  }
}

class TextDayProvider with ChangeNotifier {
  int index = 0;
  void notify(int index) {
    this.index = index;

    notifyListeners();
  }
}
