import 'package:diaree/resources/route_manager.dart';
import 'package:diaree/screens/authentication/auth.dart';
import "package:flutter/material.dart";
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';

class AuthAcknowledgementScreen extends StatelessWidget {
  const AuthAcknowledgementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(AssetManager.success),
              // const SizedBox(height: AppSize.s10),

              Text(
                'Great You\'ve successfully created an account.',
                textAlign: TextAlign.center,
                style: getHeadingStyle(fontSize: FontSize.s45),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 8,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushNamed(RouteManager.authScreen),
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
