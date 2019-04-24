import 'package:flutter/material.dart';
import 'package:music_player/pages/home_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: HomePlayer(),
    );
  }
}