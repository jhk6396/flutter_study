import 'package:flutter/material.dart';
import 'package:flutter_study/common/component/custom_text_form_field.dart';
import 'package:flutter_study/common/view/splash_screen.dart';
import 'package:flutter_study/user/view/login_scren.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
