import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/note_content.dart';
import '../../../components/note_title.dart';
import '../../../components/snackbar.dart';
import '../../../constants/color.dart';
import '../../../providers/settings.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import 'package:intl/intl.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key, required this.note}) : super(key: key);
  final DocumentSnapshot note;

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

enum TextDirection {
  right,
  left,
  justify,
  center,
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final uId = FirebaseAuth.instance.currentUser!.uid;
  var date = DateTime.now();
  bool isLoading = false;

  bool isBold = false;
  bool isItalics = false;
  bool isUnderlined = false;
  bool isJustified = true;
  bool isLeftAligned = false;
  bool isRightAligned = false;
  bool isCentered = false;

  // set details
  void setNoteDetails() {
    setState(() {
      _titleController.text = widget.note['title'];
      _contentController.text = widget.note['content'];
      date = DateTime.fromMicrosecondsSinceEpoch(
          widget.note['date'].microsecondsSinceEpoch);
      isBold = widget.note['isBold'];
      isItalics = widget.note['isItalics'];
      isUnderlined = widget.note['isUnderlined'];
      isJustified = widget.note['isJustified'];
      isLeftAligned = widget.note['isLeftAligned'];
      isRightAligned = widget.note['isRightAligned'];
      isCentered = widget.note['isCentered'];
      currentEmotionIndex = widget.note['emotion_index'];
    });
  }

  // toggle bold
  void toggleBold() {
    setState(() {
      isBold = !isBold;
    });
  }

  // toggle underline
  void toggleUnderline() {
    setState(() {
      isUnderlined = !isUnderlined;
    });
  }

  // toggle Italics
  void toggleItalics() {
    setState(() {
      isItalics = !isItalics;
    });
  }

  // toggle between justify,left-aligned and right-aligned
  void toggleTextDirection(TextDirection direction) {
    switch (direction) {
      case TextDirection.right:
        setState(() {
          isRightAligned = true;
          isJustified = false;
          isLeftAligned = false;
          isCentered = false;
        });
        break;

      case TextDirection.center:
        setState(() {
          isRightAligned = false;
          isJustified = false;
          isLeftAligned = false;
          isCentered = true;
        });
        break;

      case TextDirection.left:
        setState(() {
          isRightAligned = false;
          isJustified = false;
          isLeftAligned = true;
          isCentered = false;
        });
        break;

      case TextDirection.justify:
        setState(() {
          isRightAligned = false;
          isJustified = true;
          isLeftAligned = false;
          isCentered = false;
        });
        break;
    }
  }

  var currentEmotionIndex = 0;
  final List<String> emotions = [
    AssetManager.happy,
    AssetManager.smile,
    AssetManager.aww,
    AssetManager.eh,
    AssetManager.sad,
  ];

  Widget emotionBox(String emotion, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        currentEmotionIndex = index;
      }),
      child: CircleAvatar(
        backgroundColor:
            currentEmotionIndex == index ? primaryColor : Colors.transparent,
        child: Image.asset(emotion),
      ),
    );
  }

  // save note
  void saveNote() {
    FocusScope.of(context).unfocus();

    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      showSnackBar('OPPS! Title or content can not be empty!', context);
      return;
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        FirebaseFirestore.instance
            .collection('notes')
            .doc(widget.note.id)
            .update({
          'uid': uId,
          'date': date,
          'title': _titleController.text.trim(),
          'content': _contentController.text.trim(),
          'emotion': emotions[currentEmotionIndex],
          'emotion_index': currentEmotionIndex,
          'isBold': isBold,
          'isItalics': isItalics,
          'isUnderlined': isUnderlined,
          'isJustified': isJustified,
          'isLeftAligned': isLeftAligned,
          'isRightAligned': isRightAligned,
          'isCentered': isCentered,
        });
        Timer(const Duration(seconds: 4), () {
          Navigator.of(context).pop();
        });
      } on FirebaseException catch (e) {
        showSnackBar('Opps! An error occurred. ${e.message}', context);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setNoteDetails();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var theme = Provider.of<SettingsData>(context);
    return Scaffold(
      backgroundColor: theme.getThemeBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          WidgetsBinding.instance.window.viewInsets.bottom > 0.0
              ? FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () => FocusScope.of(context).unfocus(),
                  child: const Icon(
                    Icons.keyboard,
                    color: Colors.white,
                    size: AppSize.s35,
                  ),
                )
              : const SizedBox.shrink(),
      appBar: buildAppBar(theme.getThemeColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 5,
                  ),
                  height: 83,
                  color: theme.getThemeColor2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMEEEEd().format(date),
                        style: TextStyle(color: theme.getThemeColor),
                      ),
                      NoteTitle(
                        titleController: _titleController,
                        color: theme.getThemeColor,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: formattingWidget(theme.getThemeColor),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 40,
              ),
              decoration: BoxDecoration(
                color: theme.getThemeColor2,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              child: NoteContent(
                color: theme.getThemeColor,
                contentController: _contentController,
                isBold: isBold,
                isUnderlined: isUnderlined,
                isItalics: isItalics,
                isJustified: isJustified,
                isLeftAligned: isLeftAligned,
                isRightAligned: isRightAligned,
                isCentered: isCentered,
              ),
            ),
          )
        ],
      ),
      bottomSheet: bottomEmotionSelector(
        size,
        theme.getThemeColor,
        theme.getThemeBackgroundColor,
      ),
    );
  }

  // EXTRACTED METHODS

  // appbar
  AppBar buildAppBar(Color color) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          padding: const EdgeInsets.only(left: 18),
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: color),
        ),
      ),
      actions: [
        !isLoading
            ? IconButton(
                padding: const EdgeInsets.only(right: 18),
                onPressed: () => saveNote(),
                icon: Icon(
                  Icons.save,
                  color: color,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: color,
                  ),
                ),
              ),
      ],
      title: Text(
        'Edit Entry',
        style: getRegularStyle(
          color: color,
          fontWeight: FontWeightManager.medium,
          fontSize: FontSize.s18,
        ),
      ),
    );
  }

  // Container for emotions
  Container bottomEmotionSelector(Size size, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 55,
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mood',
            style: getMediumStyle(
              color: color,
              fontSize: FontSize.s16,
            ),
          ),
          // SizedBox(width: 50,),
          SizedBox(
            width: size.width / 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emotions.length,
              itemBuilder: (context, index) => emotionBox(
                emotions[index],
                index,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // sized box that hold formatting tools
  SizedBox formattingWidget(Color color) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.left),
            child: Icon(
              Icons.format_align_left,
              size: AppSize.s40,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.center),
            child: Icon(
              Icons.format_align_center,
              size: AppSize.s40,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.justify),
            child: Icon(
              Icons.format_align_justify,
              size: AppSize.s40,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleTextDirection(TextDirection.right),
            child: Icon(
              Icons.format_align_right,
              size: AppSize.s40,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleBold(),
            child: Icon(
              Icons.format_bold,
              size: AppSize.s50,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleItalics(),
            child: Icon(
              Icons.format_italic,
              size: AppSize.s50,
              color: color,
            ),
          ),
          GestureDetector(
            onTap: () => toggleUnderline(),
            child: Icon(
              Icons.format_underline,
              size: AppSize.s40,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
