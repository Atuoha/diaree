import 'package:diaree/screens/authentication/auth.dart';
import 'package:diaree/screens/main/welcome.dart';
import 'package:diaree/screens/splash/splash.dart';
import "package:flutter/material.dart";

import '../screens/authentication/forgot_password.dart';
import '../screens/authentication/signup_acknowledge.dart';
import '../screens/main/home_screen.dart';

class RouteManager {
  static const String splashScreen = "/splash";
  static const String welcomeScreen = "/welcome";
  static const String authScreen = "/auth";
  static const String forgotPasswordScreen = "/forgotPasswordScreen";
  static const String signupAcknowledgeScreen = "/signupAcknowledge";
  static const String homeScreen = '/homeScreen';
}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
  RouteManager.welcomeScreen: (context) => const WelcomeScreen(),
  RouteManager.authScreen: (context) => AuthenticationScreen(),
  RouteManager.forgotPasswordScreen: (context) =>
      const ForgottenPasswordScreen(),
  RouteManager.signupAcknowledgeScreen: (context) =>
      const AuthAcknowledgementScreen(),
  RouteManager.homeScreen: (context) => const HomeScreen()
};
