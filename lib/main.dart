import 'package:cloth_app/view/home.dart';
import 'package:cloth_app/widgets.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cloth',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        accentColor: MAIN_ACCENT_COLOR,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.white,
          iconTheme: IconThemeData(color: MAIN_ACCENT_COLOR),
          textTheme: TextTheme(
             title: TextStyle(
               color: Colors.black,
               fontFamily: 'PlayfairDisplay',
               fontWeight: FontWeight.w900,
               fontSize: 24,
             ),
          ),
        ),

      ),
      home: HomePage(),
    );
  }
}
