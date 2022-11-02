import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/constants/color.dart';
import 'package:diaree/resources/font_manager.dart';
import 'package:diaree/resources/styles_manager.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import '../../../resources/values_manager.dart';
import 'edit.dart';

class ViewNoteScreen extends StatelessWidget {
  const ViewNoteScreen({Key? key, required this.note}) : super(key: key);
  final DocumentSnapshot note;

  @override
  Widget build(BuildContext context) {
    // navigate to edit screen
    void navigateToEdit() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditNoteScreen(note: note),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => navigateToEdit(),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: AppSize.s35,
        ),
      ),
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
          'View Entry',
          style: getRegularStyle(
            color: Colors.black,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      backgroundColor: backgroundLite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note['title'],
                      style: getMediumStyle(
                        color: Colors.black,
                        fontSize: FontSize.s28,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMEEEEd().format(note['date']),
                      style: getRegularStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Image.asset(note['emotion'])
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 40,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Text(
                note['title'],
                textAlign: note['isJustified']
                    ? TextAlign.justify
                    : note['isLeftAligned']
                        ? TextAlign.left
                        : note['isRightAligned']
                            ? TextAlign.right
                            : note['isJustified']
                                ? TextAlign.center
                                : TextAlign.justify,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: FontSize.s16,
                  fontWeight: note['isBold']
                      ? FontWeightManager.bold
                      : FontWeightManager.normal,
                  decoration: note['isUnderlined']
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  fontStyle:
                      note['isItalics'] ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
