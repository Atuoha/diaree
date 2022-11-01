import 'package:diaree/screens/authentication/auth.dart';
import 'package:diaree/screens/main/notes/create.dart';
import 'package:diaree/screens/main/notes/edit.dart';
import 'package:diaree/screens/main/notes/view.dart';
import 'package:diaree/screens/main/welcome.dart';
import 'package:diaree/screens/splash/splash.dart';
import "package:flutter/material.dart";

import '../screens/authentication/forgot_password.dart';
import '../screens/authentication/signup_acknowledge.dart';
import '../screens/main/home_screen.dart';
import '../screens/main/pin_confirm.dart';
import '../screens/main/pin_setup.dart';
import '../screens/main/settings_screen.dart';

class RouteManager {
  static const String splashScreen = "/splash";
  static const String welcomeScreen = "/welcome";
  static const String authScreen = "/auth";
  static const String forgotPasswordScreen = "/forgotPasswordScreen";
  static const String signupAcknowledgeScreen = "/signupAcknowledge";
  static const String homeScreen = '/homeScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String viewNoteScreen = '/viewNote';
  static const String createNoteScreen = '/createNote';
  static const String editNoteScreen = '/editNote';
  static const String pinSetup = '/pinSetup';
  static const String pinConfirmScreen = '/pinConfirm';

}

final routes = {
  RouteManager.splashScreen: (context) => const SplashScreen(),
  RouteManager.welcomeScreen: (context) => const WelcomeScreen(),
  RouteManager.authScreen: (context) => AuthenticationScreen(),
  RouteManager.forgotPasswordScreen: (context) =>
      const ForgottenPasswordScreen(),
  RouteManager.signupAcknowledgeScreen: (context) =>
      const AuthAcknowledgementScreen(),
  RouteManager.homeScreen: (context) => const HomeScreen(),
  RouteManager.viewNoteScreen: (context) => const ViewNoteScreen(),
  RouteManager.createNoteScreen: (context) => const CreateNoteScreen(),
  RouteManager.editNoteScreen: (context) => const EditNoteScreen(),
  RouteManager.settingsScreen: (context) => const SettingsScreen(),
  RouteManager.pinConfirmScreen: (context) => const PinConfirmScreen(),

};
