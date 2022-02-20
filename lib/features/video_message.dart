import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VideoMessage extends StatefulWidget {
  const VideoMessage({Key? key}) : super(key: key);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Record Message',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.grey[850],
        toolbarHeight: 60,
        elevation: 10,
      ),
      body: Column(
        children: [
          // lottie animation:
          Expanded(
            child: Center(
              child: Lottie.asset(
                'assets/lottie/notify.json',
                height: 160.0,
                repeat: true,
                reverse: true,
              ),
            ),
            flex: 4,
          ),

          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'The feature is being tested. Once done , will be updated soon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white70,
                ),
              ),
            ),
            flex: 3,
          ),

          const Expanded(
            child: Center(),
            flex: 5,
          )
        ],
      ),
    );
  }
}
