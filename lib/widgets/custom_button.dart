
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colours.dart';
import '../utils/constants.dart';


class CustomButton extends StatelessWidget {
  VoidCallback onPressed;
  String title;
  Color? color;
  double? height;
  double? width;
  double? padding = 0;
  bool isBtnDisable;
  bool? isProgress;
  double? borderRadius;
  double? fontSize;

  CustomButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.isBtnDisable = false,
    this.color,
    this.height,
    this.borderRadius,
    this.width,
    this.padding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 0),
      height: height ?? 50,
      child: Stack(
        children: [
          MaterialButton(
            color: color ?? primaryColor,
            height: height ?? getHeight(context) * 0.05,
            minWidth: width ?? double.infinity,
            padding: EdgeInsets.zero,
            splashColor: primaryColor,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius??10)),
            onPressed: isBtnDisable ? null : onPressed,
            child: Container(
              alignment: Alignment.center,
              height: height ?? 60,
              width: width ?? MediaQuery.of(context).size.width,
              // width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius??10),
                color:  color ?? primaryColor,
              ),
              child: AutoSizeText(title,
                  presetFontSizes: [14, 12,10,8],
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: isBtnDisable ? Colors.black : darkAppColor,
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize ?? 14  )),
            ),
          ),
          Container(
            height: height ?? 50,
            width: width ?? double.infinity,
            decoration: BoxDecoration(
              //   color: Colors.grey.withOpacity(0.6),
                color: lightAppColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(borderRadius??10)),
          ).visible(isBtnDisable),
        ],
      ),
    );
  }
}
