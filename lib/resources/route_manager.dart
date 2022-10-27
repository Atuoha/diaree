import 'package:diaree/screens/main/welcome.dart';
import 'package:diaree/screens/splash/splash.dart';
import "package:flutter/material.dart";

class RouteManager {
  static const String splashScreen = "/splash";
  static const String welcomeScreen = "/welcome";
}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
  RouteManager.welcomeScreen:(context)=> const WelcomeScreen(),
};
