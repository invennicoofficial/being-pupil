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
                              controller: mobileController,
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
                      Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.0.w, top: 6.0.h),
                        child: GestureDetector(
                          onTap: () {
                            //print('Logged In!!!');
                            bool mobileValid = RegExp(r"^[6-9]\d{9}$").hasMatch(mobileController.text);
                            //print('VALID:::'+mobileValid.toString());
                            if (mobileController.text.isEmpty || (mobileValid == false)) {
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
                            // Navigator.push(
                            //     context,
                            //     PageTransition(
                            //         type: PageTransitionType.fade,
                            //         child: OtpScreen()));
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
                      Platform.isIOS ? Padding(
                        padding: EdgeInsets.only(
                            left: 10.0.w, right: 10.0.w, top: 3.0.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                //print('Apple Login!!!');
                                setState(() {
                                  registrationType = 'A';
                                });
                                try {
                                  if (!await TheAppleSignIn.isAvailable()) {
                                    //print('APPLe not available');
                                    return null; //Break from the program
                                    }
                                  //print('APPLe available');
                                  final AuthService authService = AuthService();
                                  final user = await authService.signInWithApple(
                                      scopes: [Scope.email, Scope.fullName]);
                                  if(user.email != null) {
                                    //print(user);
                                  }
                                } catch (e) {
                                  // TODO: Show alert here
                                  //print(e);
                                }
                                
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child: LoginMobileCheckScreen()));
                              },
                              child: Container(
                                  height: 4.0.h,
                                  width: 8.0.w,
                                  child: SvgPicture.asset('assets/icons/appleSvg.svg')
                                  // Image.asset(
                                  //   'assets/icons/apple.png',
                                  //   fit: BoxFit.contain,
                                  // )
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                //print('Google Login!!!');
                                setState(() {
                                  registrationType = 'G';
                                });
                                _handleGoogleSignIn();
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child: LoginMobileCheckScreen()));
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
                              onTap: () {
                                //print('Facebook Login!!!');
                                setState(() {
                                  registrationType = 'F';
                                });
                                _handleFacebookSignIn();
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child: LoginMobileCheckScreen()));
                              },
                              child: Container(
                                  height: 4.0.h,
                                  width: 8.0.w,
                                  child: SvgPicture.asset('assets/icons/fbSvg.svg')
                                  // Image.asset(
                                  //   'assets/icons/facebook.png',
                                  //   fit: BoxFit.contain,
                                  // )
                                  ),
                            ),
                            // GestureDetector(
                            //   onTap: (){
                            //     //print('LinkedIn Login!!!');
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
                      ) :
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.0.w, right: 10.0.w, top: 3.0.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                //print('Google Login!!!');
                                setState(() {
                                  registrationType = 'G';
                                });
                                _handleGoogleSignIn();
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child: LoginMobileCheckScreen()));
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
                              onTap: () {
                                //print('Facebook Login!!!');
                                setState(() {
                                  registrationType = 'F';
                                });
                                _handleFacebookSignIn();
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child: LoginMobileCheckScreen()));
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
                            //     //print('LinkedIn Login!!!');
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
                              //print('Register!!!');
                            },
                            child: Container(
                              // height: 2.2.h,
                              // width: 15.0.w,
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

//Login API
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
        //print(response.data);
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
        ////print(e.request);
        //print(e.message);
      }
    }
    return result;
  }

