import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({
    Key? key,
    required this.profileDetails,
    required this.isPinSetBefore,
  }) : super(key: key);
  final DocumentSnapshot? profileDetails;
  final bool isPinSetBefore;

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [],
    ));
  }
}
