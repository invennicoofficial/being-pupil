import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class PaymentFailedScreen extends StatefulWidget {
  PaymentFailedScreen({Key? key}) : super(key: key);

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen> {
 
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
            child: Image.asset('assets/icons/failed.png',
                height: 85, width: 85, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0.h),
            child: Text(
              'Payment Failed',
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
                'Sorry , the operation couldn\'t be completed.',
                style: TextStyle(
                    fontSize: 12.0.sp,
                    color: Constants.bgColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 20.0.h,
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0.h, left: 10.0.w, right: 10.0.w),
            child: Container(
              width: 70.0.w,
              child: Text(
                'For any enquiry reach out to us at beingpupil@gmail.com',
                style: TextStyle(
                    fontSize: 10.0.sp,
                    color: Constants.bgColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
              ),
            ),
          ),
         Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => bottomNavBar(4)),
                        (Route<dynamic> route) => false);
                  },
                  child: ButtonWidget(btnName: 'Retry payment'.toUpperCase(), isActive: true, fontWeight: FontWeight.w600,)
                ),
              ),
        ],
      ),
    );
  }
}
