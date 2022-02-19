// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressUpdate extends StatefulWidget {
  const AddressUpdate({Key? key}) : super(key: key);

  @override
  _AddressUpdateState createState() => _AddressUpdateState();
}

class _AddressUpdateState extends State<AddressUpdate> {
  // youtube url
  final String _url_youtube = "https://youtube.com";

  // terms url
  final String _url_terms = "https://flutter.dev";

  late String _userId;
  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _addressController = TextEditingController();

  late bool _valid;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userId = user!.uid;
      _valid = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.grey[850],
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
          'Update Address',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // edit adress
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                minLines: 6,
                keyboardType: TextInputType.streetAddress,
                controller: _addressController,
                maxLength: 120,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: "Edit Address here...",
                  errorText: !_valid ? null : 'Address can\'t be empty input.',
                  hintMaxLines: 1,
                  contentPadding: const EdgeInsets.all(25.0),
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _valid = value.isEmpty ? true : false;
                  });
                },
                maxLines: null,
              ),
            ),
            // _address.isEmpty ? 'Getting address...' : _address
            flex: 5,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
            ),
            child:
                _isLoading ? const CircularProgressIndicator() : const Center(),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(
                        color: Colors.lightGreen,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  // showSnack(context, "Hello", false);
                  if (_addressController.text.isNotEmpty) {
                    setState(() {
                      _isLoading = true;
                    });
                    _updateAddress(context);
                  } else {
                    setState(() {
                      _valid = true;
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "UPDATE",
                    style: TextStyle(
                      fontSize: 23.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

// update Address
  void _updateAddress(BuildContext context) {
    var docRef =
        FirebaseFirestore.instance.collection('Addresses').doc(_userId);

    // setting number in docRef:
    docRef.set({'Address': _addressController.text}).onError(
      (error, stackTrace) {
        setState(() {
          _isLoading = false;
        });
        showSnack(context, 'Error occured , retry', true);
      },
    ).whenComplete(
      () {
        setState(() {
          _isLoading = false;
        });
        showSnack(context, "Successfully changed", false);
        Timer(
            const Duration(
              seconds: 2,
            ), () {
          Navigator.pop(context);
        });
      },
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

void showSnack(BuildContext context, String msg, bool _red) {
  var snackBar = SnackBar(
    content: Text(
      msg,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ),
    duration: const Duration(seconds: 1),
    backgroundColor: _red ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
