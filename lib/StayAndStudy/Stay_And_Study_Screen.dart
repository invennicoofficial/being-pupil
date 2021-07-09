import 'package:flutter/material.dart';

class StayAndStudyScreen extends StatefulWidget {
  StayAndStudyScreen({Key key}) : super(key: key);

  @override
  _StayAndStudyScreenState createState() => _StayAndStudyScreenState();
}

class _StayAndStudyScreenState extends State<StayAndStudyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Text('Stay and Study Screen'),
      ),
    ));
  }
}