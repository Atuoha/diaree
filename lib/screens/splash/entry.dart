import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/screens/authentication/pin_unlock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:is_first_run/is_first_run.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/color.dart';
import '../../providers/settings.dart';
import '../../resources/assets_manager.dart';
import "dart:async";
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/route_manager.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  var user = FirebaseAuth.instance.currentUser;
  bool isPinSet = false;
  var userPin = "";

  void _getIsPinSet() {
    SharedPreferences.getInstance().then((prefs) {
      var isLocked = prefs.getBool('isLocked') ?? false;

      if (isLocked) {
        setState(() {
          isPinSet = true;
        });
      }
    });
  }

  // load profile details
  Future<void> _loadProfileDetails() async {
    var details = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      userPin = details['pin'];
    });

    // if(details['pin_lock'] == true){
    //   setState(() {
    //     isPinSet = true;
    //   });
    // }
  }

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
      // checking if user is logged in
      if (user != null) {
        // checking if pin unlock is set
        if (isPinSet) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PinUnlockScreen(
                userPin: userPin,
              ),
            ),
          );
        } else {
          Navigator.of(context).pushReplacementNamed(RouteManager.homeScreen);
        }
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
    _loadProfileDetails();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getIsPinSet();
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
