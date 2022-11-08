import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../components/loading.dart';
import '../../constants/color.dart';
import '../../providers/settings.dart';
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
      Color color,
  ) {
    return TextFormField(
      style: TextStyle(color:color),
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
            if (value!.isEmpty || value.length < 8) {
              return "FullName is not valid!";
            }

            if (!value.contains(' ')) {
              return "Surname is also required!";
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
    Timer(const Duration(seconds: 4), () {
      if (widget.isSignin) {
        // TODO: Home screen routeName
        Navigator.of(context).pushReplacementNamed(RouteManager.homeScreen);
      }
      Navigator.of(context)
          .pushReplacementNamed(RouteManager.signupAcknowledgeScreen);
    });
  }

  // snackbar for error message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor,
    ));
  }

  // authenticate
  Future<void> _authenticate() async {
    FocusScope.of(context).unfocus();
    var valid = _formKey.currentState!.validate();
    _formKey.currentState!.save();
    if (!valid) return;

    try {
      setState(() {
        isLoading = true;
      });
      if (widget.isSignin) {
        // authenticate signin
        await firebaseAuth
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            )
            .then((value) => loadingFnc());
      } else {
        // authenticate signup
        var credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        firebase.collection("users").doc(credential.user!.uid).set({
          "fullname": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "avatar": "None",
          "pin": "0000",
          'auth-type': 'email',
          // 'pin_lock':false,
        }).then((value) => loadingFnc());
      }
    } on FirebaseAuthException catch (e) {
      var error = 'An error occurred. Check credentials!';
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          error = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          error = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          error = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          error = 'Network error!';
        } else {
          error = e.code;
        }
      }

      showSnackBar(error); // showSnackBar will show error if any
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // authenticate using google
  Future<void> _googleAuthenticate() async {
    setState(() {
      isLoading = true;
    });

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      // send username, email, and phone number to firestore
      var logCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(logCredential.user!.uid)
          .set(
        {
          "fullname": googleUser!.displayName,
          "email": googleUser.email,
          "avatar": googleUser.photoUrl,
          "pin": "0000",
          'auth-type': 'google-auth',
          // 'pin_lock':false,
        },
      ).then((value) {
        loadingFnc();
      });
    } on FirebaseAuthException catch (e) {
      var error = 'An error occurred. Check credentials!';
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          error = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          error = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          error = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          error = 'Network error!';
        } else {
          error = e.code;
        }
      }

      showSnackBar(error); // showSnackBar will show error if any
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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
                      widget.isSignin ? 'Sign in!' : 'Sign up!',
                      textAlign: TextAlign.center,
                      style: getHeadingStyle(fontSize: FontSize.s30,color:theme.getThemeColor),
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
                                  theme.getThemeColor,
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
                                  theme.getThemeColor,
                                ),
                                const SizedBox(height: 10),
                                kTextField(
                                  '*********',
                                  'Password',
                                  Field.password,
                                  _passwordController,
                                  isObscure,
                                  true,
                                  theme.getThemeColor,
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
                                    backgroundColor: theme.getThemeColor2,
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
