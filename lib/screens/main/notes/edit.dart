import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import 'package:intl/intl.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key}) : super(key: key);

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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final uId = FirebaseAuth.instance.currentUser!.uid;
  final date = DateTime.now();

  bool isBold = false;
  bool isItalics = false;
  bool isUnderlined = false;
  bool isJustified = true;
  bool isLeftAligned = false;
  bool isRightAligned = false;
  bool isCentered = false;

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

  // save edit
  void saveNote() {
    // Todo: Implement Edit
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 18),
            onPressed: () => saveNote(),
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
        title: Text(
          'Create Entry',
          style: getRegularStyle(
            color: Colors.black,
            fontWeight: FontWeightManager.medium,
            fontSize: FontSize.s18,
          ),
        ),
      ),
      backgroundColor: backgroundLite,
      body: Form(
        key: _formKey,
        child: Column(
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
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat.yMMMMEEEEd().format(date)),
                        TextFormField(
                          controller: _titleController,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Title can not be empty";
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "Title here...",
                            filled: false,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: getMediumStyle(
                            color: Colors.black,
                            fontSize: FontSize.s28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SizedBox(
                        height: 70,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    toggleTextDirection(TextDirection.left),
                                child: const Icon(
                                  Icons.format_align_left,
                                  size: AppSize.s40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    toggleTextDirection(TextDirection.center),
                                child: const Icon(
                                  Icons.format_align_center,
                                  size: AppSize.s40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    toggleTextDirection(TextDirection.justify),
                                child: const Icon(
                                  Icons.format_align_justify,
                                  size: AppSize.s40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    toggleTextDirection(TextDirection.right),
                                child: const Icon(
                                  Icons.format_align_right,
                                  size: AppSize.s40,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => toggleBold(),
                                child: const Icon(
                                  Icons.format_bold,
                                  size: AppSize.s50,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => toggleItalics(),
                                child: const Icon(
                                  Icons.format_italic,
                                  size: AppSize.s50,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => toggleUnderline(),
                                child: const Icon(
                                  Icons.format_underline,
                                  size: AppSize.s40,
                                ),
                              ),
                            ])),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Content can not be empty";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Type here...",
                    filled: false,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: FontSize.s16,
                    fontWeight: isBold
                        ? FontWeightManager.bold
                        : FontWeightManager.normal,
                    decoration: isUnderlined
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    fontStyle: isItalics ? FontStyle.italic : FontStyle.normal,
                  ),
                  textAlign: isJustified
                      ? TextAlign.justify
                      : isLeftAligned
                          ? TextAlign.left
                          : isRightAligned
                              ? TextAlign.right
                              : isCentered
                                  ? TextAlign.center
                                  : TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 55,
        color: backgroundLite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mood',
              style: getMediumStyle(
                color: Colors.black,
                fontSize: FontSize.s16,
              ),
            ),
            // SizedBox(width: 50,),
            SizedBox(
              width: size.width / 1.9,
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
      ),
    );
  }
}
