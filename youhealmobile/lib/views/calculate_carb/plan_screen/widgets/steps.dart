import 'package:flutter/material.dart';
import 'package:youhealmobile/views/calculate_carb/plan_screen/widgets/week_plan.dart';

class PlanWeekSteps extends StatefulWidget {
  const PlanWeekSteps({super.key});

  @override
  State<PlanWeekSteps> createState() => _PlanWeekStepsState();
}

class _PlanWeekStepsState extends State<PlanWeekSteps> {
  int _currentIndex = -1;
  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    return Container(
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                onTap: () => setState(() {
                  _currentIndex = _currentIndex == index ? -1 : index;
                }),
                title: Text('Week ${index + 1}'),
                trailing: Icon(
                  _currentIndex == index
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // AnimatedCrossFade(
              //   firstChild: const SizedBox(),
              //   secondChild: WeekPlan(weekPlan: const [{}, {}, {}, {}, {}]),
              //   crossFadeState: _currentIndex == index
              //       ? CrossFadeState.showSecond
              //       : CrossFadeState.showFirst,
              //   duration: const Duration(
              //     milliseconds: 500,
              //   ),
              // )
            ],
          );
        },
      ),
    );
    // return ListView.separated(
    //   physics: const NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) => SizedBox(
    //     height: screenSize.height * 0.35,
    //     width: double.infinity,
    //     child: Column(
    //       children: [
    //         Container(
    //           width: double.infinity,
    //           alignment: Alignment.center,
    //           padding: const EdgeInsets.symmetric(vertical: 16),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(25),
    //             color: const Color(0xff4565AF),
    //           ),
    //           child: Text('Step ${index + 1}',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
    //         ),
    //         Expanded(
    //           child: Container(
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(25),
    //               color: Colors.white
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   separatorBuilder: (context, index) => const SizedBox(height: 30),
    //   itemCount: 2,
    // );
  }
}
