import 'package:diaree/providers/settings.dart';
import 'package:diaree/resources/route_manager.dart';
import 'package:diaree/resources/theme_manager.dart';
import 'package:diaree/screens/splash/entry.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences.getInstance().then((prefs) {
    var isDark = prefs.getBool('isDark') ?? false;
    runApp(
      ChangeNotifierProvider(
        create: (_) => SettingsData(isDark ? getDarkTheme() : getLightTheme()),
        child: const Diaree(),
      ),
    );
  });
}

class Diaree extends StatelessWidget {
  const Diaree({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SettingsData>(context);
    return MaterialApp(
      theme: theme.getThemeData(),
      debugShowCheckedModeBanner: false,
      home: const EntryScreen(),
      routes: routes,
    );
  }
}
