import 'dart:async';

import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'OnBoarding_Screens/OnBoarding_Screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil().init(constraints, orientation);
        return MaterialApp(
            debugShowCheckedModeBanner: false, home: SplashScreen());
      });
    });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen())));
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColor,
      body: Stack(
        children: [
          Container(
            height: 100.0.h,
            width: 100.0.w,
            decoration: BoxDecoration(
              color: Constants.bgColor,
            ),
            child:
                Image.asset('assets/images/background.png', fit: BoxFit.cover),
          ),
          Center(
            child: Image.asset(
              'assets/images/beingPupil.png',
              height: 15.0.h,
              width: 90.0.w,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 18.0.h),
            child: Center(
              child: Text(
                'Student of Life',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }
}
