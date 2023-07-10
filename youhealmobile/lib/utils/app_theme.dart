import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    primaryColor: const Color(0xff27A5A3),
    scaffoldBackgroundColor: const Color(0xffF9F9F9),
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
      centerTitle: true,
      backgroundColor: const Color(0xff29AC98).withOpacity(0.35),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: const TextStyle(fontFamily: 'Raleway-Bold', fontSize: 16),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all<Color>(
        const Color(0xff19769F),
      ),
    ),
    listTileTheme: ListTileThemeData(
        iconColor: const Color(0xff27A5A3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Colors.grey.shade50),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: const Color(0xff4565AF),
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
        side: const BorderSide(
          color: Color(0xff4565AF),
          width: 2.0,
        ),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          color: Color(0xff95989A),
          fontSize: 13,
          fontWeight: FontWeight.bold
          //fontFamily: 'Poppins-SemiBold'
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const StadiumBorder(),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: Color(0xff19769F), fontSize: 20, fontWeight: FontWeight.w600
          //fontFamily: 'Poppins-SemiBold'
          ),
      titleMedium: TextStyle(
        color: Color(0xff95989A),
        fontSize: 14,
        //fontFamily: 'Poppins-SemiBold'
      ),
      titleSmall: TextStyle(
        color: Color(0xff95989A),
        fontSize: 13,
        //fontFamily: 'Poppins-SemiBold'
      ),
    ),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder()
      },
    ),
  );
}
