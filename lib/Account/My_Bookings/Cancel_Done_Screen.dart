import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Booking_Model/Get_Booking_Data_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CancelDoneScreen extends StatefulWidget {
  final int propertyId;
  final String? bookingId;
  BookingDetails? propertyDetails;
  int? index;
  String? meal,
      image,
      guestName,
      mobileNumber,
      checkIn,
      checkOut,
      roomType,
      name;
  dynamic roomAmount, mealAmount, taxAmount, totalAmount;
  CancelDoneScreen(
      {Key? key,
      required this.propertyId,
      required this.bookingId,
      this.meal,
      this.image,
      this.index,
      this.guestName,
      this.mobileNumber,
      this.checkOut,
      this.checkIn,
      this.roomType,
      this.name,
      this.roomAmount,
      this.mealAmount,
      this.taxAmount,
      this.totalAmount})
      : super(key: key);
  @override
  _CancelDoneScreenState createState() => _CancelDoneScreenState();
}

class _CancelDoneScreenState extends State<CancelDoneScreen> {
  String? email;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{
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
          'Booking Cancelled',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Future<bool> booleanVal = true as Future<bool>;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => bottomNavBar(0)),
              (Route<dynamic> route) => false);
          return booleanVal;
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
                      'Booking Cancelled',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w700,
                          color: Constants.bgColor),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Text(
                      'Amount will be refunded in 7-14 working days in ${widget.mobileNumber}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 9.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Constants.bgColor),
                      textAlign: TextAlign.center,
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
                      widget.guestName!,
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
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text:
                            'Detailed confirmation email has been sent to you at ',
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
                    ]),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => bottomNavBar(0)),
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
      ),
    );
  }
}
