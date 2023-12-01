import 'package:demo_todo_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colours.dart';

import 'package:flutter/material.dart';

class ViewTask extends StatelessWidget {
  final String text;

  ViewTask(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SizedBox(
          height: getHeight(context)/2,
          child: Card(
            elevation: 5, // Add elevation for a shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: darkAppColor,
                  fontSize: 18,
                ),
              ),
            ).paddingAll(20),
          ).paddingAll(20),
        ),
      ),
    );
  }
}
