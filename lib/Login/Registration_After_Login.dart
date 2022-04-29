import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Social_Login_Model.dart';
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
  final String? mobileNumber, name, registrationType, socialDisplayName, socialEmail, socialPhotoUrl, socialId;
  SignUpAfterLoginScreen({Key? key, this.mobileNumber, this.name, this.registrationType, this.socialDisplayName, this.socialEmail, this.socialPhotoUrl, this.socialId})
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
    // TODO: implement initState
    // //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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
                        EdgeInsets.only(top: 2.0.h, left: 5.0.w, right: 15.0.w),
                    child: Text(
                      'Please provide the required details to set-up your account.',
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
                              left: 3.0.w, right: 3.0.w, top: 3.0.h),
                          child: Container(
                            height: 7.0.h,
                            width: 90.0.w,
                            //color: Color(0xFFF0F2F4),
                            child: TextFormField(
                              controller: mobileController,
                              readOnly: true,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: "Phone Number",
                                labelStyle: TextStyle(
                                    color: Constants.bpSkipStyle,
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(
                                    color: Constants.bpSkipStyle,
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                              //print(value);
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
                              //print('Preffff ::: ' +
                                 // sharedPreferences.getString('RegisterAs')!);
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
                            left: 3.0.w, right: 3.0.w, top: 30.0.h),
                        child: GestureDetector(
                          onTap: () {
                            //print('Sign Up!!!');
                            //signUp(nameController.text.trim(), mobileController.text.trim(), registerAs, deviceType, deviceId)
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
                              login(
                                  nameController.text.trim(),
                                  widget.mobileNumber,
                                  registerAs,
                                  'A');
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
      //print("signUp newUser $newUser");
      user.id = newUser.id;
      SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
      sharedPrefs.saveNewUser(user);
      // Navigator.push(
      //     context,
      //     PageTransition(
      //         type: PageTransitionType.fade,
      //         child: OtpScreen(
      //           mobileNumber: mobileController.text,
      //         )));
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
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    //print('DID:::'+androidDeviceInfo.androidId.toString());
    return androidDeviceInfo.androidId; // unique ID on Android
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
        //print(response.data);
        closeProgressDialog(context);
        result = SocialLogin.fromJson(response.data);
        //print(result.toString());
        if (result.status == true) {
          // print('ID ::: ' + result.data.userObject.userId.toString());
           saveUserData(result.data!.userObject!.userId!);
            _signInCC(
              context,
              CubeUser(
                  fullName: name,
                  login: widget.socialEmail,
                  password: '12345678',
                  email: widget.socialEmail),
              result);
          //print('ROLE ::' + result.data!.userObject!.role.toString());
          saveToken(result.data!.token!);
          preferences.setString('RegisterAs', result.data!.userObject!.role!);
          //if(result.data!.userObject!.isNew == "true") {
            result.data!.userObject!.role == 'L'
                ? Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                    (Route<dynamic> route) => false)
                : Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EducatorRegistration(
                  name: name,
                  mobileNumber: mobileNumber,
                  email: widget.socialEmail
                )));
          //} 
          // else {
              preferences.setString("name", result.data!.userObject!.name!);
              preferences.setString("mobileNumber", result.data!.userObject!.mobileNumber!);
              preferences.setString("email", widget.socialEmail!);
              //preferences.setString("gender", result.data!.userObject!.gender!);
          //     //result.data.userObject.role == 'E' ? 
               preferences.setString("imageUrl", result.data!.userObject!.imageUrl!);
          //     // : preferences.setString("imageUrl", '');
              // result.data.userObject.role == 'E' ? preferences.setString("qualification", result.data.userObject.educationalDetail.qualification) : preferences.setString("qualification", '');
              // result.data.userObject.role == 'E' ? preferences.setString("schoolName", result.data.userObject.educationalDetail.schoolName) : preferences.setString("schoolName",'');
              // result.data.userObject.role == 'E' ? preferences.setString("address1", result.data.userObject.location.addressLine2): preferences.setString("address1", '');
              // result.data.userObject.role == 'E' ? preferences.setString("address2", result.data.userObject.location.city): preferences.setString("address2", '');
              // result.data.userObject.role == 'E' ? preferences.setString("facebookUrl", result.data.userObject.fbUrl) : preferences.setString("facebookUrl",'');
              // result.data.userObject.role == 'E' ? preferences.setString("instaUrl", result.data.userObject.instaUrl) : preferences.setString("instaUrl",'');
              // result.data.userObject.role == 'E' ? preferences.setString("linkedInUrl", result.data.userObject.liUrl) : preferences.setString("linkedInUrl", '');
              // result.data.userObject.role == 'E' ? preferences.setString("otherUrl", result.data.userObject.otherUrl) : preferences.setString("otherUrl", '');
              // result.data.userObject.role == 'E' ? preferences.setString("isNew", result.data.userObject.isNew) : preferences.setString("isNew", '');
              preferences.setBool('isLoggedIn', true);
              preferences.setInt('isSubscribed', 0);

          // print('Gender::: ${result.data.userObject.gender}');
          // print('IMAGE:::' + result.data.userObject.imageUrl);

          //   Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(builder: (context) => bottomNavBar(0)),
          //           (Route<dynamic> route) => false);
          // }
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.fade,
          //         child: OtpScreen(
          //           mobileNumber: mobileController.text,
                 // )));
          // Fluttertoast.showToast(
          //   msg: result.message!,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Constants.bgColor,
          //   textColor: Colors.white,
          //   fontSize: 10.0.sp,
          // );
        } else {
          Fluttertoast.showToast(
            msg: 
            //result.message == null ?
             result.errorMsg!,
            // : result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
        //print(result);
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        //print("This is the error message::::" +
            //e.response!.data['meta']['message']);
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
        //print(e.message);
      }
    }
    return result;
  }

  void saveToken(String token) async {
    // Write value
    await storage.write(key: 'access_token', value: token);
    //print('TOKEN ::: ' + token);
    //closeProgressDialog(context);
  }

  void saveUserData(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('userId', userId);
    //print(userId);
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
