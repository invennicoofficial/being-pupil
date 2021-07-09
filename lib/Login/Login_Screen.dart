import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Registration/Basic_Registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'OTP_Screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _height,
        width: _width,
        child: Stack(
          children: <Widget>[
            Container(
              height: 30.0.h,
              width: 100.0.w,
              decoration: BoxDecoration(
                color: Color(0xFF231F20),
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.5.h, left: 5.0.w),
                        child: Text(
                          'LogIn',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 2.0.h, left: 5.0.w, right: 15.0.w),
                    child: Text(
                      'Login to your account using registered mobile number .',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 9.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 21.0.h, left: 5.0.w, right: 5.0.w, bottom: 3.0.h),
              child: Card(
                elevation: 5.0,
                child: Container(
                  height: 80.0.h,
                  width: 100.0.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Column(
                    children: <Widget>[
                      Theme(
                        data: new ThemeData(
                          primaryColor: Constants.bpSkipStyle,
                          primaryColorDark: Constants.bpSkipStyle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 3.0.w, right: 3.0.w, top: 4.0.h),
                          child: Container(
                            height: 7.0.h,
                            width: 90.0.w,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                labelText: "Phone Number",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                    //width: 2.0,
                                  ),
                                ),
                              ),
                              //keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                  fontFamily: "Montserrat", fontSize: 10.0.sp),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.0.w, top: 6.0.h),
                        child: GestureDetector(
                          onTap: () {
                            print('Logged In!!!');
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: OtpScreen()));
                          },
                          child: Container(
                            height: 7.0.h,
                            width: 90.0.w,
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              color: Constants.bpOnBoardTitleStyle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Constants.formBorder,
                                width: 0.15,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'LogIn'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.0.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 6.0.h),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  child: Divider(
                                color: Constants.formBorder,
                                height: 1.0.h,
                                endIndent: 0.5.w,
                              )),
                            ),
                            Text(
                              "Or",
                              style: TextStyle(
                                  color: Constants.bpOnBoardTitleStyle,
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            Expanded(
                              child: new Container(
                                  child: Divider(
                                color: Constants.formBorder,
                                height: 1.0.h,
                                indent: 0.5.w,
                              )),
                            ),
                          ])),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0.w, right: 10.0.w, top: 3.0.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                print('Apple Login!!!');
                              },
                              child: Container(
                                  height: 4.0.h,
                                  width: 8.0.w,
                                  child: Image.asset(
                                    'assets/icons/apple.png',
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            GestureDetector(
                              onTap: (){
                                print('Google Login!!!');
                              },
                              child: Container(
                                  height: 4.0.h,
                                  width: 8.0.w,
                                  child: Image.asset(
                                    'assets/icons/google.png',
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            GestureDetector(
                              onTap: (){
                                print('Facebook Login!!!');
                              },
                              child: Container(
                                  height: 4.0.h,
                                  width: 8.0.w,
                                  child: Image.asset(
                                    'assets/icons/facebook.png',
                                    fit: BoxFit.contain,
                                  )),
                            ),
                            // GestureDetector(
                            //   onTap: (){
                            //     print('LinkedIn Login!!!');
                            //   },
                            //   child: Container(
                            //       height: 4.0.h,
                            //       width: 8.0.w,
                            //       child: Image.asset(
                            //         'assets/icons/linkedin.png',
                            //         fit: BoxFit.contain,
                            //       )),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w100,
                                fontSize: 9.0.sp,
                                color: Constants.bpOnBoardTitleStyle),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: SignUpScreen()));
                              print('Register!!!');
                            },
                            child: Container(
                              height: 2.2.h,
                              width: 15.0.w,
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 9.0.sp,
                                    color: Constants.bpOnBoardTitleStyle),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
