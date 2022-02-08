// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeevayu/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  // youtube url
  final String _url_youtube = "https://youtube.com";

  // terms url
  final String _url_terms = "https://flutter.dev";

  // layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        shadowColor: Colors.grey[500],
        toolbarHeight: 60,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Help', 'Terms and Conditions'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        elevation: 10,
        title: const Text(
          'Confirm details',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: const FormFill(),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Help':
        openYoutube();
        break;
      case 'Terms and Conditions':
        openTerms();
        break;
    }
  }

  // open yt
  void openYoutube() async {
    if (!await launch(_url_youtube)) {
      throw 'Could not open Terms and condition!';
    }
  }

  // open t&c
  void openTerms() async {
    if (!await launch(_url_terms)) {
      throw 'Could not open Terms and condition!';
    }
  }
}

class FormFill extends StatefulWidget {
  const FormFill({Key? key}) : super(key: key);

  @override
  _FormFillState createState() => _FormFillState();
}

class _FormFillState extends State<FormFill> {
  // firebase auth init
  final User? user = FirebaseAuth.instance.currentUser;
  late String _name;
  late String _email;
  final _text = TextEditingController();
  bool _validate = false;
  bool _isLoading = false;

  // t and c url:
  final String _url_terms_and_condition = 'https://flutter.dev';

  // uId
  late String _userId;

  // init
  @override
  void initState() {
    super.initState();
    setState(() {
      _name = user!.displayName!;
      _email = user!.email!;
      _userId = user!.uid;
    });
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Name field:
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
              child: Text(
                'Name',
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 10.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _name,
                hintStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                ),
              ),
              enabled: false,
            ),
          ),

          // Email field:
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
              child: Text(
                'E-mail',
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 10.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _email,
                hintStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white54,
                ),
              ),
              enabled: false,
            ),
          ),

          // Number field:
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
              child: Text(
                'Mobile no.',
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 10.0,
            ),
            child: TextField(
              controller: _text,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              onSubmitted: (value) {
                setState(() {
                  value.length < 10 ? _validate = true : _validate = false;
                });
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixText: '+91  ',
                errorText: _validate ? 'Number Can\'t be less than 10' : null,
                prefixStyle: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              enabled: true,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Container(
                  child: GestureDetector(
                    onTap: () {
                      handlesubmit();
                    },
                    child: !_isLoading
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text('I confirm',
                                style: TextStyle(
                                  fontSize: 22,
                                )),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1,
                      )
                    ],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                ),
              ),
            ),
            flex: 5,
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
            flex: 1,
          ),
        ],
      ),
    );
  }

  void openTerms() async {
    if (!await launch(_url_terms_and_condition)) {
      throw 'Could not open Terms and condition!';
    }
  }

  void handlesubmit() {
    // print(_text.text.toString());

    setState(() {
      _isLoading = true;
      _text.text.length < 10 ? _validate = true : _validate = false;
    });

    if (!_validate) {
      var docRef =
          FirebaseFirestore.instance.collection('Mobiles').doc(_userId);

      // setting number in docRef:
      docRef.set({'Number': _text.text}).onError(
        (error, stackTrace) {
          showSnack(context);
          setState(() {
            _isLoading = false;
          });
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          showSnack(context);
          setState(() {
            _isLoading = false;
          });
        },
      ).whenComplete(
        () {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ScreenSplash(),
            ),
          );
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

void showSnack(BuildContext context) {
  const snackBar = SnackBar(
    content: Text(
      'Some error Occured , Retry',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    duration: Duration(seconds: 5),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
