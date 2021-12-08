import 'package:being_pupil/Account/My_Bookings/Cancel_Reason_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Booking_Model/UpComing_Booking_Model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class ViewBookingScreen extends StatefulWidget {
  UpComingBooking bookingDetails;
  int index;
  String meal;
  ViewBookingScreen(
      {Key key, this.bookingDetails, this.index, this.meal})
      : super(key: key);

  @override
  _ViewBookingScreenState createState() => _ViewBookingScreenState();
}

class _ViewBookingScreenState extends State<ViewBookingScreen> {
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
          'My Booking',
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
                      image: NetworkImage(widget.bookingDetails.data[widget.index].propertyImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Text(
                  widget.bookingDetails.data[widget.index].name,
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
                          Text(widget.bookingDetails.data[widget.index].guestName,//name,
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
                          Text(widget.bookingDetails.data[widget.index].mobileNumber,//mobileNumber,
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
                          Text(widget.bookingDetails.data[widget.index].checkInDate,//checkIn,
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
                          Text(widget.bookingDetails.data[widget.index].checkOutDate,//checkOut,
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
                          Text(widget.bookingDetails.data[widget.index].roomType,//roomType,
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
                          Text(widget.meal.substring(1, widget.meal.length - 1),
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
                                text: '(${widget.bookingDetails.data[widget.index].roomType})',//'($roomType)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text('₹${widget.bookingDetails.data[widget.index].roomAmount}',//'₹$roomCharge',
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
                                text: '(${widget.meal.substring(1, widget.meal.length - 1)})',//'(${meal.substring(1, meal.length - 1)})',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text('₹${widget.bookingDetails.data[widget.index].mealAmount}',//'₹$mealCharge',
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
                          Text('₹${widget.bookingDetails.data[widget.index].taxAmount}',//'₹$taxCharge',
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
                    Text('₹${widget.bookingDetails.data[widget.index].totalAmount}',//'₹$total',
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
                      padding: EdgeInsets.only(top: 2.0.h),
                      child: Divider(
                        color: Constants.formBorder,
                        height: 2.0.h,
                        thickness: 1.0,
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0.h),
                child: Column(
                  children: [
                   Text('Something not right?',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 8.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Constants.bpSkipStyle),
                    ),
                    SizedBox(height: 0.5.h,),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Contact Us ',
                       style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 9.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Constants.bgColor),
                      ),
                      TextSpan(text: 'for help',
                       style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 8.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Constants.bpSkipStyle),
                      )
                    ]))
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
