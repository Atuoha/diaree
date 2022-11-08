import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/resources/styles_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/snackbar.dart';
import '../../constants/color.dart';
import '../../providers/settings.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../../resources/route_manager.dart';

class PinConfirmScreen extends StatefulWidget {
  const PinConfirmScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PinConfirmScreen> createState() => _PinConfirmScreenState();
}

class _PinConfirmScreenState extends State<PinConfirmScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isPinSyncing = false;
  final _firstPin = TextEditingController();
  final _secondPin = TextEditingController();
  final _thirdPin = TextEditingController();
  final _forthPin = TextEditingController();
  var currentPinIndex = 0;
  bool isPinInCorrect = false;
  var previousEnteredPin = "";
  var newPinEntry = "";
  bool isConfirmPinSection = false;

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
  TextButton inputAction(IconData icon, Function action, Color color,) {
    return TextButton(
      onPressed: () => action(),
      child: Icon(
        icon,
        color: color,
        size: FontSize.s45,
      ),
    );
  }

  // finger print
  void _fingerPrint() {
    // Todo: Implement fingerprint
  }

  // reset pin setup
  void _resetPinSetup() {
    setState(() {
      currentPinIndex = 0;
      _firstPin.text = "";
      _secondPin.text = "";
      _thirdPin.text = "";
      _forthPin.text = "";
      isConfirmPinSection = false;
    });
  }

  // migrate to pin confirm
  void _pinConfirmMigration() {
    setState(() {
      currentPinIndex = 0;
      isPinSyncing = false;
      isConfirmPinSection = true;
      previousEnteredPin =
          _firstPin.text + _secondPin.text + _thirdPin.text + _forthPin.text;
      _firstPin.text = "";
      _secondPin.text = "";
      _thirdPin.text = "";
      _forthPin.text = "";
    });
  }

  // save pin to firestore
  void _savePin() {
    // Todo Implement save pin
    setState(() {
      isPinSyncing = true;
    });
    if (_firstPin.text.isEmpty ||
        _secondPin.text.isEmpty ||
        _thirdPin.text.isEmpty ||
        _forthPin.text.isEmpty) {
      showSnackBar('4 Pin digits are  needed!', context);
      setState(() {
        isPinSyncing = false;
      });
    } else {
      if (isConfirmPinSection) {
        // the previous pin has been entered
        setState(() {
          newPinEntry = _firstPin.text +
              _secondPin.text +
              _thirdPin.text +
              _forthPin.text;
        });

        // previous pin and new pin does not match
        if (previousEnteredPin != newPinEntry) {
          showSnackBar('Pin Does not match. Try again!', context,);
          setState(() {
            isPinInCorrect = true;
            isPinSyncing = false;
          });
          print(newPinEntry);
          print(previousEnteredPin);
          _resetPinSetup();
        } else {
          // send to firebase
          try {
            FirebaseFirestore.instance.collection('users').doc(userId).update({
              'pin': newPinEntry,
            });
            Navigator.of(context)
                .pushReplacementNamed(RouteManager.pinSuccessScreen);
          } on FirebaseException catch (e) {
            showSnackBar('Error occurred! ${e.message}', context);
          } catch (e) {
            if (kDebugMode) {
              print('An error occurred! $e');
            }
          }
        }
        //
      } else {
        // migrating to pin confirmation -first time pin entry
        _pinConfirmMigration();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.only(left: 18),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        title: Text(
          'Create PIN',
          style: getRegularStyle(
            color: theme.getThemeColor,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _savePin(),
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
              Text(
                !isConfirmPinSection
                    ? 'Create a new pin'
                    : 'Re-enter your new Pin',
                style: getMediumStyle(
                  color: theme.getThemeColor,
                  fontSize: FontSize.s30,
                ),
              ),
              isPinInCorrect
                  ? Text(
                      'Pin Does not match. Try again!',
                      style: getRegularStyle(color: accentColor),
                    )
                  : Text(
                      !isConfirmPinSection
                          ? 'Please enter your passcode'
                          : 'Please enter your password again',
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
                      Icons.fingerprint,
                      _fingerPrint,
                      theme.getThemeColor,
                    ),
                    inputButton(
                      '0',
                      theme.getThemeColor,
                    ),
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
