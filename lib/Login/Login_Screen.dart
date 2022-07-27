import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Login/AuthService.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Login_Model.dart';
import 'package:being_pupil/Model/Social_Login_Check_Model.dart';
import 'package:being_pupil/Registration/Basic_Registration.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'OTP_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_Mobile_Check.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';

import 'Verification_Screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileController = TextEditingController();
  final storage = new FlutterSecureStorage();

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? gUserData;
  Map<String, dynamic>? fbUserData;
  String registrationType = 'M';
  String? socialName;
  String? socialEmail;
  String? socialPhotoUrl;
  String? socialId;
  String? mobileNumberFromAPi;
  String? registerAs;
  String? role;
  String? name, email;
  static const String TAG = "_LoginPageState";
  FocusNode? mobileFocus;

  void initState() {
    super.initState();
    mobileFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        mobileFocus!.unfocus();
      },
      child: Scaffold(
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
                      padding: EdgeInsets.only(
                          top: 1.0.h, left: 5.0.w, right: 15.0.w),
                      child: Text(
                        'Login to your account using registered mobile number .',
                        style: TextStyle(
                            height: 1.5,
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
                            focusNode: mobileFocus!,
                            autoFocus: true,
                            textEditingController: mobileController,
                            lable: 'Phone Number'),
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
                                  login(mobileController.text);
                                }
                              },
                              child: ButtonWidget(
                                btnName: 'LOGIN',
                                isActive: true,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 6.0.h, left: 3.0.w, right: 3.0.w),
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
                        Platform.isIOS
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0.w, right: 10.0.w, top: 3.0.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          registrationType = 'A';
                                        });
                                        _handleAppleSignIn();
                                      },
                                      child: Container(
                                          height: 4.0.h,
                                          width: 8.0.w,
                                          child: SvgPicture.asset(
                                              'assets/icons/appleSvg.svg')),
                                    ),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          registrationType = 'G';
                                        });
                                        _handleGoogleSignIn();
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
                                      width: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          registrationType = 'F';
                                        });
                                        _handleFacebookSignIn();
                                      },
                                      child: Container(
                                          height: 4.0.h,
                                          width: 8.0.w,
                                          child: SvgPicture.asset(
                                              'assets/icons/fbSvg.svg')),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0.w, right: 10.0.w, top: 3.0.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          registrationType = 'G';
                                        });
                                        _handleGoogleSignIn();
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
                                      width: 24,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          registrationType = 'F';
                                        });
                                        _handleFacebookSignIn();
                                      },
                                      child: Container(
                                          height: 4.0.h,
                                          width: 8.0.w,
                                          child: Image.asset(
                                            'assets/icons/facebook.png',
                                            fit: BoxFit.contain,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 30.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              },
                              child: Container(
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

  Future<Login> login(String mobileNumber) async {
    displayProgressDialog(context);
    String? deviceId = await _getId();
    var result = Login();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'mobile_number': mobileNumber,
        'country_code': '+91',
        'deviceType': Platform.isAndroid ? 'A' : 'I',
        'deviceId': deviceId == null ? '123456' : deviceId,
        'registration_type': 'M',
        'social_login_details[display_name]':
            registrationType == 'M' ? null : socialName,
        'name': registrationType == 'M' ? null : socialName,
        'social_login_details[email]':
            registrationType == 'M' ? null : socialEmail,
        'social_login_details[photoURL]':
            registrationType == 'M' ? null : socialPhotoUrl,
        'social_login_details[uid]': registrationType == 'M' ? null : socialId,
      });
      var response = await dio.post(Config.loginUrl, data: formData);
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        result = Login.fromJson(response.data);
        if (result.status == true) {
          saveUserData(result.data!.userId!);
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: OtpScreen(
                    mobileNumber: mobileController.text,
                  )));
          Fluttertoast.showToast(
            msg: result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else {
          if (result.message != null) {
            Fluttertoast.showToast(
              msg: result.message!,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Constants.bgColor,
              textColor: Colors.white,
              fontSize: 10.0.sp,
            );
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

  Future<SocialLoginCheck> checkLogin(String socialId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    displayProgressDialog(context);
    var result = SocialLoginCheck();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'social_login_id': socialId,
      });
      var response = await dio.post(Config.checkSocialLogin, data: formData);
      if (response.statusCode == 200) {
        result = SocialLoginCheck.fromJson(response.data);

        if (result.data!.userObject == null) {
          closeProgressDialog(context);
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: LoginMobileCheckScreen(
                    socialId: socialId,
                    registrationType: registrationType,
                    socialDisplayName: socialName,
                    socialEmail: socialEmail,
                    socialPhotoUrl: socialPhotoUrl,
                  )));
        } else {
          if (result.data!.userObject!.isNew == "true") {
            saveToken(result.data!.token!);
            role = result.data!.userObject!.role;
            name = result.data!.userObject!.name;
            mobileNumberFromAPi = result.data!.userObject!.mobileNumber;
            email = result.data!.userObject!.email;
            preferences.setString('RegisterAs', role!);

            _signInCC(
                context,
                CubeUser(
                    fullName: result.data!.userObject!.name,
                    login: socialEmail,
                    password: '12345678'),
                result);
          } else if (result.data!.userObject!.isVerified == "P" ||
              result.data!.userObject!.isVerified == "R") {
            closeProgressDialog(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VerificationScreen(
                      verificationStatus: result.data!.userObject!.isVerified,
                    )));
          } else {
            saveToken(result.data!.token!);
            role = result.data!.userObject!.role;
            name = result.data!.userObject!.name;
            mobileNumberFromAPi = result.data!.userObject!.mobileNumber;
            email = result.data!.userObject!.email;
            preferences.setString('RegisterAs', role!);

            preferences.setString("name", result.data!.userObject!.name!);
            preferences.setString(
                "mobileNumber", result.data!.userObject!.mobileNumber!);
            preferences.setString(
                "gender", result.data!.userObject!.gender.toString());
            preferences.setString("email", result.data!.userObject!.email!);

            preferences.setString(
                "imageUrl", result.data!.userObject!.imageUrl!);

            result.data!.userObject!.role == 'E'
                ? preferences.setString("qualification",
                    result.data!.userObject!.educationalDetail!.qualification!)
                : preferences.setString("qualification", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString("schoolName",
                    result.data!.userObject!.educationalDetail!.schoolName!)
                : preferences.setString("schoolName", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString("address1",
                    result.data!.userObject!.location!.addressLine2!)
                : preferences.setString("address1", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString(
                    "address2", result.data!.userObject!.location!.city!)
                : preferences.setString("address2", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString(
                    "facebookUrl", result.data!.userObject!.fbUrl.toString())
                : preferences.setString("facebookUrl", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString(
                    "instaUrl", result.data!.userObject!.instaUrl.toString())
                : preferences.setString("instaUrl", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString(
                    "linkedInUrl", result.data!.userObject!.liUrl.toString())
                : preferences.setString("linkedInUrl", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString(
                    "otherUrl", result.data!.userObject!.otherUrl.toString())
                : preferences.setString("otherUrl", '');
            result.data!.userObject!.role == 'E'
                ? preferences.setString(
                    "isNew", result.data!.userObject!.isNew!)
                : preferences.setString("isNew", '');
            preferences.setBool('isLoggedIn', true);
            preferences.setInt(
                'isSubscribed', result.data!.userObject!.isSubscribed!);

            saveUserData(result.data!.userObject!.userId!);

            signIn(CubeUser(
                    fullName: result.data!.userObject!.name,
                    login: socialEmail,
                    password: '12345678'))
                .then((cubeUser) async {
              closeProgressDialog(context);
              SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
              sharedPrefs.saveNewUser(cubeUser);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                  (Route<dynamic> route) => false);
            }).catchError((error) {});
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
    return result;
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
      result.data.userObject.role == 'L'
          ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => bottomNavBar(0)),
              (Route<dynamic> route) => false)
          : Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EducatorRegistration(
                    name: name,
                    mobileNumber: mobileNumberFromAPi,
                    email: email,
                  )));
    }).catchError((exception) {
      _processLoginError(exception);
    });
  }

  void _processLoginError(exception) {
    log("Login error $exception", TAG);
    setState(() {});
    showDialogError(exception, context);
  }

  Future<void> _handleGoogleSignIn() async {
    _googleSignIn.signOut();

    try {
      gUserData = await _googleSignIn.signIn();

      socialName = gUserData!.displayName;
      socialEmail = gUserData!.email;
      socialPhotoUrl = gUserData!.photoUrl;
      socialId = gUserData!.id;
      setState(() {});
      if (gUserData != null) {
        checkLogin(gUserData!.id);
      }
    } catch (e) {
    }
  }

  Future<void> _handleFacebookSignIn() async {
    FacebookAuth.instance.logOut();
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
      loginBehavior: LoginBehavior.webOnly,
    );

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      fbUserData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200)",
      );

      socialName = fbUserData!['name'];
      socialEmail = fbUserData!['email'];
      socialPhotoUrl = fbUserData!['picture']['data']['url'];
      socialId = fbUserData!['id'].toString();
      setState(() {});

      if (fbUserData != null) {
        checkLogin(fbUserData!['id'].toString());
      }
    } else {}
  }

  Future<void> _handleAppleSignIn() async {
    try {
      if (!await TheAppleSignIn.isAvailable()) {
        return null;
      }

      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (result.status == AuthorizationStatus.authorized) {
        socialName = result.credential!.fullName!.givenName;
        socialEmail = result.credential!.email;
        socialPhotoUrl = '';
        socialId = result.credential!.user;
        setState(() {});

        if (result.credential != null) {
          checkLogin(result.credential!.user.toString());
        }
      }
    } catch (e) {}
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
