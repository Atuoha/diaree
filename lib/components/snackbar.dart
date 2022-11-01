// snackbar for error message
import 'package:flutter/material.dart';
import '../constants/color.dart';

void showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor,
    ),
  );
}