import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/color.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);
  final double _kSize = 50;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: primaryColor,
        size: _kSize,
      ),
    );
  }
}