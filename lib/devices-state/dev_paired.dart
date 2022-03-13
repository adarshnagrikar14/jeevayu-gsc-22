// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jeevayu/dashboard.dart';
import 'package:jeevayu/features/notification_api.dart';
import 'package:jeevayu/features/slider_btn.dart';
import 'package:jeevayu/splashscreen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DevicePaired extends StatefulWidget {
  const DevicePaired({Key? key}) : super(key: key);

  @override
  _DevicePairedState createState() => _DevicePairedState();
}

class _DevicePairedState extends State<DevicePaired> {
  static const method1 = MethodChannel('com.project/DeviceID');
  late String _devID = "";

  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _dbref = FirebaseDatabase.instance.ref();
  late Timer _timer;
  late int _percent = 0;

  late String _profile;

  late String _numberH = "-- --";
  late String _addressH = "-- --\n-- --";
  late String _nameH = "-- --";

  final Color _bluedark = HexColor('25383c');
  final Color _darkGrey = HexColor('212121');

  late BuildContext _buildContext;

  @override
  void initState() {
    // using timer to update data in 10 sec interval
    // _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
    //   handleWeightData(_devID);
    // });

    // get the device ID
    getID();

    setState(() {
      _profile = user!.photoURL!;
      _buildContext = context;
    });

    // init
    super.initState();
  }

  Future<void> setDevIDNo() async {
    var data = <String, dynamic>{"data": ""};
    String value = await method1.invokeMethod("setDeviceID", data);
    print(value);
  }

  Future getID() async {
    final String _val = await method1.invokeMethod('getDeviceID');
    setState(() {
      _devID = _val;
    });
    handleWeightData(_val);
    getCommunications(_val);
  }

