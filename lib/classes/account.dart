import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jeevayu/helpers/address.dart';

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
  late String _userId;

  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _phoneFormKey = GlobalKey<FormFieldState>();

  bool _isFormValid() {
    return ((_phoneFormKey.currentState!.isValid));
  }

  // init
  @override
  void initState() {
    super.initState();

    setState(() {
      _name = user!.displayName!;
      _email = user!.email!;
      _profile = user!.photoURL!;
      _userId = user!.uid;
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
      // scrolview
      body: SingleChildScrollView(
        // padding all over
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),

          // main body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // first block - profile
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // name and email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
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
                          child: Text(
                            _email,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w200,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    flex: 5,
                  ),
                ],
              ),

              // divider 1
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  height: 2.0,
                  color: Colors.grey,
                ),
              ),

              // number
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'My Number',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // number getting:
              Row(
                children: [
                  // field
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText:
                            _number.isEmpty ? 'Getting number...' : _number,
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      enabled: false,
                    ),
                    flex: 6,
                  ),

                  // edit number
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _registerDialogBox(context),
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),

              // Address
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'My Address',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Address getting
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      minLines:
                          6, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText:
                            _address.isEmpty ? 'Getting address...' : _address,
                        hintMaxLines: 10,
                      ),
                      maxLines: null,
                    ),
                    // _address.isEmpty ? 'Getting address...' : _address
                    flex: 6,
                  ),

                  // edit Address
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddressUpdate()),
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),

              // divider 2
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  height: 2.0,
                  color: Colors.grey,
                ),
              ),
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

  // update Number
  void _updateNumber(BuildContext context, String _userId) {
    var docRef = FirebaseFirestore.instance.collection('Mobiles').doc(_userId);

    // setting number in docRef:
    docRef.set({'Number': _phoneController.text}).onError(
      (error, stackTrace) {
        showSnack(context, 'Error occured , retry', true);
        Navigator.pop(context);
      },
    ).whenComplete(
      () {
        showSnack(context, "Successfully changed", false);
        Navigator.pop(context);
      },
    );
  }

  // number update dialog
  Future<String?> _registerDialogBox(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool _isSubmitButtonEnabled = false;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[850],
            scrollable: true,
            title: const Text('Update Number'),
            content: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        key: _phoneFormKey,
                        maxLength: 10,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9+]"),
                          )
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixText: '+91  ',
                          prefixStyle: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isSubmitButtonEnabled = _isFormValid();
                            _phoneFormKey.currentState!.validate();
                          });
                        },
                        validator: (value) {
                          if (value!.length < 10) {
                            return 'Number can\'t be less than 10';
                          } else {
                            return null;
                          }
                        }),
                  ],
                ),
              ),
            ),
            actions: [
              // cancel btn
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[850],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),

              // update btn
              ElevatedButton(
                child: const Text("Update"),
                onPressed: _isSubmitButtonEnabled
                    ? () => _updateNumber(context, _userId)
                    : null,
              ),
            ],
          );
        });
      },
    );
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
