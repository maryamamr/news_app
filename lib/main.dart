import 'package:flutter/material.dart';
import 'package:news_app/newsPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsBody(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Colors.red,
        primaryColor: Colors.redAccent,
        accentColor: Colors.amber,
        backgroundColor: Colors.white70,
      ),
    );
  }
}

