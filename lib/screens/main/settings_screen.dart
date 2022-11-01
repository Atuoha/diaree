import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/helpers/image-uploader.dart';
import 'package:diaree/providers/settings.dart';
import 'package:diaree/resources/route_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../../components/snackbar.dart';
import '../../constants/color.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'pin_setup.dart';

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
  SettingsData? settingsData;
  bool isDarkTheme = false;
  bool isPinSet = false;
  bool isSyncAutomatically = false;
  bool isSyncing = false;
  bool isSyncingDone = false;
  DocumentSnapshot? profileDetails;
  bool isPinSetBefore = false;

  // loading settings from provider
  void _loadSettings() {
    var settings = Provider.of<SettingsData>(context);
    setState(() {
      settingsData = settings;
      isDarkTheme = settingsData!.getIsDarkTheme;
      isPinSet = settingsData!.getIsPinSet;
      isSyncAutomatically = settingsData!.getIsSyncAutomatically;
    });
  }

  // load profile details
  Future<void> _loadProfileDetails() async {
    var details =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // checking if avatar is set
    if (details['avatar'] != "None") {
      setState(() {
        profileImgUrl = details['avatar'];
        isProfileImageEmpty = false;
      });
    }

    // checking if pin is set
    if (details['pin'] != "0000") {
      setState(() {
        isPinSetBefore = true;
      });
    }

    if (details['avatar'] != "None") {
      setState(() {
        profileImgUrl = details['avatar'];
        isProfileImageEmpty = false;
      });
    }
    setState(() {
      profileDetails = details;
    });
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

  // switch list tile
  SwitchListTile kSwitchTile(
    String title,
    bool value,
    Function action,
  ) {
    return SwitchListTile(
      activeTrackColor: accent,
      inactiveTrackColor: textBoxLite,
      activeColor: Colors.white,
      value: value,
      onChanged: (value) => action(),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: style,
      ),
    );
  }

  // navigate to pin settings
  void _navigateToPinSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PinSetupScreen(
          profileDetails: profileDetails,
          isPinSetBefore: isPinSetBefore,
          isProfileImageEmpty: isProfileImageEmpty,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileDetails();
  }



  // sync settings
  Future<void> _syncSettings() async {
    if (pickedProfileImage != null) {
      setState(() {
        isSyncing = true;
      });

      var storageRef =
          FirebaseStorage.instance.ref().child('avatars').child('$userId.jpg');
      File? file;
      if (pickedProfileImage != null) {
        setState(() {
          file = File(pickedProfileImage!.path);
        });
      }

      try {
        await storageRef.putFile(file!);
        var downloadLink = await storageRef.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'avatar': downloadLink,
        });

        setState(() {
          isSyncing = false;
          isSyncingDone = true;
        });
      } on FirebaseException catch (e) {
        showSnackBar('Error occurred! ${e.message}', context);
      } catch (e) {
        if (kDebugMode) {
          print('An error occurred! $e');
        }
      }
    } else {
      showSnackBar(
          'There is nothing to sync. Other settings are synced automatically by default',context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSettings();
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
              kSwitchTile(
                'Dark Mode',
                isDarkTheme,
                settingsData!.toggleIsDarkTheme,
              ),
              kSwitchTile(
                'Biometrics/PIN Lock',
                isPinSet,
                settingsData!.toggleIsPinSet,
              ),
              kSwitchTile(
                'Sync Automatically',
                isSyncAutomatically,
                settingsData!.toggleIsSyncAutomatically,
              ),
              isPinSet
                  ? ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Manage Pin',
                        style: style,
                      ),
                      trailing: IconButton(
                        onPressed: () => _navigateToPinSettings(),
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Sync Now',
                  style: style,
                ),
                trailing: isSyncing
                    ? const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : isSyncingDone
                        ? const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.black,
                            ),
                          )
                        : IconButton(
                            onPressed: () => _syncSettings(),
                            icon: const Icon(Icons.chevron_right),
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
