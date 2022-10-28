import "package:flutter/material.dart";

import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
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

  // toggle auth
  void _toggleAuth() {
    setState(() {
      widget.isSignin = !widget.isSignin;
    });
  }

  // navigate to forgotten password
  void _navigateToForgottenPassword() {}

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
    checkEntries();
    super.didChangeDependencies();
  }

  Widget kTextField(
    String hint,
    String label,
    Field field,
    TextEditingController controller,
    bool obscureValue,
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
        suffixIcon: obscureValue
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

  // authenticate
  void _authenticate() {}

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
                    Form(
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
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          kTextField(
                            'ujunwa0001@gmail.com',
                            'Email Address',
                            Field.email,
                            _emailController,
                            false,
                          ),
                          const SizedBox(height: 10),
                          kTextField(
                            '*********',
                            'Password',
                            Field.password,
                            _passwordController,
                            isObscure,
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 74,
                      vertical: 8,
                    ),
                  ),
                  onPressed: isButtonDisabled ? null : () => _authenticate(),
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
                    crossAxisAlignment: WrapCrossAlignment.center,
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
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _navigateToForgottenPassword(),
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
                            : 'Already own an account? Signup',
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
