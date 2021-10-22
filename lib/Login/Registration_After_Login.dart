import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SignUpAfterLoginScreen extends StatefulWidget {
 final String mobileNumber;
 SignUpAfterLoginScreen({Key key, this.mobileNumber}) : super(key: key);

  @override
  _SignUpAfterLoginScreen createState() => _SignUpAfterLoginScreen();
}

class _SignUpAfterLoginScreen extends State<SignUpAfterLoginScreen> {
  String registerAs = 'notSelected';
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    // //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    mobileController.text = widget.mobileNumber;
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
                              icon: Icon(Icons.west_outlined, color: Colors.white),
                              iconSize: 30.0,
                              onPressed: (){
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
                            color: Color(0xFFF0F2F4),
                            child: TextFormField(
                              controller: mobileController,
                              readOnly: true,
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
                            onChange: (int value, int index) async {
                              print(value);
                              if (value == 1) {
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
                                  sharedPreferences.getString('RegisterAs'));
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
                            print('Sign Up!!!');
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
                            } else if (mobileController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Mobile Number",
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
                              // signUp(
                              //     nameController.text.trim(),
                              //     mobileController.text.trim(),
                              //     registerAs,
                              //     'A',
                              //     '1234567');
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