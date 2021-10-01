import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentConfirmScreen extends StatelessWidget {
  const PaymentConfirmScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.bgColor,
        leading: IconButton(
          icon: Icon(
            Icons.west_rounded,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        title: Text(
          'Booking Confirmation',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 4.0.h, left: 4.0.w, right: 4.0.w),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/ok.png',
                    height: 15.0.h,
                    width: 25.0.w,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 3.0.h,
                  ),
                  Text(
                    'Payment Received',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w700,
                        color: Constants.bgColor),
                  ),
                  SizedBox(
                    height: 3.0.h,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Guest Name',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                  Text(
                    'Divyang Dantani',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Mobile Number',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                  Text(
                    '9737887570',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Check In',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                  Text(
                    'Fri, 21 Jan 2021',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Check Out',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                  Text(
                    'Fri, 21 Mar 2021',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Room Type',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                  Text(
                    'Double Sharing',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Meal',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                  Text(
                    'Breakfast, Lunch',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0.h, bottom: 4.0.h),
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
                text: 'yourmail@gmail.com ',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Constants.bgColor),
              ),
                ]
              ), textAlign: TextAlign.center,)
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  height: 7.0.h,
                  width: 90.0.w,
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
      ),
    );
  }
}
