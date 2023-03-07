import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color irisColor = Color.fromRGBO(93, 63, 211, 1); // for selected day
// ================ Three Colors for Tasks =======================
const Color amethystColor = Color.fromRGBO(153, 102, 203, 1);
const Color lilacColor = Color.fromRGBO(182, 96, 205, 1);
const Color irisTaskColor = Color.fromRGBO(93, 63, 211, 0.8);
// ================================================================
const primaryClr = irisColor;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
// =================== Light Mode Theme ======================
  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(background: Colors.white),
    primaryColor: primaryClr,
    brightness: Brightness.light,
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

// =================== Dark Mode Theme ======================
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: darkGreyClr,
    colorScheme: const ColorScheme.dark(background: darkGreyClr),
    brightness: Brightness.dark,
    bottomAppBarTheme: const BottomAppBarTheme(color: darkGreyClr),
  );
}

// =================== Fonts ======================
TextStyle get haedingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subHaedingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

TextStyle get bodyStyle3 {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
  );
}

TextStyle get body2Style {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
    ),
  );
}
