import 'package:flutter/material.dart';

ThemeData buildTheme() {

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline: base.headline.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 40.0,
        color: const Color(0xFF2D91EB),
      ),
      title: base.title.copyWith(
        fontFamily: 'Merriweather',
        fontSize: 15.0,
        color: const Color(0xFF807A6B),
      ),
      caption: base.caption.copyWith(
        color: const Color(0xFFCCC5AF),
      ),
    );
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    appBarTheme: AppBarTheme(
      color: Colors.white,
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black
        )
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.black38
      ),
      iconTheme: IconThemeData(
        color: Colors.black38
      )
    ),
    textTheme: _buildTextTheme(base.textTheme),
    //primaryColor: const Color(0xFF2D91EB),
    primaryColor: Color(0xFF2D91EB),
    indicatorColor: const Color(0xFF807A6B),
    //scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFF2D91EB),
    iconTheme: IconThemeData(
      color: const Color(0xFFCCC5AF),
      size: 20.0,
    ),
  );
}