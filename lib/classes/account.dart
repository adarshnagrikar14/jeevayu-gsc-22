// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String _name;
  late String _email;
  late String _profile;
  late String _number = "";
  late String _address = "";

  // T&C url:
  final String _url_terms_and_condition = 'https://flutter.dev';

  // controller
  final TextEditingController _phoneController = TextEditingController();

  // init
  @override
  void initState() {
    super.initState();

    setState(() {
      _name = user!.displayName!;
      _email = user!.email!;
      _profile = user!.photoURL!;
    });

    fetchNumber(user!.uid);
    fetchAddress(user!.uid);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // scrolview
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        // padding all over
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 40.0),

          // main body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // first block - profile
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name and email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          child: Text(
                            _name,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              _number,
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w200,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, top: 8.0),
                            child: Text(
                              _email,
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w200,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 6,
                  ),

                  // image
                  Expanded(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(_profile),
                      radius: 45,
                    ),
                    flex: 2,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                ],
              ),

              // Address
              const Padding(
                padding: EdgeInsets.only(top: 50.0, left: 15.0, bottom: 20.0),
                child: Text(
                  'My Address',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Address getting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          hintText: _address.isEmpty
                              ? 'Getting address...'
                              : _address,
                          hintStyle: const TextStyle(color: Colors.white70),
                          hintMaxLines: 10,
                          enabled: false,
                        ),
                        maxLines: null,
                      ),
                      flex: 6,
                    ),
                  ],
                ),
              ),

              // divider 2
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Divider(
                  height: 2.0,
                  color: Colors.grey,
                ),
              ),

              // bottom info line
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Row(
                  children: const [
                    // info icon
                    Expanded(
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                      ),
                      flex: 1,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    // text
                    Expanded(
                      child: Text(
                        'Your profile data may be shared with service provider to get in touch with you for the service offered. Read T&C below.',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      flex: 5,
                    )
                  ],
                ),
              ),

              // terms nd con
              Center(
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

              // spacing
              const SizedBox(
                height: 100.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchNumber(String uid) async {
    var collection = FirebaseFirestore.instance.collection('Mobiles');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String _num = data?['Number'];

      setState(() {
        _number = _num;
      });
    } else {
      setState(() {
        _address = 'No Number found!';
      });
    }
  }

  void fetchAddress(String uid) async {
    var collection = FirebaseFirestore.instance.collection('Addresses');
    var docSnapshot = await collection.doc(uid).get().timeout(
          const Duration(seconds: 15),
        );

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String _add = data?['Address'];

      setState(() {
        _address = _add;
      });
    } else {
      setState(() {
        _address = 'No Address found!';
      });
    }
  }

  void openTerms() async {
    if (!await launch(_url_terms_and_condition)) {
      throw 'Could not open Terms and condition!';
    }
  }
}

void showSnack(BuildContext context, String msg, bool _red) {
  var snackBar = SnackBar(
    content: Text(
      msg,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
    ),
    duration: const Duration(seconds: 5),
    backgroundColor: _red ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
