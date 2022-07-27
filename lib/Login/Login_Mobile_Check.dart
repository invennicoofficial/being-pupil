import 'dart:io';

import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'Registration_After_Login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginMobileCheckScreen extends StatefulWidget {
  String? socialId,
      registrationType,
      socialDisplayName,
      socialEmail,
      socialPhotoUrl;
  LoginMobileCheckScreen(
      {Key? key,
      required this.socialId,
      required this.registrationType,
      required this.socialDisplayName,
      required this.socialEmail,
      required this.socialPhotoUrl})
      : super(key: key);

  @override
  _LoginMobileCheckScreenState createState() => _LoginMobileCheckScreenState();
}

class _LoginMobileCheckScreenState extends State<LoginMobileCheckScreen> {
  final TextEditingController mobileController = TextEditingController();

  final storage = new FlutterSecureStorage();
  String? role;
  Map<String, dynamic>? map;
  List<dynamic>? mapData;
  FocusNode? mobileFocus;

  @override
  void initState() {
    super.initState();
    mobileFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        mobileFocus!.unfocus();
      },
      child: Scaffold(
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
                      padding: EdgeInsets.only(
                          top: 1.0.h, left: 5.0.w, right: 5.0.w),
                      child: Text(
                        'Please provide your number to proceed further.',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        NumberInputWidget(
                          textEditingController: mobileController,
                          lable: 'Phone Number',
                          autoFocus: true,
                          focusNode: mobileFocus,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 3.0.w, right: 3.0.w, top: 6.0.h),
                          child: GestureDetector(
                            onTap: () {
                              bool mobileValid = RegExp(r"^[6-9]\d{9}$")
                                  .hasMatch(mobileController.text);

                              if (mobileController.text.isEmpty ||
                                  (mobileValid == false)) {
                                Fluttertoast.showToast(
                                  msg: 'Please Enter Valid Mobile Number',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp,
                                );
                              } else {
                                mobileCheckApi(mobileController.text);
                              }
                            },
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 4.0.h),
                                child: ButtonWidget(
                                  btnName: 'CONTINUE',
                                  isActive: true,
                                  fontWeight: FontWeight.w700,
                                )),
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
      ),
    );
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

  Future<void> mobileCheckApi(String mobileNumber) async {
    displayProgressDialog(context);
    String? deviceId = await _getId();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'mobile_number': mobileNumber,
        'deviceType': Platform.isAndroid ? 'A' : 'I',
        'deviceId': deviceId == null ? '123456' : deviceId,
        'registration_type': widget.registrationType,
        'social_login_details[display_name]': widget.socialDisplayName,
        'social_login_details[email]': widget.socialEmail,
        'social_login_details[photoURL]': widget.socialPhotoUrl,
        'social_login_details[uid]': widget.socialId
      });
      var response = await dio.post(Config.mobileCheckUrl, data: formData);
      if (response.statusCode == 200) {
        map = response.data;

        closeProgressDialog(context);

        if (map!['status'] == true) {
          if (map!['data']['userObj'] == null) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: SignUpAfterLoginScreen(
                      mobileNumber: mobileController.text,
                      name: widget.socialDisplayName,
                      registrationType: widget.registrationType,
                      socialDisplayName: widget.socialDisplayName,
                      socialEmail: widget.socialEmail,
                      socialPhotoUrl: widget.socialPhotoUrl,
                      socialId: widget.socialId,
                    )));
          } else {
            Fluttertoast.showToast(
              msg: map!['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Constants.bgColor,
              textColor: Colors.white,
              fontSize: 10.0.sp,
            );
            role = map!['data']['userObj']['register_as'];
            saveUserData(map!['data']['userObj']['user_id']);
            saveToken(map!['data']['access_token']);

            preferences.setInt('userId', map!['data']['userObj']['user_id']);
            preferences.setString('RegisterAs', role!);
            preferences.setString("name", map!['data']['userObj']['name']);
            preferences.setString(
                "mobileNumber", map!['data']['userObj']['mobile_number']);
            preferences.setString(
                "gender",
                map!['data']['userObj']['gender'] != null
                    ? map!['data']['userObj']['gender']
                    : '');

            preferences.setString(
                "imageUrl", map!['data']['userObj']['image_url']);

            if (map!['data']['userObj']['isNew'] == 'false') {
              role == 'E'
                  ? preferences.setString(
                      "qualification",
                      map!['data']['userObj']['educational_details']
                          .last['qualification'])
                  : preferences.setString("qualification", '');
              role == 'E'
                  ? preferences.setString(
                      "schoolName",
                      map!['data']['userObj']['educational_details']
                          .last['school_name'])
                  : preferences.setString("schoolName", '');
              role == 'E'
                  ? preferences.setString("address1",
                      map!['data']['userObj']['location'][0]['address_line1'])
                  : preferences.setString("address1", '');
              role == 'E'
                  ? preferences.setString("address2",
                      map!['data']['userObj']['location'][0]['city'])
                  : preferences.setString("address2", '');

              role == 'E'
                  ? preferences.setString(
                      "isNew", map!['data']['userObj']['isNew'])
                  : preferences.setString("isNew", '');
              preferences.setBool('isLoggedIn', true);
            }

            if (role == 'E' && map!['data']['userObj']['isNew'] == 'true') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EducatorRegistration(
                      name: map!['data']['userObj']['name'].toString(),
                      mobileNumber: mobileNumber,
                      email: map!['data']['userObj']['email'].toString())));
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                  (Route<dynamic> route) => false);
            }
          }
        } else {
          if (map!['message'] == null) {
            Fluttertoast.showToast(
              msg: map!['error_msg'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Constants.bgColor,
              textColor: Colors.white,
              fontSize: 10.0.sp,
            );
          } else {
            Fluttertoast.showToast(
              msg: map!['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Constants.bgColor,
              textColor: Colors.white,
              fontSize: 10.0.sp,
            );
          }
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
  }

  void saveToken(String token) async {
    await storage.write(key: 'access_token', value: token);
  }

  void saveUserData(int? userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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
