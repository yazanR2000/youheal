import 'package:flutter/material.dart';

class Constants {
  static const String baseUrl = "http://95.217.165.233:5000";
  // static const String baseUrl = "http://192.168.1.56:5000";
  static const int paginationLimit = 10;

  static List<Color> headerContainerColors = [
    const Color(0xff23B89A).withOpacity(0.5),
    const Color(0xff4565AF).withOpacity(0.5),
    // const Color(0xff6C538E).withOpacity(0.5),
    const Color(0xff9A4068).withOpacity(0.5),
    const Color(0xffBE304A).withOpacity(0.5),
    // const Color(0xffD72535).withOpacity(0.5),
    // const Color(0xffE71E28).withOpacity(0.6),
    // const Color(0xffED1C24).withOpacity(0.6),
  ];

  static const scaffoldBackgroundColor = Color(0xffF9F9F9);
}
