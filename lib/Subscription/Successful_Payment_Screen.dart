import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Subscription/Failed_Payment_Screen.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class PaymentSucessScreen extends StatefulWidget {
  PaymentSucessScreen({Key? key}) : super(key: key);

  @override
  State<PaymentSucessScreen> createState() => _PaymentSucessScreenState();
}

class _PaymentSucessScreenState extends State<PaymentSucessScreen> {
   String? email;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async{
    SharedPreferences preff = await SharedPreferences.getInstance();
    setState(() {
      email = preff.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Constants.bgColor));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 15.0.h),
            child: Image.asset('assets/icons/ok.png',
                height: 100, width: 100, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0.h),
            child: Text(
              'Subscription Activated',
              style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Constants.bgColor,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0.h, left: 10.0.w, right: 10.0.w),
            child: Container(
              width: 70.0.h,
              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
              child: Text(
                'Congratulations your One Month subscription @ ₹501 is activated.',
                style: TextStyle(
                    fontSize: 12.0.sp,
                    color: Constants.bgColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center
              ),
            ),
          ),
          SizedBox(
            height: 20.0.h,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0.h, left: 10.0.w, right: 10.0.w),
            child: Container(
              width: 80.0.w,
              child: Text.rich(TextSpan(
                  children: [
                    TextSpan(
                  text: 'Detailed confirmation email has been sent to you at ',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Constants.bgColor),
                ),
                TextSpan(
                  text: email,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Constants.bgColor),
                ),
                  ]
                ), textAlign: TextAlign.center,)
            ),
          ),
         Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => bottomNavBar(0)),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    height: 7.0.h,
                    width: 85.0.w,
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                      color: Constants.bpOnBoardTitleStyle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        color: Constants.bgColor,
                        width: 0.15,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'BACK TO HOME',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 11.0.sp),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
