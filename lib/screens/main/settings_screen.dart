import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/helpers/image-uploader.dart';
import 'package:diaree/resources/route_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  bool isProfileImageEmpty = true;
  String profileImgUrl = AssetManager.avatarSmall;
  File? pickedProfileImage;

  // load profile details
  Future<void> _loadProfileDetails() async {
    var profileDetails =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (profileDetails['avatar'] != "None") {
      setState(() {
        profileImgUrl = profileDetails['avatar'];
        isProfileImageEmpty = false;
      });
    }
  }

  // select profile image
  void selectImageFnc(File pickedImage) {
    setState(() {
      pickedProfileImage = pickedImage;
    });
  }

  // logout action
  Future<void> _logoutAction() async {
    await firebaseAuth.signOut().then(
          (value) => Navigator.of(context).pushReplacementNamed(
            RouteManager.authScreen,
          ),
        );
  }

  // logout
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: const Text('Do you want to sign out?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.all(17),
        actions: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                'Yes',
                style: getRegularStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => _logoutAction(),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
              ),
              label: Text(
                'Cancel',
                style: getRegularStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  // style for all list tiles
  TextStyle style = getMediumStyle(
    color: Colors.black,
    fontSize: FontSize.s18,
  );

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
          'Settings',
          style: getRegularStyle(
            color: Colors.black,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      backgroundColor: backgroundLite,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 30,
        ),
        child: Container(
          height: size.height / 1.35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSize.s30),
          ),
          padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
          child: ListView(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Change Profile Image',
                  style: style,
                ),
                trailing: ImageUploader(
                  imgUrl: profileImgUrl,
                  selectImageFnc: selectImageFnc,
                  isProfileImageEmpty: isProfileImageEmpty,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: backgroundLite,
        height: 50,
        child: Center(
          child: TextButton(
            onPressed: () => _logout(),
            child: Text(
              'Logout',
              style: getBoldStyle(
                color: primaryColor,
                fontSize: FontSize.s18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}