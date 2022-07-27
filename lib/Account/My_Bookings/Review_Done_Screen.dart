import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';

class ReviewDoneScreen extends StatelessWidget {
  const ReviewDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        child: Padding(
            padding: EdgeInsets.only(bottom: 5.0.h),
            child: ButtonWidget(
                btnName: 'GO TO MY BOOKINGS',
                isActive: true,
                fontWeight: FontWeight.w500)),
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
            SizedBox(
              height: 2.0.h,
            ),
            Container(
              height: 40.0.h,
              child: Center(
                  child: Image.asset(
                'assets/images/reviewDone.png',
                height: 40.0.h,
                width: 50.0.w,
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
