import 'package:diaree/screens/splash/splash.dart';
import "package:flutter/material.dart";

class RouteManager {
  static const String splashScreen = "/splash";
}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
};
