import 'package:being_pupil/Account/My_Bookings/Cancel_Reason_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Booking_Model/Get_Booking_Data_Model.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class CancelBookingScreen extends StatefulWidget {
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
  // final String name, mobileNumber, checkIn, checkOut, roomType, meal;
  // final int roomCharge, mealCharge, taxCharge, total;
  CancelBookingScreen(
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
      this.totalAmount
      // this.name,
      // this.mobileNumber,
      // this.checkIn,
      // this.checkOut,
      // this.roomType,
      // this.meal,
      // this.roomCharge,
      // this.mealCharge,
      // this.taxCharge,
      // this.total
      })
      : super(key: key);

  @override
  _CancelBookingScreenState createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
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
                      image: NetworkImage(widget.image!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Row(
                  children: [
                    Text(
                      widget.name!,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Constants.bgColor),
                    ),
                  ],
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
                          Text(
                            widget.guestName!, //name,
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
                            widget.mobileNumber!, //mobileNumber,
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
                            widget.checkIn!, //checkIn,
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
                            widget.checkOut!, //checkOut,
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
                            widget.roomType!, //roomType,
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
                            widget.meal!.substring(
                                1,
                                widget.meal!.length -
                                    1), //meal.substring(1, meal.length - 1),
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
                                text: '(${widget.roomType})', //'($roomType)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text(
                            '₹${widget.roomAmount}', //'₹$roomCharge',
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
                                text: '(${widget.meal!.substring(1, widget.meal!.length -1)})', //'(${meal.substring(1, meal.length - 1)})',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text(
                            '₹${widget.mealAmount.toStringAsFixed(2)}', //'₹$mealCharge',
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
                          Text(
                            '₹${widget.taxAmount}', //'₹$taxCharge',
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
                    Text(
                      '₹${widget.totalAmount}', //'₹$total',
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
                  onTap: () {
                    pushNewScreen(context,
                        screen: ReasonForCancelBooking(
                          image: widget.image,
                          name: widget.name,
                          index: widget.index,
                          guestName: widget.guestName,
                          mobileNumber: widget.mobileNumber,
                          checkIn: widget.checkIn,
                          checkOut: widget.checkOut,
                          roomType: widget.roomType,
                          meal: widget.meal,
                          roomAmount: widget.roomType,
                          mealAmount: widget.mealAmount,
                          taxAmount: widget.taxAmount,
                          totalAmount: widget.totalAmount,
                          propertyId: widget.propertyId,
                          bookingId: widget.bookingId,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
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
                        'CANCEL BOOKING',
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
