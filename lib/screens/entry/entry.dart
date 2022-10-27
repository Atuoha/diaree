import "package:flutter/material.dart";
import "package:flutter/services.dart";
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



  // TODO: Implement is_first_run fnc

  void _navigateToHomeOrAuth() {
    Timer(const Duration(seconds: 5), () {
      // TODO: Implement UserID Auth Check here
      // if(){
      //  Navigator.of(context).pushReplacementNamed("");
      // }else{
      //  Navigator.of(context).pushReplacementNamed("");
      // }

      Navigator.of(context).pushReplacementNamed("");
    });
  }

  void _navigateToOnBoarding() {
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(RouteManager.splashScreen);
    });
  }

  @override
  void initState() {
    super.initState();
    _navigateToOnBoarding();
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
