import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyNotifications extends StatefulWidget {
  const MyNotifications({Key? key}) : super(key: key);

  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  final User? user = FirebaseAuth.instance.currentUser;
  // uid
  late String _userId;

  @override
  void initState() {
    super.initState();
    setState(() {
      _userId = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
        // stream
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .doc(_userId)
            .collection('Notifications')
            .orderBy("Date", descending: true)
            .snapshots(),

        // builder
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.size == 0) {
            // if usr use for first time
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/social/no_notification.png"),
                          width: MediaQuery.of(context).size.width * 0.68,
                        ),
                        const Text(
                          'No Notifications!',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: snapshot.data!.docs.map((documents) {
                  return Card(
                    // color: Colors.grey[850],
                    color: customColor(documents["Type"]),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    shadowColor: Colors.grey[300],
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                      left: 7.0,
                      right: 7.0,
                    ),
                    child: ListTile(
                      title: Text(
                        "Message : " + documents['Body'] + " ",
                        style: const TextStyle(
                          fontSize: 17.0,
                          height: 1.3,
                        ),
                      ),
                      subtitle: Text(
                        documents['Date'],
                        style: const TextStyle(
                          fontSize: 14.0,
                          height: 2.5,
                        ),
                      ),
                      leading: Text(
                        documents['Time'],
                      ),
                      // trailing: const Icon(Icons.history_toggle_off),
                      trailing: customIcon(documents['Type']),
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
}

customColor(document) {
  if (document == "Alert") {
    return Colors.red.shade300;
  } else {
    return Colors.grey[850];
  }
}

customIcon(document) {
  if (document == "Alert") {
    return const Icon(Icons.notifications_on_outlined);
  } else {
    return const Icon(Icons.message_outlined);
  }
}
