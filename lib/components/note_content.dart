import 'package:flutter/material.dart';
import '../resources/font_manager.dart';

class NoteContent extends StatelessWidget {
  const NoteContent({
    Key? key,
    required TextEditingController contentController,
    required this.isBold,
    required this.isUnderlined,
    required this.isItalics,
    required this.isJustified,
    required this.isLeftAligned,
    required this.isRightAligned,
    required this.isCentered,
    required this.color,
  })  : _contentController = contentController,
        super(key: key);

  final TextEditingController _contentController;
  final bool isBold;
  final bool isUnderlined;
  final bool isItalics;
  final bool isJustified;
  final bool isLeftAligned;
  final bool isRightAligned;
  final bool isCentered;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _contentController,
      maxLines: null,
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
        color: color,
        fontSize: FontSize.s16,
        fontWeight: isBold ? FontWeightManager.bold : FontWeightManager.normal,
        decoration:
        isUnderlined ? TextDecoration.underline : TextDecoration.none,
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
    );
  }
}
