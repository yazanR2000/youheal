import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youhealmobile/components/custom_scaffold.dart';

import '../../restart_app.dart';



class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  Future _changeLang(Locale lang, BuildContext context) async {
    await context.setLocale(lang);
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setString('youhealLang', lang.toString());
    RestartApp.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return CustomScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.15),
        child: Column(
          children: [
            RadioListTile(
              value: const Locale('en', 'US'),
              groupValue: EasyLocalization.of(context)!.currentLocale,
              onChanged: (value) async {
                await _changeLang(const Locale('en', 'US'), context);
              },
              title: Text(
                tr("en"),
              ),
            ),
            RadioListTile(
              value: const Locale('ar', 'EG'),
              groupValue: EasyLocalization.of(context)!.currentLocale,
              onChanged: (value) async {
                await _changeLang(const Locale('ar', 'EG'), context);
              },
              title: Text(
                tr("ar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
