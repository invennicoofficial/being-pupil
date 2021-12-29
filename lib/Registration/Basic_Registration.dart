import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Login/Login_Screen.dart';
import 'package:being_pupil/Login/OTP_Screen.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Model_Class.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Preference.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String registerAs = 'notSelected';
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  static const String TAG = "_LoginPageState";

  @override
  void initState() {
    // TODO: implement initState
    // //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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
                          'Sign Up',
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
                      'To use our services , please enter the required details to create your account.',
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
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat", 
                                  fontSize: 10.0.sp
                                ),
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
                      Theme(
                        data: new ThemeData(
                          primaryColor: Constants.bpSkipStyle,
                          primaryColorDark: Constants.bpSkipStyle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 3.0.w, right: 3.0.w, top: 3.0.h),
                          child: Container(
                            height: 7.0.h,
                            width: 90.0.w,
                            child: TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                labelText: "Phone Number",
                                labelStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat", 
                                  fontSize: 10.0.sp
                                ),
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
                      Theme(
                        data: new ThemeData(
                          primaryColor: Constants.bpSkipStyle,
                          primaryColorDark: Constants.bpSkipStyle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 3.0.w, right: 3.0.w, top: 3.0.h),
                          child: Container(
                            height: 7.0.h,
                            width: 90.0.w,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat", 
                                  fontSize: 10.0.sp
                                ),
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
                      Theme(
                        data: new ThemeData(
                          primaryColor: Constants.bpSkipStyle,
                          primaryColorDark: Constants.bpSkipStyle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                              bottom: 3.0.h),
                          child: CustomDropdown<int>(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.0.w),
                                  child: Text(
                                    'Register As',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                ),
                                //SizedBox(width: 50.0.w)
                              ],
                            ),
                            // icon: Icon(
                            //   Icons.expand_more,
                            //   color: Constants.bpSkipStyle,
                            // ),
                            onChange: (String value, int index) async {
                              print(value);
                              if (value == '1') {
                                setState(() {
                                  registerAs = 'E';
                                });
                              } else {
                                setState(() {
                                  registerAs = 'L';
                                });
                              }
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(
                                  'RegisterAs', registerAs);
                              print('Preffff ::: ' +
                                  sharedPreferences.getString('RegisterAs')!);
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: 7.0.h,
                              width: 90.0.w,
                              //padding: EdgeInsets.only(left: 2.0.w),
                              elevation: 0,
                              backgroundColor: Colors.white,
                              primaryColor: Constants.bpSkipStyle,
                              side: BorderSide(color: Constants.formBorder),
                            ),
                            dropdownStyle: DropdownStyle(
                              borderRadius: BorderRadius.circular(10.0),
                              elevation: 6,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.0.w, vertical: 1.5.h),
                            ),
                            items: ['Educator', 'Learner']
                                .asMap()
                                .entries
                                .map(
                                  (item) => DropdownItem<int>(
                                    value: item.key + 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            item.value,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Constants.bpSkipStyle),
                                          ),
                                          SizedBox(width: 50.0.w)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.0.w, top: 0.0.h),
                        child: GestureDetector(
                          onTap: () {
                            print('Sign Up!!!');
                            bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9."
                            r"!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(emailController.text.trim());
                            bool mobileValid = RegExp(r"^[6-9]\d{9}$").hasMatch(mobileController.text);
                            //signUp(nameController.text.trim(), mobileController.text.trim(), registerAs, deviceType, deviceId)
                            if (nameController.text.isEmpty){
                              Fluttertoast.showToast(
                                  msg: "Please Enter Name",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp);
                            } else if (mobileController.text.isEmpty || (mobileValid == false)) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Valid Mobile Number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp);
                            }
                            else if (emailController.text.trim().isEmpty ||
                                (emailValid == false)) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Valid Email Id",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp);
                            }
                            else if (registerAs == 'notSelected') {
                              Fluttertoast.showToast(
                                  msg: "Please Select Register As",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp);
                            } else {
                              register(
                                  nameController.text.trim(),
                                  mobileController.text.trim(),
                                  emailController.text.trim(),
                                  registerAs,
                                  Platform.isAndroid ? 'A' : 'I',
                                  '1234567');
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
                                'Sign Up'.toUpperCase(),
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
                      SizedBox(
                        height: 15.0.h,//20.0.h
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w100,
                                fontSize: 9.0.sp,
                                color: Constants.bpOnBoardTitleStyle),
                          ),
                          GestureDetector(
                            onTap: () {
                              print('Sign In!!!');
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: LoginScreen()));
                            },
                            child: Container(
                              // height: 2.2.h,
                              // width: 13.0.w,
                              child: Text(
                                'Sign In',
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


  //ConnectyCube

  _signInCC(BuildContext context, CubeUser user, result) async {
    if (!CubeSessionManager.instance.isActiveSessionValid()) {
      try {
        await createSession();
      } catch (error) {
        _processLoginError(error);
      }
    }
    signUp(user).then((newUser) async {
      print("signUp newUser $newUser");
      user.id = newUser.id;
      SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
      sharedPrefs.saveNewUser(user);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: OtpScreen(
            mobileNumber: mobileController.text,
          )));
      Fluttertoast.showToast(
        msg: result.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.bgColor,
        textColor: Colors.white,
        fontSize: 10.0.sp,
      );
    }).catchError((exception) {
      _processLoginError(exception);
    });
  }

  void _processLoginError(exception) {
    log("Login error $exception", TAG);
    setState(() {

    });
    showDialogError(exception, context);
  }

  Future<SignUp> register(String name, String mobileNumber, String email, String registerAs,
      String deviceType, String deviceId) async {
    displayProgressDialog(context);
    var result = SignUp();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'register_as': registerAs,
        'deviceType': deviceType,
        'deviceId': deviceId,
      });
      var response = await dio.post(Config.signupUrl, data: formData);
      if (response.statusCode == 200) {
        print(response.data);
        closeProgressDialog(context);
        result = SignUp.fromJson(response.data);
        if(result.status == true){
        print('ID ::: ' + result.data!.userId.toString());
        saveUserData(result.data!.userId!);
        _signInCC(context, CubeUser(fullName: name, login: email, password: '12345678', email: email), result);
        } else {
          Fluttertoast.showToast(
          msg: result.message!,
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
        print("This is the error message::::" +
            e.response!.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
      }
    }
    return result;
  }

    void saveUserData(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('userId', userId);
    print(userId);
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

//  Future<void> signUp() async {
//     displayProgressDialog(context);
//     var formData = FormData.fromMap({
//       'name': nameController.text.trim(),
//       'email': emailController.text.trim(),
//       'contact_number': mobileNumberController.text.trim(),
//       'password': passwordController.text.trim(),
//     });
//     try {
//       Response response = await dio.post(Config.registerUrl, data: formData);
//       Map<String, dynamic> map;
//       map = json.decode(response.toString());
//       print(map);
//       print(map['data']['profile']);
//       saveUserData(
//           map['data']['name'],
//           map['data']['email'],
//           map['data']['contact_number'],
//           map['data']['profile'] == null ? '' : map['data']['profile'],
//         map['data']['user_id']);
//       saveToken(map['meta']['auth_token']);
//     } on DioError catch (e) {
//       closeProgressDialog(context);
//       if (e.response != null) {
//         print(e.response.data);
//         print(e.response.headers);
//         print(e.response.request);
//         print("This is the error message::::" +
//             e.response.data['meta']['message']);
//         Fluttertoast.showToast(
//           msg: e.response.data['meta']['message'],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Color(0xFF1E2026),
//           textColor: Constants.mfaRed,
//           fontSize: 15,
//         );
//       } else {
//         // Something happened in setting up or sending the request that triggered an Error
//         print(e.request);
//         print(e.message);
//       }
//     }
//   }

//   void saveUserData(String name, email, mobile, profileUrl, userId) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     print(name);
//     preferences.setString(Preferences.userName, name);
//     preferences.setString(Preferences.userEmail, email);
//     preferences.setString(Preferences.userNumber, mobile);
//     preferences.setString(Preferences.userProfilePicUrl, profileUrl);
//     preferences.setString(Preferences.checkLoggedIn, "LoggedIn");
//     preferences.setString(Preferences.checkGuest, "notGuest");
//     preferences.setInt('userId', userId);
//     preferences.setString(Preferences.userTrialEndDate, '');
//     preferences.setString(Preferences.userSubscriptionEndDate, '');
//     preferences.setString('trialDate', '');
//     preferences.setString('subscriptionDate', '');
//     preferences.setBool('isSubscribed', false);
//   }

//   void saveToken(String token) async {
//     // Write value
//     await storage.write(key: 'auth_token', value: token);
//     closeProgressDialog(context);

//     //go to otp page
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => bottomNavBar(0)),
//         (Route<dynamic> route) => false);
//   }

//   displayProgressDialog(BuildContext context) {
//     Navigator.of(context).push(new PageRouteBuilder(
//         opaque: false,
//         pageBuilder: (BuildContext context, _, __) {
//           return new ProgressDialog();
//         }));
//   }

//   closeProgressDialog(BuildContext context) {
//     Navigator.of(context).pop();
//   }
