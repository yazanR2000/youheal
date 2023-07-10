import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youhealmobile/utils/app_colors.dart';

import '../../../../components/costum_page_views/custom_page_view.dart';

class WeekPlan extends StatelessWidget {
  final Map<String, dynamic> weekPlan;
  final List<String> weekDays;
  WeekPlan({super.key, required this.weekPlan, required this.weekDays});

  final PageController _pageController =
      PageController(viewportFraction: 1, initialPage: 0);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      //padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Column(
        children: [
          Consumer<TextDayProvider>(
            builder: (context, provider, _) => Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: List.generate(
                weekPlan.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Chip(
                    shadowColor: Colors.black45,
                    elevation: 5,
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    padding: EdgeInsets.zero,
                    backgroundColor: index == provider.index
                        ? AppColors.primaryColor
                        : Colors.white,
                    label: Text(
                      "${tr(weekDays[index].split(" ")[0])} ${weekDays[index].split(" ")[1]}",
                      style: TextStyle(
                        color: index == provider.index
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
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
              child: CustomPageView(
                pageController: _pageController,
                inputDecoratorLabelColor: AppColors.accentColor,
                readings: weekPlan,
                withNutritionData: true,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
