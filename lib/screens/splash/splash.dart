import 'package:diaree/resources/route_manager.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../constants/color.dart';
import '../../models/splash_item.dart';
import '../../providers/settings.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/string_manager.dart';
import '../../resources/styles_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String routeName = "/splash";
  var currentSplashIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  // go to next splash item
  void _goToNext() {
    var page = currentSplashIndex + 1;
    _pageController.animateToPage(
      page,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  // skip splash
  void _skipSplash() {
    var page = splashItems.length - 1;
    _pageController.animateToPage(
      page,
      duration: const Duration(seconds: 2),
      curve: Curves.easeIn,
    );
  }

  // navigate to main screen
  void _navigateToMain() {
    Navigator.of(context).pushReplacementNamed(RouteManager.welcomeScreen);
  }

  Widget kSplashPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.all(2),
      width: 50,
      decoration: BoxDecoration(
        color: currentSplashIndex == index ? primaryColor : greyShade,
      ),
    );
  }

  final List<SplashItem> splashItems = [
    SplashItem(
      title: AppString.splashTitle1,
      subtitle: AppString.splashSubtitle1,
      imgAsset: AssetManager.splashImage1,
    ),
    SplashItem(
      title: AppString.splashTitle2,
      subtitle: AppString.splashSubtitle2,
      imgAsset: AssetManager.splashImage2,
    ),
    SplashItem(
      title: AppString.splashTitle3,
      subtitle: AppString.splashSubtitle3,
      imgAsset: AssetManager.splashImage3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              currentSplashIndex = value;
            });
          },
          itemCount: splashItems.length,
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(splashItems[currentSplashIndex].imgAsset),
              const SizedBox(height: 10),
              SizedBox(
                height: 6,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: splashItems.length,
                  itemBuilder: (context, index) => kSplashPageIndicator(index),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                splashItems[currentSplashIndex].title,
                style: getHeadingStyle(color:theme.getThemeColor)
              ),
              const SizedBox(height: 10),
              Text(
                splashItems[currentSplashIndex].subtitle,
                style: getRegularStyle(
                  color: theme.getThemeColor,
                  fontWeight: FontWeightManager.normal,
                  fontSize: FontSize.s13,
                ),
              ),
              const SizedBox(height: 20),
              currentSplashIndex != splashItems.length - 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => _skipSplash(),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                          ),
                          onPressed: () => _goToNext(),
                          child: const Text('Next'),
                        )
                      ],
                    )
                  : Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                        ),
                        onPressed: () => _navigateToMain(),
                        child: const Text('Let\'s Go!'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
