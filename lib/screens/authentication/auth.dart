import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

import '../../components/loading.dart';
import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/route_manager.dart';
import '../../resources/styles_manager.dart';

// ignore: must_be_immutable
class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({
    Key? key,
    this.isSignin = true,
  }) : super(key: key);
  bool isSignin;

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

enum Field {
  name,
  email,
  password,
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;
  bool isButtonDisabled = true;
  bool isLoading = false;

  final firebase = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // toggle auth
  void _toggleAuth() {
    setState(() {
      widget.isSignin = !widget.isSignin;
    });
  }

  // navigate to forgotten password
  void _navigateToForgottenPassword() {
    Navigator.of(context).pushNamed(RouteManager.forgotPasswordScreen);
  }

  @override
  void initState() {
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  // check entries for button disability
  void checkEntries() {
    if (widget.isSignin) {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        setState(() {
          isButtonDisabled = false;
        });
      }
    } else if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _nameController.text.isNotEmpty) {
      setState(() {
        isButtonDisabled = false;
      });
    } else {
      setState(() {
        isButtonDisabled = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    _emailController.addListener(() {
      checkEntries();
    });
    _passwordController.addListener(() {
      checkEntries();
    });
    _nameController.addListener(() {
      checkEntries();
    });
    super.didChangeDependencies();
  }

  Widget kTextField(
    String hint,
    String label,
    Field field,
    TextEditingController controller,
    bool obscureValue,
    bool isObscured,
  ) {
    return TextFormField(
      obscureText: obscureValue,
      controller: controller,
      textInputAction:
          field == Field.password ? TextInputAction.done : TextInputAction.next,
      keyboardType: field == Field.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      validator: (value) {
        switch (field) {
          case Field.name:
            if (value!.isEmpty || value.length < 3) {
              return "Name is not valid!";
            }
            break;

          case Field.email:
            if (value!.isEmpty || !value.contains("@")) {
              return "Email Address is not valid!";
            }
            break;

          case Field.password:
            if (value!.isEmpty || value.length < 8) {
              return "Password is not valid!";
            }
            break;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        label: Text(label),
        suffixIcon: isObscured
            ? _passwordController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () => setState(() {
                      isObscure = !isObscure;
                    }),
                    child: Icon(
                      obscureValue ? Icons.visibility : Icons.visibility_off,
                      color: obscureValue ? greyShade : primaryColor,
                    ),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
      ),
    );
  }

  // loading
  void loadingFnc() {
    setState(() {
      isLoading = true;
    });

    Timer(const Duration(seconds: 4), () {
      if (widget.isSignin) {
        // TODO: Home screen routeName
        Navigator.of(context).pushReplacementNamed("");
      }
      Navigator.of(context)
          .pushReplacementNamed(RouteManager.signupAcknowledgeScreen);
    });
  }

  // authenticate
  void _authenticate() {
    FocusScope.of(context).unfocus();
    var valid = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (!valid) return;

    if (widget.isSignin) {
      // authenticate signin
      firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      loadingFnc();
    } else {
      // authenticate signup
      firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      firebase.collection("users").doc().set({
        "Username": _nameController.text.trim(),
        "Email": _emailController.text.trim(),
        "Avatar": "None",
        "Pin": ""
      });
      loadingFnc();
    }
  }

  // authenticate using google
  void _googleAuthenticate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      widget.isSignin ? 'Signin!' : 'Signup!',
                      textAlign: TextAlign.center,
                      style: getHeadingStyle(fontSize: FontSize.s30),
                    ),
                    const SizedBox(height: 40),
                    !isLoading
                        ? Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                !widget.isSignin
                                    ? kTextField(
                                        'Ujunwa Peace',
                                        'Name',
                                        Field.name,
                                        _nameController,
                                        false,
                                        false,
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 10),
                                kTextField(
                                  'ujunwa0001@gmail.com',
                                  'Email Address',
                                  Field.email,
                                  _emailController,
                                  false,
                                  false,
                                ),
                                const SizedBox(height: 10),
                                kTextField(
                                  '*********',
                                  'Password',
                                  Field.password,
                                  _passwordController,
                                  isObscure,
                                  true,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 74,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: isButtonDisabled
                                      ? null
                                      : () => _authenticate(),
                                  child: Text(
                                    widget.isSignin ? 'Signin' : 'Signup',
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: () => _googleAuthenticate(),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Image.asset(
                                        AssetManager.googleImage,
                                        width: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.isSignin
                                            ? 'Signin with google'
                                            : 'Signup with google',
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          _navigateToForgottenPassword(),
                                      child: const Text(
                                        'Forgotten Password',
                                        style: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _toggleAuth(),
                                      child: Text(
                                        widget.isSignin
                                            ? 'New here? Signup'
                                            : 'Own an account? Signin',
                                        style: const TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                    )
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
