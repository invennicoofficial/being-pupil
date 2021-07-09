import 'package:flutter/material.dart';

class LearnerScreen extends StatefulWidget {
  LearnerScreen({Key key}) : super(key: key);

  @override
  _LearnerScreenState createState() => _LearnerScreenState();
}

class _LearnerScreenState extends State<LearnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Text('Learner Screen'),
      ),
    ));
  }
}