import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../components/loading.dart';
import '../../constants/color.dart';
import '../../providers/settings.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/styles_manager.dart';
import 'dart:async';

// ignore: must_be_immutable
class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgottenPasswordScreen> createState() =>
      _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool isButtonDisabled = true;
  bool isLoading = false;

  // navigate to signin
  void _navigateToSignin() {
    Navigator.of(context).pushNamed(RouteManager.authScreen);
  }

  // check entries for button disability
  void checkEntries() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isButtonDisabled = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    _emailController.addListener(() {
      checkEntries();
    });
    super.didChangeDependencies();
  }

  // loading
  void loadingFnc() {
    setState(() {
      isLoading = true;
    });

    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed(RouteManager.authScreen);
    });
  }

  // submit
  void _submit() {
    FocusScope.of(context).unfocus();
    var valid = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (!valid) return;

    //TODO: Implement forgotPassword
    loadingFnc();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(AssetManager.logoRed),
                // const SizedBox(height: AppSize.s10),
                Column(
                  children: [
                    Text(
                      'Forgot Password!',
                      textAlign: TextAlign.center,
                      style: getHeadingStyle(
                          fontSize: FontSize.s30, color: theme.getThemeColor),
                    ),
                    const SizedBox(height: 40),
                    !isLoading
                        ? Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: TextStyle(color: theme.getThemeColor),
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains("@")) {
                                      return "Email Address is not valid!";
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "ujunwa0001@gmail.com",
                                    label: Text("Email Address"),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 74,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed:
                                      isButtonDisabled ? null : () => _submit(),
                                  child: const Text(
                                    'Submit Request',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () => _navigateToSignin(),
                                      child: const Text(
                                        'Remembered Password? Signin',
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : const Loading()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
