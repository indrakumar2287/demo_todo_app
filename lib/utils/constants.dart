import 'package:flutter/cupertino.dart';

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getStatusBarHeight(BuildContext context){
  return MediaQuery.of(context).padding.top;
}
