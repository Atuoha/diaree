import 'package:diaree/resources/styles_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/snackbar.dart';
import '../../constants/color.dart';
import '../../providers/settings.dart';
import '../../resources/font_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/values_manager.dart';

class PinUnlockScreen extends StatefulWidget {
  const PinUnlockScreen({
    Key? key,
    required this.userPin,
  }) : super(key: key);
  final String userPin;

  @override
  State<PinUnlockScreen> createState() => _PinUnlockScreenState();
}

class _PinUnlockScreenState extends State<PinUnlockScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isPinSyncing = false;
  final _firstPin = TextEditingController();
  final _secondPin = TextEditingController();
  final _thirdPin = TextEditingController();
  final _forthPin = TextEditingController();
  var currentPinIndex = 0;
  bool isPinInCorrect = false;

  // add value to pin box
  void _addValue(String value, int index) {
    switch (index) {
      case 0:
        _firstPin.text = value;
        break;

      case 1:
        _secondPin.text = value;
        break;
      case 2:
        _thirdPin.text = value;
        break;
      case 3:
        _forthPin.text = value;
        break;
    }
    setState(() {
      if (currentPinIndex <= 4) currentPinIndex += 1;
    });
  }

  // add value to pin box
  void _removeValue() {
    switch (currentPinIndex) {
      case 1:
        _firstPin.text = "";
        break;

      case 2:
        _secondPin.text = "";
        break;
      case 3:
        _thirdPin.text = "";
        break;
      case 4:
        _forthPin.text = "";
        break;
    }
    setState(() {
      if (currentPinIndex > 0) currentPinIndex -= 1;
    });
  }

  // pin textfield
  Widget pinTextField(
    TextEditingController controller,
    int index,
    Color color,
    Color textBoxColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: textBoxColor,
      ),
      child: TextFormField(
        autofocus: currentPinIndex == index ? true : false,
        enabled: false,
        controller: controller,
        textAlign: TextAlign.center,
        obscureText: true,
        obscuringCharacter: '•',
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.s30,
        ),
        decoration: const InputDecoration(
          filled: false,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // input button
  TextButton inputButton(String text, Color color) {
    return TextButton(
      onPressed: () =>
          currentPinIndex != 4 ? _addValue(text, currentPinIndex) : null,
      child: Text(
        text,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.s45,
        ),
      ),
    );
  }

  // input action
  TextButton inputAction(IconData icon, Function action, Color color) {
    return TextButton(
      onPressed: () => action(),
      child: Icon(
        icon,
        color: color,
        size: FontSize.s45,
      ),
    );
  }

  //finger print fnc
  void _fingerPrintHandler() {
    //Todo: Implement finger print handler
  }

  // finger print
  void _fingerPrint(Color color) {
    // Todo: Implement fingerprint
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Use fingerprint',
              style: getBoldStyle(
                color: color,
                fontSize: FontSize.s16,
              ),
            ),
            Text('Touch the fingerprint sensor',
                style: TextStyle(color: color)),
            const SizedBox(height: 15),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _fingerPrintHandler(),
              icon: const Icon(
                Icons.fingerprint,
                color: primaryColor,
                size: AppSize.s100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // reset pin setup
  void _resetPinSetup() {
    setState(() {
      currentPinIndex = 0;
      _firstPin.text = "";
      _secondPin.text = "";
      _thirdPin.text = "";
      _forthPin.text = "";
    });
  }

  // authenticate pin
  void _pinAuthenticateHandler() {
    setState(() {
      isPinSyncing = true;
    });
    var newPinEntry =
        _firstPin.text + _secondPin.text + _thirdPin.text + _forthPin.text;

    if (_firstPin.text.isEmpty ||
        _secondPin.text.isEmpty ||
        _thirdPin.text.isEmpty ||
        _forthPin.text.isEmpty) {
      showSnackBar('4 Pin digits are  needed! Retry', context);
      setState(() {
        isPinSyncing = false;
      });
    } else {
      if (widget.userPin != newPinEntry) {
        showSnackBar('Incorrect pin!. Try again', context);
        setState(() {
          isPinInCorrect = true;
          isPinSyncing = false;
        });
        _resetPinSetup();
      } else {
        Navigator.of(context).pushReplacementNamed(RouteManager.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _pinAuthenticateHandler(),
        child: isPinSyncing
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.check,
                color: Colors.white,
                size: AppSize.s35,
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                 Icon(Icons.lock, size: AppSize.s30, color: theme.getThemeColor,),
                const SizedBox(width: 10),
                Text(
                  'Enter Unlock Pin',
                  style: getMediumStyle(
                    color: theme.getThemeColor,
                    fontSize: FontSize.s30,
                  ),
                ),
              ]),
              isPinInCorrect
                  ? Text(
                      'You\'ve entered an incorrect pin. Try again!',
                      style: getRegularStyle(color: accentColor),
                    )
                  : Text(
                      'Please enter your pin to unlock',
                      style: getRegularStyle(color: theme.getThemeColor),
                    ),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pinTextField(
                    _firstPin,
                    0,
                    theme.getThemeColor,
                    theme.getTextFieldColor,
                  ),
                  pinTextField(
                    _secondPin,
                    1,
                    theme.getThemeColor,
                    theme.getTextFieldColor,
                  ),
                  pinTextField(
                    _thirdPin,
                    2,
                    theme.getThemeColor,
                    theme.getTextFieldColor,
                  ),
                  pinTextField(
                    _forthPin,
                    3,
                    theme.getThemeColor,
                    theme.getTextFieldColor,
                  ),
                ],
              ),
              Expanded(
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                  ),
                  children: [
                    inputButton('1', theme.getThemeColor),
                    inputButton('2', theme.getThemeColor),
                    inputButton('3', theme.getThemeColor),
                    inputButton('4', theme.getThemeColor),
                    inputButton('5', theme.getThemeColor),
                    inputButton('6', theme.getThemeColor),
                    inputButton('7', theme.getThemeColor),
                    inputButton('8', theme.getThemeColor),
                    inputButton('9', theme.getThemeColor),
                    inputAction(
                        Icons.fingerprint, _fingerPrint, theme.getThemeColor),
                    inputButton('0', theme.getThemeColor),
                    inputAction(
                      Icons.cancel_presentation,
                      _removeValue,
                      theme.getThemeColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
