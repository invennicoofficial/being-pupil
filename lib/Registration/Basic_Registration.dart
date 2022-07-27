import 'dart:io';

import 'package:being_pupil/Account/Terms_And_Policy_Screen.dart';
import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Login/Login_Screen.dart';
import 'package:being_pupil/Login/OTP_Screen.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Model_Class.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

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
  bool checkboxValue = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
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
                      TextInputWidget(
                        textEditingController: nameController,
                        lable: 'Name',
                        onChanged: (val) {
                          isEmpty();
                        },
                      ),
                      NumberInputWidget(
                        textEditingController: mobileController,
                        lable: 'Phone Number',
                        onChanged: (val) {
                          isEmpty();
                        },
                      ),
                      TextInputWidget(
                        textEditingController: emailController,
                        lable: 'Email',
                        onChanged: (val) {
                          isEmpty();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w,
                            right: 3.0.w,
                            top: 3.0.h,
                            bottom: 0.0.h),
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
                            ],
                          ),
                          onChange: (String value, int index) async {
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
                            isEmpty();
                          },
                          dropdownButtonStyle: DropdownButtonStyle(
                            height: Constants.constHeight,
                            width: 90.0.w,
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
                                        SizedBox(width: 48.0.w)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: CheckboxListTile(
                          value: checkboxValue,
                          onChanged: (val) {
                            setState(() {
                              checkboxValue = !checkboxValue;
                            });
                            isEmpty();
                          },
                          title: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return TermsAndPolicyScreen();
                                    },
                                  ),
                                );
                              },
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 11.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Constants.bgColor),
                                ),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 11.0.sp,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      color: Constants.blueTitle),
                                )
                              ]))),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Constants.bgColor,
                          contentPadding: EdgeInsets.only(left: 2.0.w),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.0.w, top: 0.0.h),
                        child: GestureDetector(
                            onTap: isButtonEnabled
                                ? () {
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9."
                                            r"!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(emailController.text.trim());
                                    bool mobileValid = RegExp(r"^[6-9]\d{9}$")
                                        .hasMatch(mobileController.text);

                                    if (checkboxValue == false) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please Accept Tearms & Condition",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (nameController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Name",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (mobileController.text.isEmpty ||
                                        (mobileValid == false)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Please Enter Valid Mobile Number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (emailController.text
                                            .trim()
                                            .isEmpty ||
                                        (emailValid == false)) {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Valid Email Id",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (registerAs == 'notSelected') {
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
                                          Platform.isAndroid ? 'A' : 'I');
                                    }
                                  }
                                : null,
                            child: ButtonWidget(
                              btnName: 'SIGN UP',
                              isActive: isButtonEnabled,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      SizedBox(
                        height: 12.0.h,
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
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: LoginScreen()));
                            },
                            child: Container(
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

  bool isEmpty() {
    setState(() {
      if ((nameController.text.isNotEmpty) &&
          (mobileController.text.isNotEmpty) &&
          (emailController.text.isNotEmpty) &&
          (registerAs != 'notSelected') &&
          (checkboxValue == true)) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }

  _signInCC(BuildContext context, CubeUser user, result) async {
    if (!CubeSessionManager.instance.isActiveSessionValid()) {
      try {
        await createSession();
      } catch (error) {
        _processLoginError(error);
      }
    }
    signUp(user).then((newUser) async {
      user.id = newUser.id;
      SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
      sharedPrefs.saveNewUser(user);
      closeProgressDialog(context);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: OtpScreen(
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
    //log("Login error $exception", TAG);
    setState(() {});
    showDialogError(exception, context);
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.androidId;
    }
  }

  Future<SignUp> register(String name, String mobileNumber, String email,
      String registerAs, String deviceType) async {
    displayProgressDialog(context);
    String? deviceId = await _getId();
    var result = SignUp();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'register_as': registerAs,
        'deviceType': deviceType,
        'deviceId': deviceId == null ? '123456' : deviceId,
      });
      var response = await dio.post(Config.signupUrl, data: formData);
      if (response.statusCode == 200) {
        result = SignUp.fromJson(response.data);
        if (result.status == true) {
          saveUserData(result.data!.userId!);
          await _signInCC(
              context,
              CubeUser(
                  fullName: name,
                  login: email,
                  password: '12345678',
                  email: email),
              result);
        } else {
          closeProgressDialog(context);
          Fluttertoast.showToast(
            msg: result.message == null ? result.errorMsg! : result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      closeProgressDialog(context);
      if (e.response != null) {
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {}
    }
    return result;
  }

  void saveUserData(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('userId', userId);
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
