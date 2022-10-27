import 'package:diaree/resources/route_manager.dart';
import 'package:diaree/resources/theme_manager.dart';
import 'package:diaree/screens/entry/entry.dart';
import "package:flutter/material.dart";

void main() => runApp(const Diaree());

class Diaree extends StatelessWidget {
  const Diaree({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getAppTheme(),
      debugShowCheckedModeBanner: false,
      home: const EntryScreen(),
      routes: routes,
    );
  }
}
