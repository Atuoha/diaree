import 'package:diaree/screens/entry/entry.dart';
import "package:flutter/material.dart";

void main()=> runApp(const Diaree());

class Diaree extends StatelessWidget{
  const Diaree({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: EntryScreen(),
    );
  }
}
