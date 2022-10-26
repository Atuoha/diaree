import "package:flutter/material.dart";

import '../../models/splash_item.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var currentSplashIndex = 0;
  
  final List<SplashItem> splashItems = [
    SplashItem(title: '', subtitle: subtitle, imgAsset: imgAsset)
  ];
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
