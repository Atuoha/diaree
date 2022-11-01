import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/resources/styles_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({
    Key? key,
    required this.profileDetails,
    required this.isPinSetBefore,
    required this.isProfileImageEmpty,
  }) : super(key: key);
  final DocumentSnapshot? profileDetails;
  final bool isPinSetBefore;
  final bool isProfileImageEmpty;

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isPinSyncing = false;
  final _formKey = GlobalKey<FormState>();
  final _firstPin = TextEditingController();
  final _secondPin = TextEditingController();
  final _thirdPin = TextEditingController();
  final _forthPin = TextEditingController();
  var currentPinIndex = 0;

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
      if (currentPinIndex < 3) currentPinIndex += 1;
    });
  }

  // add value to pin box
  void _removeValue() {
    switch (currentPinIndex) {
      case 0:
        _firstPin.text = "";
        break;

      case 1:
        _secondPin.text = "";
        break;
      case 2:
        _thirdPin.text = "";
        break;
      case 3:
        _forthPin.text = "";
        break;
    }
    setState(() {
      if (currentPinIndex > 0) currentPinIndex -= 1;
    });
  }

  // pin textfield
  Widget pinTextField(TextEditingController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: textBoxLite,
      ),
      child: TextFormField(
        autofocus: currentPinIndex == index ? true : false,
        enabled: false,
        controller: controller,
        textAlign: TextAlign.center,
        obscureText: true,
        obscuringCharacter: '•',
        style: getBoldStyle(
          color: Colors.black,
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
  TextButton inputButton(String text) {
    return TextButton(
      onPressed: () => _addValue(text, currentPinIndex),
      child: Text(
        text,
        style: getBoldStyle(
          color: Colors.black,
          fontSize: FontSize.s45,
        ),
      ),
    );
  }

  // input action
  TextButton inputAction(IconData icon, Function action) {
    return TextButton(
      onPressed: () => action(),
      child: Icon(
        icon,
        color: Colors.black,
        size: FontSize.s45,
      ),
    );
  }

  // finger print
  void _fingerPrint() {
    // Todo: Implement fingerprint
  }

  // save pin to firestore
  void _savePin() {
    // Todo Implement save pin
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.profileDetails!['fullname'];
    final usernameSplit = username.split(' ');

    return Scaffold(
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
              widget.isProfileImageEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(AssetManager.avatarBig),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.profileDetails!['avatar'],
                        width: 100,
                      ),
                    ),
              const SizedBox(height: 10),
              Text(
                'Welcome, ${usernameSplit[1]}',
                style: getMediumStyle(
                  color: Colors.black,
                  fontSize: FontSize.s30,
                ),
              ),
              widget.isPinSetBefore
                  ? Text(
                      'Please enter your passcode',
                      style: getRegularStyle(color: Colors.black),
                    )
                  : Text(
                      'Enter default password: 0000',
                      style: getRegularStyle(color: Colors.black),
                    ),
              const SizedBox(height: 13),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pinTextField(_firstPin, 0),
                    pinTextField(_secondPin, 1),
                    pinTextField(_thirdPin, 2),
                    pinTextField(_forthPin, 3),
                  ],
                ),
              ),
              Expanded(
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                  ),
                  children: [
                    inputButton('1'),
                    inputButton('2'),
                    inputButton('3'),
                    inputButton('4'),
                    inputButton('5'),
                    inputButton('6'),
                    inputButton('7'),
                    inputButton('8'),
                    inputButton('9'),
                    inputAction(Icons.fingerprint, _fingerPrint),
                    inputButton('0'),
                    inputAction(Icons.cancel_presentation, _removeValue),
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
