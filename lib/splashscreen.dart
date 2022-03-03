import 'dart:async';

import 'package:jeevayu/auth/login.dart';
import 'package:jeevayu/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({Key? key}) : super(key: key);

  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // status bar color
      ),
    );

    User? user = FirebaseAuth.instance.currentUser;

    // Timer for splashscreen
    Timer(
      const Duration(seconds: 1),
      () {
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  const MainScreen(), //UserInfoScreen(user: user)
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: SizedBox(),
              flex: 2,
            ),
            Expanded(
              child: Center(
                // child: Lottie.asset(
                //   'assets/lottie/Welcome.json',
                //   height: 160.0,
                //   repeat: false,
                // ),
                child: Image(
                  image: const AssetImage(
                    'assets/social/splash.png',
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              flex: 15,
            ),
            const Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  // 'Thank you Frontline workers ❤',
                  "",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white70,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