  Future getCommunications(String val) async {
    var collection = FirebaseFirestore.instance.collection('Providers');
    var docSnapshot = await collection.doc(val).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String _num = data?['Number'];
      String _add = data?['Address'];
      String _nam = data?['Name'];
      setState(() {
        _numberH = _num;
        _nameH = _nam;
        _addressH = _add;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: customDisplay(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     handleHistory();
      //   },
      //   child: const Icon(Icons.stop),
      // ),
    );
  }

  // custom card to be displayed
  Widget customDisplay() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(
        children: [
          // main card
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // shadowColor: Colors.grey.shade500,
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          top: 14.0,
                        ),
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          percent: _percent / 100,
                          animation: true,
                          backgroundColor: Colors.grey.shade700,
                          animationDuration: 900,
                          circularStrokeCap: CircularStrokeCap.round,
                          lineWidth: 13.0,
                          animateFromLastPercent: true,
                          center: Text(
                            _percent.toString() + " %",
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          rotateLinearGradient: false,
                          linearGradient: LinearGradient(
                            colors: [
                              Colors.green.shade200,
                              Colors.green.shade400,
                              Colors.green,
                            ],
                            begin: Alignment.topLeft,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, left: 28.0),
                              child: Text(
                                "Device ID- " + _devID,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  height: 1.2,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 18.0, left: 28.0, bottom: 8.0),
                              child: Text(
                                'Connected on:\n03/03/2022 | 11:02 P.M',
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // o2 quantity
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 18.0,
                    ),
                    child: Text(
                      "Approx Oxygen Quantity (In Litres) - 20 L",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // current weight- total weight
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: Text(
                      "Current Weight- 17 KG    Total Weight- 20 KG",
                      style: TextStyle(
                        fontSize: 16.5,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        "1/5",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50.0,
                  )
                ],
              ),
            ),
          ),

          // hospital info
          Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            // shadowColor: Colors.grey.shade500,
            elevation: 10.0,
            margin:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(
                    // height: 90.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // icon-h
                        const Expanded(
                          child: CircleAvatar(
                            radius: 50.0,
                            child: ClipOval(
                              child: Image(
                                image: AssetImage("assets/social/nurse.png"),
                                height: 100.0,
                                width: 100.0,
                              ),
                            ),
                          ),
                          flex: 3,
                        ),

                        // details-h
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 22.0,
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nameH,
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _addressH,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  _numberH,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    height: 1.8,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          // share qr card
          GestureDetector(
            onTap: () {
              showSheet();
            },

            // QR sharing
            child: Card(
              color: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              // shadowColor: Colors.grey.shade500,
              elevation: 10.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      // height: 90.0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          title: const Text(
                            "Share this device's QR code",
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.5,
                            ),
                          ),
                          subtitle: const Text(
                            "It will enable other users to receive the status of this device.",
                            style: TextStyle(
                              fontSize: 15.0,
                              height: 1.5,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Emergency Contact
          GestureDetector(
            onTap: () => showEmergencySheet(),
            child: Card(
              color: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 10.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      // height: 90.0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          title: const Text(
                            "Emergency Contact",
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.5,
                            ),
                          ),
                          subtitle: const Text(
                            "In case of Emergency, try using this option as early as possible.",
                            style: TextStyle(
                              fontSize: 15.0,
                              height: 1.5,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // unregister
          GestureDetector(
            onTap: (() {
              showUnregister();
            }),
            child: Card(
              color: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              // shadowColor: Colors.grey.shade500,
              elevation: 10.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      // height: 90.0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          title: const Text(
                            "Unregister this Device.",
                            style: TextStyle(
                              fontSize: 20.0,
                              height: 1.5,
                            ),
                          ),
                          subtitle: const Text(
                            "Stop receiving the further status of connected device.",
                            style: TextStyle(
                              fontSize: 15.0,
                              height: 1.5,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // info
          const SizedBox(
            height: 13.0,
          ),
        ],
      ),
    );
  }

  void showSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        enableDrag: true,
        // backgroundColor: Colors.grey[850],
        backgroundColor: _bluedark,
        builder: (BuildContext context) {
          return SizedBox(
            height: 470.0,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                      top: 20.0,
                    ),
                    child: Text(
                      'Share QR',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "To Share, scan the QR below.",
                    style: TextStyle(
                      height: 1.3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: Divider(
                      color: Colors.grey.shade300,
                      height: 1.2,
                    ),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      // color: Colors.white,
                      child: QrImage(
                        data: "JzaS3ZCkpxFy88Zh",
                        size: 220,
                        gapless: false,
                        version: 1,
                        eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square, color: Colors.black),
                      ),
                    ),
                  ),

                  // btn
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        // handleScan();
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 80.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            fontSize: 23.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  // handles unregistertion just after history adding
  void handleUnregister() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Notifications');

    Future<QuerySnapshot> books = FirebaseFirestore.instance
        .collection('Notifications')
        .doc(user!.uid)
        .collection("Notifications")
        .get();

    books.then((value) {
      for (var element in value.docs) {
        collection
            .doc(user!.uid)
            .collection("Notifications")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      }
    }).whenComplete(
      () {
        setDevIDNo();

        Navigator.pushReplacement(
          _buildContext,
          MaterialPageRoute(
            builder: (context) => const ScreenSplash(),
          ),
        );
      },
    );
  }

  // handles history adding as soon as it disconnects and then trig handleUnregister();
  void handleHistory() {
    String liveDate = DateFormat('dd/MM/yy').format(DateTime.now()).toString();
    String liveTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

    FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        DocumentReference reference = FirebaseFirestore.instance
            .collection('History')
            .doc(user!.uid)
            .collection("History")
            .doc();

        await reference.set(
          {
            "DeviceID": _devID,
            "Date": liveDate,
            "Time": liveTime,
          },
        ).whenComplete(() {
          // handle notification
          handleNotification(
              "Device Disconnected", "Device is unregistered successfully.");

          // handle unregister
          handleUnregister();
        }).onError((error, stackTrace) {
          handleNotification("Error Occurred",
              "There was an error connecting to the server , kindly Retry!");
        });
      },
    );
  }

  void handleNotification(String s, String t) {
    NotificationApi.showNotification(
      title: s,
      body: t,
      payload: "app.notification",
    );
  }

  handleWeightData(String val) {
    try {
      _dbref.child(val).child("Weight").once().then((value) {
        print(value.snapshot.value);

        // for 80Kg weight = 100/80 = 1.25
        int _value = value.snapshot.value! as int;

        double _va = (_value.toDouble()) * 1.25;

        setState(() {
          _percent = _va.toInt();
        });
      }).onError((error, stackTrace) {
        print(error);
      });
    } catch (e) {
      print(e);
    }
  }

  showEmergencySheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      enableDrag: true,
      // backgroundColor: _bluedark,
      backgroundColor: Colors.green,
      builder: (BuildContext context) {
        return SizedBox(
          height: 195.0,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 4.0,
                    top: 20.0,
                  ),
                  child: Text(
                    'Emergency Contact',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  "Use it in case of necessity.",
                  style: TextStyle(
                    height: 1.3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: Divider(
                    color: Colors.grey.shade300,
                    height: 1.2,
                  ),
                ),

                // main section - em
                SliderButton(
                  action: () {
                    Navigator.pop(context);
                  },
                  label: const Text(
                    "Contact us     ",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  // icon: const ,
                  backgroundColor: _bluedark,
                  shimmer: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showUnregister() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        enableDrag: true,
        backgroundColor: _bluedark,
        // backgroundColor: Colors.green,
        builder: (BuildContext context) {
          return SizedBox(
            height: 225.0,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 4.0,
                      top: 30.0,
                    ),
                    child: Text(
                      'Are you sure you want to unregister ?',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // main section
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // no-btn
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: const BorderSide(
                                  color: Colors.lightGreen,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 21.0, vertical: 18.0),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),

                        // btn-yes
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            handleHistory();
                          },
                          // style: ButtonStyle(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: const BorderSide(
                                  color: Colors.lightGreen,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 16.0),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
