import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Constants.bgColor,
        title: Container(
          height: 8.0.h,
          width: 30.0.w,
          child: Image.asset('assets/images/beingPupil.png', fit: BoxFit.contain)),
      ),
        body: Container(
      child: Center(
        child: Text('Home Screen'),
      ),
    ));
  }
}
