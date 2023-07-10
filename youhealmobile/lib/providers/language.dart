import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Future changeLang({required Locale lang,required BuildContext context}) async {
    final prefrences = await SharedPreferences.getInstance();
    await prefrences.setString('youhealLang', lang.toString(),);
    // ignore: use_build_context_synchronously
    await context.setLocale(lang);
    notifyListeners();
  }
}