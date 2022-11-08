import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaree/constants/color.dart';
import 'package:diaree/resources/font_manager.dart';
import 'package:diaree/resources/styles_manager.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/settings.dart';
import '../../../resources/values_manager.dart';
import 'edit.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({Key? key, required this.note}) : super(key: key);
  final DocumentSnapshot note;

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMicrosecondsSinceEpoch(
        widget.note['date'].microsecondsSinceEpoch);

    // navigate to edit screen
    void navigateToEdit() {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(note: widget.note),
            ),
          )
          .then((value) => setState(() {}));
    }

    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
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
            color: theme.getThemeColor,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
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
                      widget.note['title'],
                      style: getMediumStyle(
                        color: theme.getThemeColor,
                        fontSize: FontSize.s28,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMEEEEd().format(date),
                      style: getRegularStyle(
                        color: theme.getThemeColor,
                      ),
                    )
                  ],
                ),
                Image.asset(widget.note['emotion'])
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width / 1,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 40,
              ),
              decoration:  BoxDecoration(
                color: theme.getThemeColor2,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: Text(
                widget.note['content'],
                textAlign: widget.note['isJustified']
                    ? TextAlign.justify
                    : widget.note['isLeftAligned']
                        ? TextAlign.left
                        : widget.note['isRightAligned']
                            ? TextAlign.right
                            : widget.note['isJustified']
                                ? TextAlign.center
                                : TextAlign.justify,
                style: TextStyle(
                  color: theme.getThemeColor,
                  fontSize: FontSize.s16,
                  fontWeight: widget.note['isBold']
                      ? FontWeightManager.bold
                      : FontWeightManager.normal,
                  decoration: widget.note['isUnderlined']
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  fontStyle: widget.note['isItalics']
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
