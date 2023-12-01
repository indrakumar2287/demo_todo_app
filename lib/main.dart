import 'package:demo_todo_app/screens/homepage.dart';
import 'package:demo_todo_app/screens/splash_screen.dart';
import 'package:demo_todo_app/utils/colours.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Task Planner',
        theme: ThemeData(
          // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor).copyWith(background: white),
        ),
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
        builder:(context,child){
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaler.scale(1) ;
          return MediaQuery.withClampedTextScaling(
            maxScaleFactor: scale,
            child: child!,
          );
        }
    );
  }
}
