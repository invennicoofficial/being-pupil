import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Social_Login_Model.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:connectycube_sdk/connectycube_core.dart';

class SignUpAfterLoginScreen extends StatefulWidget {
  final String? mobileNumber,
      name,
      registrationType,
      socialDisplayName,
      socialEmail,
      socialPhotoUrl,
      socialId;
  SignUpAfterLoginScreen(
      {Key? key,
      this.mobileNumber,
      this.name,
      this.registrationType,
      this.socialDisplayName,
      this.socialEmail,
      this.socialPhotoUrl,
      this.socialId})
      : super(key: key);

  @override
  _SignUpAfterLoginScreen createState() => _SignUpAfterLoginScreen();
}

class _SignUpAfterLoginScreen extends State<SignUpAfterLoginScreen> {
  String registerAs = 'notSelected';
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final storage = new FlutterSecureStorage();
  static const String TAG = "_LoginPageState";

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name!;
    mobileController.text = widget.mobileNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: 100.0.h,
        width: 100.0.w,
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
                        padding: EdgeInsets.only(top: 5.5.h, left: 2.0.w),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.west_outlined,
                                  color: Colors.white),
                              iconSize: 30.0,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Text(
                              'LogIn',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 1.0.h, left: 5.0.w, right: 5.0.w),
                    child: Text(
                      'Please provide the required details to set-up your account.',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13.0,
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
                      NumberInputWidget(
                          textEditingController: mobileController,
                          lable: 'Phone Number'),
                      TextInputWidget(
                          textEditingController: nameController, lable: 'Name'),
                      Padding(
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
                            ],
                          ),
                          onChange: (String value, int index) async {
                            if (int.parse(value) == 1) {
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
                                        SizedBox(width: 50.0.w)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.0.w, top: 30.0.h),
                        child: GestureDetector(
                          onTap: () {
                            if (nameController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Name",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp);
                            } else if (mobileController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Mobile Number",
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
                              login(nameController.text.trim(),
                                  widget.mobileNumber, registerAs, 'A');
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
                                'Continue'.toUpperCase(),
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

  Future<SocialLogin> login(String name, String? mobileNumber,
      String registerAs, String deviceType) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    displayProgressDialog(context);
    String? deviceId = await _getId();
    var result = SocialLogin();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'name': name,
        'mobile_number': mobileNumber,
        'register_as': registerAs,
        'deviceType': deviceType,
        'deviceId': deviceId == null ? '123456' : deviceId,
        'registration_type': widget.registrationType,
        'social_login_details[display_name]': widget.socialDisplayName,
        'social_login_details[email]': widget.socialEmail,
        'social_login_details[photoURL]': widget.socialPhotoUrl,
        'social_login_details[uid]': widget.socialId,
      });
      var response = await dio.post(Config.loginUrl, data: formData);
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        result = SocialLogin.fromJson(response.data);

        if (result.status == true) {
          saveUserData(result.data!.userObject!.userId!);
          _signInCC(
              context,
              CubeUser(
                  fullName: name,
                  login: widget.socialEmail,
                  password: '12345678',
                  email: widget.socialEmail),
              result);

          saveToken(result.data!.token!);
          preferences.setString('RegisterAs', result.data!.userObject!.role!);

          result.data!.userObject!.role == 'L'
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                  (Route<dynamic> route) => false)
              : Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EducatorRegistration(
                      name: name,
                      mobileNumber: mobileNumber,
                      email: widget.socialEmail)));

          preferences.setString("name", result.data!.userObject!.name!);
          preferences.setString(
              "mobileNumber", result.data!.userObject!.mobileNumber!);
          preferences.setString("email", widget.socialEmail!);

          preferences.setString("imageUrl", result.data!.userObject!.imageUrl!);

          preferences.setBool('isLoggedIn', true);
          preferences.setInt('isSubscribed', 0);
        } else {
          Fluttertoast.showToast(
            msg: result.errorMsg!,
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

  void saveToken(String token) async {
    await storage.write(key: 'access_token', value: token);
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
