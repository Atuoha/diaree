import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/resources/styles_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';

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


  @override
  Widget build(BuildContext context) {
    final username = widget.profileDetails!['username'];
    final usernameSplit = username.split(' ');

    return Scaffold(
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
                      child: Image.network(widget.profileDetails!['avatar'],
                          width: 100),
                    ),
              Text(
                'Welcome, ${usernameSplit[1]}',
                style: getBoldStyle(
                  color: Colors.black,
                  fontSize: FontSize.s25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
