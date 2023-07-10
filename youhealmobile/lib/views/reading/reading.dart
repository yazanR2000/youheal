import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youhealmobile/components/alert_container.dart';
import 'package:youhealmobile/components/custom_elevated_button.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';
import 'package:youhealmobile/components/screen_header_box.dart';
import 'package:youhealmobile/utils/app_colors.dart';
import 'package:youhealmobile/utils/resources.dart';

import '../../components/custom_drop_down.dart';
import '../../components/form_field.dart';
import '../../components/spinkit.dart';
import '../../view_model/reading_view_model.dart';

class Reading extends StatelessWidget {
  const Reading({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<ReadingViewModel>(context, listen: false).showWarning = false;
    final screenSize = MediaQuery.of(context).size;
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          screenSize.width * 0.1,
          screenSize.height * 0.15,
          screenSize.width * 0.1,
          screenSize.height * 0.05,
        ),
        child: Column(
          children: [
            ScreenHeaderBox(
              icon: Icons.abc,
              title: tr("readingScreen"),
              imagePath: Resources.readingIcon,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 30,),
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<ReadingViewModel>(
                  builder: (context, viewModel, _) => viewModel.showWarning
                      ? AlertContainer(
                          backgroundColor: Colors.red,
                          content: tr(viewModel.warningText),
                          textColor: Colors.white,
                        )
                      : const SizedBox(),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tr('reading'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<ReadingViewModel>(
                      builder: (context, viewModel, _) => CustomFormField(
                        textEditingController: TextEditingController(),
                        hintText: tr('reading'),
                        textInputType: TextInputType.number,
                        onChange: (value) {
                          viewModel.reading['reading'] = int.parse(value);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<ReadingViewModel>(
                      builder: (context, viewModel, _) => CustomDropDown(
                        from: 'Reading',
                        isVisible: true,
                        selectedValue: viewModel.reading['readingType'],
                        hintText: tr('selectReadingType'),
                        options: [
                          tr('Random reading'),
                          tr('Fasting blood sugar (at least 8 hours)'),
                          tr('Tow hours after meals'),
                          tr('Before the meal'),
                          tr('Before exercise'),
                          tr('At bedtime'),
                          tr("After exercise")
                        ],
                        onChange: (value) {
                          Provider.of<ReadingViewModel>(context,
                                  listen: false)
                              .reading['readingType'] = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Consumer<ReadingViewModel>(
                  builder: (context, readingViewModel, _) => readingViewModel
                          .isLoading
                      ? Spinkit.spinKit()
                      : CustomElevatedButton(
                          onPressed: () async {
                            if (readingViewModel.reading['readingType'] !=
                                null) {
                              await readingViewModel.addNewReading(context);
                            }
                          },
                          width: double.infinity,
                          child: Text(
                            tr('submit'),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
