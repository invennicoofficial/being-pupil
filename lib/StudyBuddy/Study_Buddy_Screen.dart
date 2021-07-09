import 'package:flutter/material.dart';

class StudyBuddyScreen extends StatefulWidget {
  StudyBuddyScreen({Key key}) : super(key: key);

  @override
  _StudyBuddyScreenState createState() => _StudyBuddyScreenState();
}

class _StudyBuddyScreenState extends State<StudyBuddyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Text('Study Buddy Screen'),
      ),
    ));
  }
}