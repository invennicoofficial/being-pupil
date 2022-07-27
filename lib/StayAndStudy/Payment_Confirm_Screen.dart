import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class PaymentConfirmScreen extends StatefulWidget {
  String? name, mobileNumber, checkIn, checkOut, roomType, meal;
  PaymentConfirmScreen({Key? key, this.name, this.mobileNumber, this.checkIn, this.checkOut, this.roomType, this.meal}) : super(key: key);

  @override
  _PaymentConfirmScreenState createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  String? email;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
      email = preferences.getString('email');
   });
  }


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
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                    (Route<dynamic> route) => false);
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                  (Route<dynamic> route) => false);
          return true;
        },
        child: Padding(
          padding: EdgeInsets.only(top: 4.0.h, left: 4.0.w, right: 4.0.w),
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icons/ok.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    Text(
                      //!'Payment Received',
                      'Booking Confirmed',
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
                      widget.name!,
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
                      widget.mobileNumber!,
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
                      widget.checkIn!,
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
                      widget.checkOut!,
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
                      widget.roomType!,
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
                      widget.meal!.substring(1, widget.meal!.length - 1),
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
              Padding(
                padding: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => bottomNavBar(0)),
                        (Route<dynamic> route) => false);
                  },
                  child: ButtonWidget(btnName: 'BACK TO HOME', isActive: true, fontWeight: FontWeight.w600)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
