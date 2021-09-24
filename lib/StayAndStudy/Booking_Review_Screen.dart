import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BookingReviewScreen extends StatelessWidget {
  final String name, mobileNumber, checkIn, checkOut, roomType, meal;
  final int roomCharge, mealCharge, taxCharge, total;
  BookingReviewScreen(
      {Key key,
      this.name,
      this.mobileNumber,
      this.checkIn,
      this.checkOut,
      this.roomType,
      this.meal,
      this.roomCharge,
      this.mealCharge,
      this.taxCharge,
      this.total})
      : super(key: key);

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
          'Booking Review',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 2.0.h, left: 4.0.w, right: 4.0.w),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Container(
                  height: 25.0.h,
                  width: 100.0.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/house.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Text(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Constants.bgColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0.h),
                child: Row(
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Constants.bgColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
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
                            name,
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
                      padding: EdgeInsets.only(top: 1.0.h),
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
                            mobileNumber,
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
                      padding: EdgeInsets.only(top: 1.0.h),
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
                            checkIn,
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
                      padding: EdgeInsets.only(top: 1.0.h),
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
                            checkOut,
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
                      padding: EdgeInsets.only(top: 1.0.h),
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
                            roomType,
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
                      padding: EdgeInsets.only(top: 1.0.h),
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
                            meal.substring(1, meal.length - 1),
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
                      padding: EdgeInsets.only(top: 3.0.h),
                      child: Divider(
                        color: Constants.formBorder,
                        height: 2.0.h,
                        thickness: 1.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.0.h),
                      child: Row(
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Constants.bgColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Room Charges',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor)),
                            TextSpan(
                                text: '($roomType)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text('₹$roomCharge',
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
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'Meal Charges',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor)),
                            TextSpan(
                                text: '(${meal.substring(1, meal.length - 1)})',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text('₹$mealCharge',
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
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Taxes & Fees',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Constants.bgColor),
                          ),
                          Text('₹$taxCharge',
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
                      padding: EdgeInsets.only(top: 3.0.h),
                      child: Divider(
                        color: Constants.formBorder,
                        height: 2.0.h,
                        thickness: 1.0,
                      ),
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
                      'Total',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w700,
                          color: Constants.bgColor),
                    ),
                    Text('₹$total',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w700,
                          color: Constants.bgColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0.h),
                child: GestureDetector(
                  onTap: () {},
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
                        'Pay now'.toUpperCase(),
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
