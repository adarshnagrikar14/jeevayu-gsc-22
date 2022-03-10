import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jeevayu/classes/home.dart';
import 'package:jeevayu/dashboard.dart';
import 'package:jeevayu/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing the firebase app
  await Firebase.initializeApp();

  // status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black87,
    ),
  );

  // Running app:
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeevayu',
      home: const ScreenSplash(), // Add Splashscreen first
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // set app theme
    );
  }
}
