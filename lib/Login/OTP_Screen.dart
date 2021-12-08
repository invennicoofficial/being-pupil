import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Otp_Model.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';

class OtpScreen extends StatefulWidget {
  String mobileNumber;
  OtpScreen({
    Key key,
    this.mobileNumber,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpPinController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;
  final storage = new FlutterSecureStorage();
  String newMobNumber;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String registerAs;
  String role;
  int userId;
  String name, mobileNumber;

  void initState() {
    // TODO: implement initState
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    errorController = StreamController<ErrorAnimationType>();
    getData();
    otpPinController.text = '1234';
    newMobNumber = widget.mobileNumber;
    super.initState();
  }

  String replaceCharAt(String oldString, int index, String newString){
    return oldString.substring(0, index) + newString + oldString.substring(index + 1);
  }
  

  @override
  void dispose() {
    // TODO: implement dispose
    errorController.close();
    super.dispose();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // setState(() {
    //   registerAs = preferences.getString('RegisterAs');
    // });
    userId = preferences.getInt('userId');
    print(userId);
    print(registerAs);
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i < widget.mobileNumber.length - 3; i++){
      newMobNumber = replaceCharAt(newMobNumber, i, '*');
    }
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
                      'We sent code on your registered mobile number $newMobNumber',
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
                              left: 20.0.w, right: 20.0.w, top: 4.0.h),
                          child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
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
                                    "00:$timeLeft   |   ",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpOnBoardTitleStyle),
                                  ),
                                  Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
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
                            if (currentText.length != 4) {
                              errorController.add(ErrorAnimationType
                                  .shake); // Triggering error shake animation
                              setState(() {
                                hasError = true;
                              });
                            } else {
                              otpVerification(userId, otpPinController.text);
                              // setState(() {
                              //   //verifyOTP();
                              //   // Navigator.of(context).pushAndRemoveUntil(
                              //   //     MaterialPageRoute(
                              //   //         builder: (context) => bottomNavBar(0)),
                              //   //     (Route<dynamic> route) => false);
                              // role == 'L'
                              //     ? Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 LearnerHomeScreen()))
                              //     //(Route<dynamic> route) => false);
                              //     //}
                              //     : Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 EducatorRegistration()));
                              hasError = false;
                              // scaffoldKey.currentState.showSnackBar(SnackBar(
                              //   content: Text("Verify!!"),
                              //   duration: Duration(seconds: 2),
                              // ));
                              //});
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

  //OTP verification API
  Future<OtpResponse> otpVerification(int userId, String otp) async {
    displayProgressDialog(context);
     SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = OtpResponse();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({'user_id': userId, 'otp': otp});
      var response = await dio.post(Config.otpUrl, data: formData);
      if (response.statusCode == 200) {
        print(response.data);
        closeProgressDialog(context);
        result = OtpResponse.fromJson(response.data);
        if (result.status == true) {
          //print('TOKEN ::' + result.data.token);
          saveToken(result.data.token);
          role = result.data.userObject.role;
          name = result.data.userObject.name;
          mobileNumber = result.data.userObject.mobileNumber;
          preferences.setString('RegisterAs', role);
          print('ROLE ::' + preferences.getString('RegisterAs'));
          //print('ROLE ::' + result.data.userObject.location.toString());
         
          //print('LOCATION ::' + result.data.userObject.location.addressLine2);
         // print('EDUCATION ::' + result.data.userObject.educationalDetail.qualification);
          print('MOBILE ::' + mobileNumber);
          if(result.data.userObject.isNew == "true") {
            role == 'L'
                ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                    (Route<dynamic> route) => false)
                : Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EducatorRegistration(
                  name: name,
                  mobileNumber: mobileNumber,
                )));
          } else {
              preferences.setString("name", result.data.userObject.name);
              preferences.setString("mobileNumber", result.data.userObject.mobileNumber);
              preferences.setString("gender", result.data.userObject.gender);
              preferences.setString("email", result.data.userObject.email);
              //result.data.userObject.role == 'E' ? 
              preferences.setString("imageUrl", result.data.userObject.imageUrl);
              // : preferences.setString("imageUrl", '');
              result.data.userObject.role == 'E' ? preferences.setString("qualification", result.data.userObject.educationalDetail.qualification) : preferences.setString("qualification", '');
              result.data.userObject.role == 'E' ? preferences.setString("schoolName", result.data.userObject.educationalDetail.schoolName) : preferences.setString("schoolName",'');
              result.data.userObject.role == 'E' ? preferences.setString("address1", result.data.userObject.location.addressLine2): preferences.setString("address1", '');
              result.data.userObject.role == 'E' ? preferences.setString("address2", result.data.userObject.location.city): preferences.setString("address2", '');
              result.data.userObject.role == 'E' ? preferences.setString("facebookUrl", result.data.userObject.fbUrl) : preferences.setString("facebookUrl",'');
              result.data.userObject.role == 'E' ? preferences.setString("instaUrl", result.data.userObject.instaUrl) : preferences.setString("instaUrl",'');
              result.data.userObject.role == 'E' ? preferences.setString("linkedInUrl", result.data.userObject.liUrl) : preferences.setString("linkedInUrl", '');
              result.data.userObject.role == 'E' ? preferences.setString("otherUrl", result.data.userObject.otherUrl) : preferences.setString("otherUrl", '');
              result.data.userObject.role == 'E' ? preferences.setString("isNew", result.data.userObject.isNew) : preferences.setString("isNew", '');
              preferences.setBool('isLoggedIn', true);

          print('Gender::: ${result.data.userObject.gender}');
          print('IMAGE:::' + result.data.userObject.imageUrl);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                    (Route<dynamic> route) => false);
          }

          Fluttertoast.showToast(
            msg: result.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else {
          Fluttertoast.showToast(
            msg: result.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
        print(result);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return result;
  }

      void saveToken(String token) async {
    // Write value
    await storage.write(key: 'access_token', value: token);
    print('TOKEN ::: ' + token);
    //closeProgressDialog(context);
  }

  displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog();
        }));
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
