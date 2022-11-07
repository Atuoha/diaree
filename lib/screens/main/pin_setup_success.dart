import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../providers/settings.dart';
import '../../resources/assets_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class PinSetupSuccessScreen extends StatelessWidget {
  const PinSetupSuccessScreen({super.key,});


  @override
  Widget build(BuildContext context) {
    // navigate to main screen
    void navigateToMainScreen() {
      Navigator.of(context).pushReplacementNamed(RouteManager.settingsScreen);
    }
    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetManager.success2),
              const SizedBox(height: AppSize.s35),
              Text(
                'You\'ve successfully set a new pin.',
                textAlign: TextAlign.center,
                style: getHeadingStyle2(color: theme.getThemeColor),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        padding: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.bottomCenter,
        color:theme.getThemeBackgroundColor,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 60,
              vertical: 8,
            ),
          ),
          onPressed: () => navigateToMainScreen(),
          child: const Text('Go back to settings'),
        ),
      ),
    );
  }
}