//Check Social Login
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
        //print(response.data);

        result = SocialLoginCheck.fromJson(response.data);

        ////print('ID ::: ' + result.data!.userObject!.userId.toString());

        if (result.data!.userObject == null) {
          // Fluttertoast.showToast(
          //   msg: result.message == null ? result.errorMsg! : result.message!,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Constants.bgColor,
          //   textColor: Colors.white,
          //   fontSize: 10.0.sp,
          // );
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
         if(result.data!.userObject!.isNew == "true") {
           //print('API MO::::$mobileNumberFromAPi');
           // saveUserData(result.data.userObject.userId);
           // mobileNumberFromAPi = result.data.userObject.mobileNumber;
           // setState(() {});
           // login(mobileNumberFromAPi);
           //print('ROLE ::' + result.data!.userObject.toString());
           saveToken(result.data!.token!);
           role = result.data!.userObject!.role;
           name = result.data!.userObject!.name;
           mobileNumberFromAPi = result.data!.userObject!.mobileNumber;
           email = result.data!.userObject!.email;
           preferences.setString('RegisterAs', role!);
           

           _signInCC(context, CubeUser(fullName: result.data!.userObject!.name, login: socialEmail, password: '12345678'), result);

          } else if(result.data!.userObject!.isVerified == "P" || result.data!.userObject!.isVerified == "R") {
           closeProgressDialog(context);
           Navigator.of(context).push(MaterialPageRoute(
               builder: (context) => VerificationScreen(verificationStatus: result.data!.userObject!.isVerified,)));
         } else {
           //print('API MO::::$mobileNumberFromAPi');
           // saveUserData(result.data.userObject.userId);
           // mobileNumberFromAPi = result.data.userObject.mobileNumber;
           // setState(() {});
           // login(mobileNumberFromAPi);
           //print('ROLE ::' + result.data!.userObject.toString());
           saveToken(result.data!.token!);
           role = result.data!.userObject!.role;
           name = result.data!.userObject!.name;
           mobileNumberFromAPi = result.data!.userObject!.mobileNumber;
           email = result.data!.userObject!.email;
           preferences.setString('RegisterAs', role!);

           preferences.setString("name", result.data!.userObject!.name!);
              preferences.setString("mobileNumber", result.data!.userObject!.mobileNumber!);
              preferences.setString("gender", result.data!.userObject!.gender.toString());
              preferences.setString("email", result.data!.userObject!.email!);
              //result.data.userObject.role == 'E' ?
              preferences.setString("imageUrl", result.data!.userObject!.imageUrl!);
              // : preferences.setString("imageUrl", '');
              result.data!.userObject!.role == 'E' ? preferences.setString("qualification", result.data!.userObject!.educationalDetail!.qualification!) : preferences.setString("qualification", '');
              result.data!.userObject!.role == 'E' ? preferences.setString("schoolName", result.data!.userObject!.educationalDetail!.schoolName!) : preferences.setString("schoolName",'');
              result.data!.userObject!.role == 'E' ? preferences.setString("address1", result.data!.userObject!.location!.addressLine2!): preferences.setString("address1", '');
              result.data!.userObject!.role == 'E' ? preferences.setString("address2", result.data!.userObject!.location!.city!): preferences.setString("address2", '');
              result.data!.userObject!.role == 'E' ? preferences.setString("facebookUrl", result.data!.userObject!.fbUrl.toString()) : preferences.setString("facebookUrl",'');
              result.data!.userObject!.role == 'E' ? preferences.setString("instaUrl", result.data!.userObject!.instaUrl.toString()) : preferences.setString("instaUrl",'');
              result.data!.userObject!.role == 'E' ? preferences.setString("linkedInUrl", result.data!.userObject!.liUrl.toString()) : preferences.setString("linkedInUrl", '');
              result.data!.userObject!.role == 'E' ? preferences.setString("otherUrl", result.data!.userObject!.otherUrl.toString()) : preferences.setString("otherUrl", '');
              result.data!.userObject!.role == 'E' ? preferences.setString("isNew", result.data!.userObject!.isNew!) : preferences.setString("isNew", '');
              preferences.setBool('isLoggedIn', true);
              preferences.setInt('isSubscribed', result.data!.userObject!.isSubscribed!);

          //print('Gender::: ${result.data!.userObject!.gender}');
          //print('IMAGE:::' + result.data!.userObject!.imageUrl!);
              saveUserData(result.data!.userObject!.userId!);
              //closeProgressDialog(context);
              signIn(CubeUser(fullName: result.data!.userObject!.name, login: socialEmail, password: '12345678'))
                  .then((cubeUser) async {
                closeProgressDialog(context);
                SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
                sharedPrefs.saveNewUser(cubeUser);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                        (Route<dynamic> route) => false);
              })
                  .catchError((error){});
          }

          // Navigator.push(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.fade,
          //         child: OtpScreen(
          //           mobileNumber: mobileController.text,
          //         )));
          // Fluttertoast.showToast(
          //   msg: result.message!,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Constants.bgColor,
          //   textColor: Colors.white,
          //   fontSize: 10.0.sp,
          // );

        }
        //print(result);
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
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
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ////print(e.request);
        //print(e.message);
      }
    }
    return result;
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
    setState(() {

    });
    showDialogError(exception, context);
  }

  Future<void> _handleGoogleSignIn() async {
    _googleSignIn.signOut();

    try {
      gUserData = await _googleSignIn.signIn();
      //print('ID:::' + gUserData!.id);
      //print('USERNAME:::' + gUserData!.displayName!);
      //print('EMAIL:::' + gUserData!.email);
      //print('PHOTO:::' + gUserData!.photoUrl!);
      socialName = gUserData!.displayName;
      socialEmail = gUserData!.email;
      socialPhotoUrl = gUserData!.photoUrl;
      socialId = gUserData!.id;
      setState(() {});
      if (gUserData != null) {
        checkLogin(gUserData!.id);//'khdbcfioducde99he9hhe'
      }
    } catch (e) {
      //print('Google Error:::$e');
    }
  }

  Future<void> _handleFacebookSignIn() async {
    FacebookAuth.instance.logOut();
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
      loginBehavior: LoginBehavior.webOnly,
    );// by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      // get the user data
      fbUserData = await FacebookAuth.i.getUserData(
        fields: "name,email,picture.width(200)",
      );
      //print(fbUserData);
      //print(fbUserData!['email']);
      socialName = fbUserData!['name'];
      socialEmail = fbUserData!['email'];
      socialPhotoUrl = fbUserData!['picture']['data']['url'];
      socialId = fbUserData!['id'].toString();
      setState(() {});
      //print('FACEBOOK::::$socialEmail');
      if (fbUserData != null) {
        checkLogin(fbUserData!['id'].toString());
      }
    } else {
      //print(result.status);
      //print(result.message);
    }
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
