import 'package:flutter/material.dart';
import 'package:stepit/pages/take_picture.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TakePictureScreen(), 
      // TODO: change TakePicturePage to HomePage
      // TODO: Add theme:, Learn themes
    );
  }
}