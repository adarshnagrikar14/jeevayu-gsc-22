// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final User? user = FirebaseAuth.instance.currentUser;

  // uid
  late String _userId;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userId = user!.uid;
    });

    // query history
    // getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        shadowColor: Colors.grey[500],
        toolbarHeight: 60,
        elevation: 10,
        title: const Text(
          'History',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),

      // body
      body: StreamBuilder(
        // stream
        stream: FirebaseFirestore.instance
            .collection('History')
            .doc(_userId)
            .collection('History')
            .orderBy("Date", descending: true)
            .snapshots(),

        // builder
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data'),
            );
          } else {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: ListView(
                children: snapshot.data!.docs.map((documents) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: ListTile(
                      title: Text(
                        "Registered Device Id : " + documents['DeviceID'] + " ",
                        style: const TextStyle(
                          fontSize: 17.0,
                          height: 1.5,
                        ),
                      ),
                      subtitle: Text(
                        documents['Date'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          height: 2.0,
                        ),
                      ),
                      leading: Text(
                        documents['Time'],
                      ),
                      trailing: const Icon(Icons.history_toggle_off),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  void getHistory() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('History')
        .doc(_userId)
        .collection('History')
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    for (var element in documents) {
      print(element['Date']);
    }
  }
}
