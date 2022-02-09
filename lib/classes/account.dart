import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  // init
  @override
  void initState() {
    super.initState();
    setState(() {
      _name = user!.displayName!;
      _email = user!.email!;
      _profile = user!.photoURL!;
    });
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
                        Text(
                          _email,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w200,
                          ),
                          textAlign: TextAlign.start,
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
            ],
          ),
        ),
      ),
    );
  }
}
