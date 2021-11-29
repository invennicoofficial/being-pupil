import 'package:being_pupil/Account/My_Bookings/My_Booking_Screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';

class ReviewDoneScreen extends StatelessWidget {
  const ReviewDoneScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
                  onTap: () {
                    print('GO TO!!!');
                //    Navigator.of(context).pushAndRemoveUntil(
                // MaterialPageRoute(builder: (context) => MyBookingScreen()),
                //     (Route<dynamic> route) => false);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5.0.h),
                    child: Container(
                      height: 7.0.h,
                      width: 90.0.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Constants.bgColor,
                          ),
                          color: Constants.bgColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Center(
                        child: Text(
                          'GO TO MY BOOKINGS',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 11.0.sp,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
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
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 40.0.h,
              child: Center(
                  child: Image.asset(
                'assets/icons/reviews.png',
                height: 40.0.h,
                width: 60.0.w,
              )),
            ),
            Text(
              'Thanks for your Review',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Constants.bgColor),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Text(
                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10.0.sp,
                    fontWeight: FontWeight.w400,
                    color: Constants.bgColor),
                    textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
