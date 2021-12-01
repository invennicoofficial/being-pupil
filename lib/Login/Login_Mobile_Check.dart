import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Registration/Educator_Registration.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
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
  String socialId, registrationType, socialDisplayName, socialEmail, socialPhotoUrl;
  LoginMobileCheckScreen({Key key, @required this.socialId, @required this.registrationType, @required this.socialDisplayName, @required this.socialEmail, @required this.socialPhotoUrl }) : super(key: key);

  @override
  _LoginMobileCheckScreenState createState() => _LoginMobileCheckScreenState();
}

class _LoginMobileCheckScreenState extends State<LoginMobileCheckScreen> {
  final TextEditingController mobileController = TextEditingController();

  final storage = new FlutterSecureStorage();
  String role;
  Map<String, dynamic> map;
  List<dynamic> mapData;

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
                      'Please provide your number to proceed further.',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            if (mobileController.text.isEmpty || mobileController.text.length < 10){
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
                              // Navigator.push(
                              //     context,
                              //     PageTransition(
                              //         type: PageTransitionType.fade,
                              //         child: SignUpAfterLoginScreen(
                              //           mobileNumber: mobileController.text,
                              //         )));
                            }
                            // Navigator.push(
                            //     context,
                            //     PageTransition(
                            //         type: PageTransitionType.fade,
                            //         child: OtpScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 4.0.h),
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

  Future<void> mobileCheckApi(String mobileNumber) async {
    displayProgressDialog(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //var result = MobileCheck();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'mobile_number': mobileNumber,
        //'country_code': '+91',
        'deviceType': 'A',
        'deviceId': '1234567',
        'registration_type': widget.registrationType,
        'social_login_details[display_name]': widget.socialDisplayName,
        'social_login_details[email]': widget.socialEmail,
        'social_login_details[photoURL]': widget.socialPhotoUrl,
        //'social_login_details[phoneNumber]': '',
        'social_login_details[uid]': widget.socialId
      });
      var response = await dio.post(Config.mobileCheckUrl, data: formData);
      if (response.statusCode == 200) {
        map = response.data;
        //mapData = map['data'];
        print(mapData);
        closeProgressDialog(context);
        //result = MobileCheck.fromJson(response.data);
  
        //if (result.status == true)
         if (map['status'] == true){
          
     
          //if(result.data.userObject == null)
          if(map['data']['userObj'] == null){
           Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: SignUpAfterLoginScreen(
                    mobileNumber: mobileController.text,
                    name: widget.socialDisplayName,
                    registrationType: widget.registrationType,
                    socialDisplayName: widget.socialDisplayName,
                    socialEmail: widget.socialEmail,
                    socialPhotoUrl: widget.socialPhotoUrl,
                    socialId: widget.socialId,
                  )));          
          }else{
            Fluttertoast.showToast(
            msg: map['message'],//result.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          role = map['data']['userObj']['register_as']; //result.data.userObject.role;
          saveUserData(map['data']['userObj']['user_id']);//saveUserData(result.data.userObject.userId);
          saveToken(map['data']['access_token']); //saveToken(result.data.token);
          
              preferences.setInt('userId', map['data']['userObj']['user_id']);
              preferences.setString('RegisterAs', role);
              preferences.setString("name", map['data']['userObj']['name']);
              preferences.setString("mobileNumber", map['data']['userObj']['mobile_number']);
              preferences.setString("gender", map['data']['userObj']['gender']);
             
              preferences.setString("imageUrl", map['data']['userObj']['image_url']);

              if(map['data']['userObj']['isNew'] == 'false'){
        
              role == 'E' ? preferences.setString("qualification", map['data']['userObj']['educational_details'].last['qualification']) : preferences.setString("qualification", '');
              role == 'E' ? preferences.setString("schoolName", map['data']['userObj']['educational_details'].last['school_name']) : preferences.setString("schoolName",'');
              role == 'E' ? preferences.setString("address1", map['data']['userObj']['location'][0]['address_line1']): preferences.setString("address1", '');
              role == 'E' ? preferences.setString("address2", map['data']['userObj']['location'][0]['city']): preferences.setString("address2", '');
              role == 'E' ? preferences.setString("facebookUrl", map['data']['userObj']['facebook_url']) : preferences.setString("facebookUrl",'');
              role == 'E' ? preferences.setString("instaUrl", map['data']['userObj']['insta_url']) : preferences.setString("instaUrl",'');
              role == 'E' ? preferences.setString("linkedInUrl", map['data']['userObj']['linkedin_url']) : preferences.setString("linkedInUrl", '');
              role == 'E' ? preferences.setString("otherUrl", map['data']['userObj']['other_url']) : preferences.setString("otherUrl", '');
              role == 'E' ? preferences.setString("isNew", map['data']['userObj']['isNew']) : preferences.setString("isNew", '');
              preferences.setBool('isLoggedIn', true);
              }
              print('ROLE:::' + preferences.getString('RegisterAs'));
              print('ISNEW:::' + map['data']['userObj']['isNew']);

            if(role == 'E' && map['data']['userObj']['isNew'] == 'true'){
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EducatorRegistration(
                  name: map['data']['userObj']['name'].toString(),
                  mobileNumber: mobileNumber,
                )));
              }
            else{ Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                    (Route<dynamic> route) => false);
            }
            
          }
        } else {
          if(map['message'] == null){
          Fluttertoast.showToast(
            msg: map['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          } else {
            Fluttertoast.showToast(
            msg:map['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          }
        }
        print(map);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::" +
            e.response.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    //return result;
  }

  void saveToken(String token) async {
    // Write value
    await storage.write(key: 'access_token', value: token);
    print('TOKEN ::: ' + token);
    //closeProgressDialog(context);
  }

  void saveUserData(int userId) async {
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
