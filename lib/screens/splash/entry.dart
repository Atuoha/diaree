import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:is_first_run/is_first_run.dart';
import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import "dart:async";

import '../../resources/route_manager.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  var user = FirebaseAuth.instance.currentUser;

  _startRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    var duration = const Duration(seconds: 3);
    if (ifr != null && !ifr) {
      Timer(duration, _navigateToHomeOrAuth);
    } else {
      Timer(duration, _navigateToOnBoarding);
    }
  }

  void _navigateToHomeOrAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed(RouteManager.homeScreen);
      } else {
        Navigator.of(context).pushReplacementNamed(RouteManager.authScreen);
      }
    });
  }

  void _navigateToOnBoarding() {
    Navigator.of(context).pushReplacementNamed(RouteManager.splashScreen);
  }

  @override
  void initState() {
    super.initState();
    _startRun();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryOpacity,
      ),
    );
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset(AssetManager.logo),
      ),
    );
  }
}
