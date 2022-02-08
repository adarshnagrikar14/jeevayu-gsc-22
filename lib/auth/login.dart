// ignore_for_file: non_constant_identifier_names

import 'package:jeevayu/auth/info_filling.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // T&C url:
  final String _url_terms_and_condition = 'https://flutter.dev';

  // Github url:
  final String _url_github =
      'https://github.com/adarshnagrikar14/jeevayu-gsc-22';

  // Linkedin url:
  final String _url_linkedin = 'https://linkedin.com/in/adarsh-nagrikar/';

  // Youtube url:
  final String _url_youtube = 'https://youtube.com';

  // Initializtion
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // status bar color
      ),
    );
  }

  // creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  // function to implement the google signin
  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      // User? user = result.user;

      // ignore: unnecessary_null_comparison
      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Information(),
          ),
        );
      } else {
        showSnack(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black, // status bar color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: const Text(
          'Login here',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 22.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lottie animation curved:
          Expanded(
            child: CustomPaint(
              painter: LogoPainter(),
              child: LottieBuilder.asset(
                'assets/lottie/login_screen.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            flex: 20,
          ),

          // Main Button
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                onTap: () {
                  signup(context);
                },
                child: const LoginButton(),
              ),
            ),
            flex: 10,
          ),

          // Social Handles
          Expanded(
            child: Row(
              children: <Widget>[
                // Git image
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      openGithub();
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/social/git_img.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),

                // Linkedin image
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      openLinkedin();
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/social/linkedin.jpg',
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),

                // youtube image
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      openYoutube();
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/social/youtube.png',
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
            flex: 3,
          ),

          // Terms and codition
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  openTerms();
                }, // opening link
                child: const Text(
                  'Terms and Conditions.',
                  style: TextStyle(
                    letterSpacing: 1,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }

  void showSnack(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Some error Occured , Retry'),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void openTerms() async {
    if (!await launch(_url_terms_and_condition)) {
      showSnack(context);
      throw 'Could not open Terms and condition!';
    }
  }

  void openGithub() async {
    if (!await launch(_url_github)) {
      showSnack(context);
      throw 'Could not open Terms and condition!';
    }
  }

  void openLinkedin() async {
    if (!await launch(_url_linkedin)) {
      showSnack(context);
      throw 'Could not open Terms and condition!';
    }
  }

  void openYoutube() async {
    if (!await launch(_url_youtube)) {
      showSnack(context);
      throw 'Could not open Terms and condition!';
    }
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    var path = Path();
    path.lineTo(0, size.height - size.height / 5);
    path.lineTo(size.width / 1.2, size.height);
    path.relativeQuadraticBezierTo(15, 3, 30, -5);
    path.lineTo(size.width, size.height - size.height / 5);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(50.0),
        child: InkWell(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            height: 55.0, //MediaQuery.of(context).size.width * .08,
            width: 220.0, //MediaQuery.of(context).size.width * .3,
            child: Row(
              children: <Widget>[
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://staffordonline.org/wp-content/uploads/2019/01/Google.jpg',
                      ),
                    ),
                  );
                }),
                const Expanded(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
