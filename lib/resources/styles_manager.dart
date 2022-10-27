import 'package:flutter/material.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
  double fontSize,
  String fontFamily,
  Color color,
  FontWeight fontWeight,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: color,
    fontWeight: fontWeight,
  );
}

// regular fontstyle
TextStyle getRegularStyle(
    {fontSize = FontSize.s12,
    required Color color,
    fontWeight = FontWeightManager.normal,}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    color,
    fontWeight,
  );
}

// light fontstyle
TextStyle getLightStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    color,
    FontWeightManager.light,
  );
}

// bold fontstyle
TextStyle getBoldStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    color,
    FontWeightManager.bold,
  );
}

// semi-bold fontstyle
TextStyle getSemiBoldStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    color,
    FontWeightManager.semiBold,
  );
}

// medium fontstyle
TextStyle getMediumStyle({
  fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
    fontSize,
    FontConstants.fontFamily,
    color,
    FontWeightManager.medium,
  );
}
