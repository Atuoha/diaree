import 'package:diaree/resources/route_manager.dart';
import 'package:diaree/screens/authentication/auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../providers/settings.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // navigate to registration
  void _navigateToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthenticationScreen(isSignin: false),
      ),
    );
  }

  // navigate to sign in
  void _navigateToSignin() {
    Navigator.of(context).pushReplacementNamed(RouteManager.authScreen);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(AssetManager.logoRed),
              // const SizedBox(height: AppSize.s10),
              Column(
                children: [
                  Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: getHeadingStyle(fontSize: FontSize.s45,color:theme.getThemeColor),
                  ),
                  Text(
                    'Sign in to enable backup and syncing\n for all your diary entries',
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: theme.getThemeColor,
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8),
                    ),
                    onPressed: () => _navigateToSignup(),
                    child: const Text('Create Account'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 74, vertical: 8),
                    ),
                    onPressed: () => _navigateToSignin(),
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Continue without signing up',
                    style: getRegularStyle(
                      color: Colors.black,
                      fontSize: FontSize.s10,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
