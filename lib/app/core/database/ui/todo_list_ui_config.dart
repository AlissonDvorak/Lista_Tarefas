import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';

class TodoListUiConfigLigth {
  TodoListUiConfigLigth._();
  static get theme => ThemeData(
        textTheme: GoogleFonts.mandaliTextTheme(),
        primaryColor: const Color(0xff5c77ce),
        primaryColorLight: const Color(
          0xffabc8f7,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: const Color(0xff5c77ce),
          ),
        ),
      );
}

class TodoListUiConfigDark {
  TodoListUiConfigDark._();
  static get theme => ThemeData(
        textTheme: GoogleFonts.mandaliTextTheme(),
        brightness: Brightness.dark,
        primaryColor: Colors.grey.shade900,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.white),
        ),
      );
}
