import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LearnerProfileViewScreen extends StatelessWidget {
  const LearnerProfileViewScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Constants.bgColor,
        leading: IconButton(
          icon: Icon(
            Icons.west_rounded,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: //null,
              () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        title: Text(
          'Study Buddy',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
              height: 50.0.h,
              width: 100.0.w,
              //color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 4.0.w),
                child: Column(
                  children: <Widget>[
                    //Profile DP
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/edProfile.png',
                        height: 20.5.h,
                        width: 36.5.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    //Name of Learner
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.h),
                      child: Text(
                        'Natasha Young',
                        style: TextStyle(
                            fontSize: 12.0.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Constants.bgColor),
                      ),
                    ),
                    //Degree
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.h),
                      child: Text(
                        'B.tech | M.S University',
                        style: TextStyle(
                            fontSize: 10.0.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            color: Constants.bgColor),
                      ),
                    ),
                    //Location
                    Padding(
                      padding: EdgeInsets.only(top: 2.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ImageIcon(AssetImage('assets/icons/locationPin.png'),
                          color: Constants.bgColor,
                          size: 15.0,),
                          SizedBox(
                            width: 0.5.w,
                          ),
                          Text(
                            'Talwandi, Kota',
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                color: Constants.bgColor),
                          ),
                        ],
                      ),
                    ),   
                    //Social Handle
                  Padding(
                    padding: EdgeInsets.only(top: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            print('Apple!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/apple.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Google!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/google.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Facebook!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/facebook.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('LinkedIn!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/linkedin.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                      ],
                    ),
                  ),            
                  ],
                ),
              ),
            ),
      ),
    );
  }
}