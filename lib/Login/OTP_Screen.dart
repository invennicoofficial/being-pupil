import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Registration/Basic_Registration.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpPinController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void initState() {
    // TODO: implement initState
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
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
                          'OTP',
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
                      'We sent code on your registered mobile number *******999',
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
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 5.0.w, right: 5.0.w, top: 4.0.h),
                          child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 6,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(2),
                                  fieldHeight: 40,
                                  fieldWidth: 40,
                                  borderWidth: 1.0,
                                  activeFillColor: hasError
                                      ? Colors.transparent
                                      : Colors.white,
                                  activeColor: Constants.formBorder,
                                  selectedColor: Constants.formBorder,
                                  inactiveColor: Constants.formBorder,
                                ),
                                cursorColor: Constants.bpOnBoardTitleStyle,
                                animationDuration: Duration(milliseconds: 300),
                                backgroundColor: Colors.white,
                                autoDismissKeyboard: true,
                                enableActiveFill: false,
                                errorAnimationController: errorController,
                                controller: otpPinController,
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                        child: ArgonTimerButton(
                          initialTimer: 15,
                          // Optional
                          height: 50,
                          width: 80.0.w,
                          minWidth: 45.0.w,
                          disabledColor: Colors.transparent,
                          color: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          disabledTextColor: Colors.transparent,
                          elevation: 0.0,
                          disabledElevation: 0.0,
                          focusElevation: 0.0,
                          highlightElevation: 0.0,
                          hoverElevation: 0.0,
                          borderRadius: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Resend OTP',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 9.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Constants.bpOnBoardTitleStyle)),
                            ],
                          ),
                          loader: (timeLeft) {
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "00:$timeLeft | ",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpOnBoardTitleStyle),
                                  ),
                                  Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.otpText),
                                  ),
                                ],
                              ),
                            );
                          },
                          onTap: (startTimer, btnState) {
                            if (btnState == ButtonState.Idle) {
                              startTimer(15);
                              setState(() {
                                otpPinController.clear();
                              });
                              //resendOTP();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 5.0.w, right: 5.0.w, top: 4.0.h),
                        child: GestureDetector(
                          onTap: () {
                            print('Verify!!!');
                            if (currentText.length != 6) {
                              errorController.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() {
                                hasError = true;
                              });
                            } else {
                              setState(() {
                                //verifyOTP();
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => bottomNavBar(0)),
                                //     (Route<dynamic> route) => false);
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => EducatorRegistration()));
                                hasError = false;
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Verify!!"),
                                  duration: Duration(seconds: 2),
                                ));
                              });
                            }
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
                                'Verify'.toUpperCase(),
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
