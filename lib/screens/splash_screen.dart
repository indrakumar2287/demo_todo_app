import 'dart:convert';

import 'package:demo_todo_app/screens/homepage.dart';
import 'package:demo_todo_app/utils/colours.dart';
import 'package:demo_todo_app/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 2));
    finish(context);

      HomePage().launch(context, isNewTask: true);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightAppColor,
      body: Center(
        child: Container(
          width: 150, // Adjust the size as needed
          height: 150, // Adjust the size as needed
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: darkAppColor,
              width: 2.0,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              app_icon,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
