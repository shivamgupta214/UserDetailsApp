import 'package:AARVI_Support/Screens/mobile_signup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AARVI Support',
      home: MobileSignupScreen(),
    );
  }
}
//mobile number registered loop
//verifying pop up
//
