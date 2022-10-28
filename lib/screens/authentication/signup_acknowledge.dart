import 'package:diaree/resources/route_manager.dart';
import 'package:diaree/screens/authentication/auth.dart';
import "package:flutter/material.dart";
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class AuthAcknowledgementScreen extends StatelessWidget {
  const AuthAcknowledgementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetManager.success),
              const SizedBox(height: AppSize.s35),

              Text(
                'Great! You\'ve \nsuccessfully created an account.',
                textAlign: TextAlign.center,
                style: getHeadingStyle2(),
              ),

            ],
          ),
        ),
      ),
      bottomSheet:  Container(
        height:60,
        padding: const EdgeInsets.only(bottom:10),
        alignment: Alignment.bottomCenter,
        child:
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 8,
            ),
          ),
          onPressed: () => Navigator.of(context).pushNamed(""),
          child: const Text('Jump in'),
        ),

      ),
    );
  }
}
