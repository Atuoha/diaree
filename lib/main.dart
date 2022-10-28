import 'package:diaree/resources/route_manager.dart';
import 'package:diaree/resources/theme_manager.dart';
import 'package:diaree/screens/splash/entry.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Diaree());
}

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
