import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Booking_Model/Get_Booking_Data_Model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewBookingScreen extends StatefulWidget {
  // BookingDetails bookingDetails;
  // //CancelledBooking cancelBookingDetails;
   int? index;
  String? meal, image, guestName, mobileNumber, checkIn, checkOut, roomType, name, propertyId, bookingId;
  dynamic roomAmount, mealAmount, taxAmount, totalAmount;
  ViewBookingScreen(
      {Key? key,this.meal, this.image, this.index, this.guestName, this.mobileNumber,
      this.checkOut, this.checkIn, this.roomType, this.name, this.roomAmount, this.mealAmount, this.taxAmount, this.totalAmount,
      this.propertyId, this.bookingId})
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
                          Text(widget.guestName!,//name,
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
                          Text(widget.mobileNumber!,//mobileNumber,
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
                          Text(widget.checkIn!,//checkIn,
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
                          Text(widget.checkOut!,//checkOut,
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
                          Text(widget.roomType!,//roomType,
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
                          Text(widget.meal!.substring(1, widget.meal!.length - 1),
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
                                text: '(${widget.roomType})',//'($roomType)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text('₹${widget.roomAmount}',//'₹$roomCharge',
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
                                text: '(${widget.meal!.substring(1, widget.meal!.length - 1)})',//'(${meal.substring(1, meal.length - 1)})',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.blueTitle)),
                          ])),
                          Text('₹${widget.mealAmount.toStringAsFixed(2)}',//'₹$mealCharge',
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
                          Text('₹${widget.taxAmount}',//'₹$taxCharge',
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
                    Text('₹${widget.totalAmount}',//'₹$total',
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
              Center(
                child: Padding(
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
                      GestureDetector(
                        onTap: (){
                          _showContactUsDialog(context);
                        },
                        child: Text.rich(TextSpan(children: [
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
                        ])),
                      )
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Contact US Dialog
  _showContactUsDialog(context){
    showDialog(context: context, builder: (context){
      return Dialog(
        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
        //insetPadding: EdgeInsets.only(top: 10.0),
        elevation: 15.0,
  child: Container(
    height: 250.0,
    width: 350.0,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text('Contact Us On',
           style: TextStyle(
               fontFamily: 'Montserrat',
               fontSize: 18.0.sp,
               fontWeight: FontWeight.w600,
               color: Constants.bgColor),
          ),
        ),
        Padding(padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
         Text('+918091715227',
            style: TextStyle(
               fontFamily: 'Montserrat',
               fontSize: 16.0.sp,
               fontWeight: FontWeight.w400,
               color: Constants.bgColor),
          ),
          IconButton(onPressed: (){
            launch("tel://+918091715227");
          }, icon: Icon(Icons.call)),
        ],),),
        Padding(padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
         Container(
           //color: Colors.grey,
           width: 200,
           child: Text('admin@beingpupil.com',
              style: TextStyle(
               fontFamily: 'Montserrat',
               fontSize: 16.0.sp,
               fontWeight: FontWeight.w400,
               color: Constants.bgColor),
              overflow: TextOverflow.ellipsis,
            ),
         ),
          IconButton(onPressed: (){
            launch('mailto:admin@beingpupil.com?subject=Help me on ${widget.name} property&body=Hello Team,\n');
          }, icon: Icon(Icons.mail)),
        ],),)
      ],
    ),
  ),
);
  });
  }
}
