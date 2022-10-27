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
  var isObscure = false;

  // toggle to signup
  void _toggleToSignup() {
    setState(() {
      widget.isSignin = false;
    });
  }

  // toggle to signin
  void _toggleToSignin() {
    setState(() {
      widget.isSignin = true;
    });
  }

  @override
  void initState() {
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
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
      },
      decoration: InputDecoration(
        hintText: hint,
        label: Text(label),
        suffix: obscureValue
            ? _passwordController.text.isNotEmpty
                ? Icon(
                    obscureValue ? Icons.visibility : Icons.visibility_off,
                    color: obscureValue ? primaryColor : greyShade,
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(AssetManager.logoRed),
              // const SizedBox(height: AppSize.s10),
              Column(
                children: [
                  Text(
                    'Signin!',
                    textAlign: TextAlign.center,
                    style: getHeadingStyle(fontSize: FontSize.s30),
                  ),
                  kTextField(
                    'Ujunwa Peace',
                    'Name',
                    Field.name,
                    _nameController,
                    false,
                  ),
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

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 74, vertical: 8),
                ),
                onPressed: () {},
                child: const Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
