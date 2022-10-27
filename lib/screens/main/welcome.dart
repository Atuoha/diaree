import "package:flutter/material.dart";
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // navigate to registration
  void _navigateToSignup() {
    // Todo: Implement Navigate to signup
  }

  // navigate to sign in
  void _navigateToSignin() {
    // Todo: Implement Navigate to signin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 30),
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
                    style: getHeadingStyle(fontSize: FontSize.s45),
                  ),
                  Text(
                    'Sign in to enable backup and syncing\n for all your diary entries',
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical:8),
                    ),
                    onPressed: () => _navigateToSignin(),
                    child: const Text('Create Account'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 74, vertical: 8),
                    ),
                    onPressed: () => _navigateToSignin(),
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(height:5),
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
