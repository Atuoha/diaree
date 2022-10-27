import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/color.dart';
import 'styles_manager.dart';
import 'values_manager.dart';
import 'font_manager.dart';

ThemeData getAppTheme() {
  return ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: primaryColor,
    primaryColorDark: Colors.black,
    disabledColor: backgroundLite,

    // card theme
    cardTheme: const CardTheme(
      color: cardsLite,
      shadowColor: Colors.grey,
      elevation: AppSize.s4,
    ),

    // button theme
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      shape: StadiumBorder(),
      disabledColor: backgroundLite,
    ),

    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        backgroundColor: primaryColor,
        textStyle: getRegularStyle(
          color: Colors.white,
          fontSize: FontSize.s16,
          fontWeight: FontWeightManager.bold,
        ),
      ),
    ),

    // input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: AppSize.s2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: AppSize.s2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: AppSize.s2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: AppSize.s2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.s8),
        borderSide: const BorderSide(
          color: primaryColor,
          width: AppSize.s2,
        ),
      ),
      labelStyle: getMediumStyle(color: Colors.black),
      hintStyle: getRegularStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      errorStyle: getRegularStyle(color: Colors.red),
      suffixIconColor: primaryColor,
      suffixStyle: getRegularStyle(color: Colors.grey),
      prefixIconColor: primaryColor,
      prefixStyle: getRegularStyle(color: Colors.grey),
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: AppSize.s4,
      centerTitle: true,
      titleTextStyle: getRegularStyle(
        color: Colors.black,
        fontSize: FontSize.s16,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    ),

    // text theme
    textTheme: TextTheme(
      headline1: getSemiBoldStyle(
        color: Colors.black,
        fontSize: FontSize.s16,
      ),
      caption: getRegularStyle(
        color: Colors.black,
        fontSize: FontSize.s12,
      ),
      bodyText1: getRegularStyle(
        color: Colors.black,
      ),
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.grey,
    ),
  );
}
