import 'package:being_pupil/Account/My_Bookings/Review_Screen.dart';
import 'package:flutter/material.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

import 'View_Booking_Details.dart';

class CompletedList extends StatefulWidget {
  CompletedList({Key key}) : super(key: key);

  @override
  _CompletedListState createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 3,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Divider(
              height: 1.0.h,
              color: Constants.formBorder,
              thickness: 1.0,
            ),
          );
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                top: 2.0.h, bottom: 1.0.h, left: 4.0.w, right: 4.0.w),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    //Image for booking
                    Padding(
                      padding: EdgeInsets.only(right: 4.0.w),
                      child: Container(
                        height: 12.0.h,
                        width: 22.0.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/postImage.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    //Other booking details
                    Container(
                      width: 65.0.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lorem ipsum dolor sit amet, consetetur',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Constants.bgColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Text(
                              'Booking ID : 1234567',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Text(
                              'Double Sharing',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Text(
                              '21 Jan 2021 to 21 Mar 2021',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                //Foe cancel and view details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <TextButton>[
                    TextButton(
                      onPressed: index == 0
                          ? () {
                              pushNewScreen(context,
                                  screen: ReviewScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            }
                          : null,
                      child: Text(
                        index == 0 ? 'Write Review' : 'View Review',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF04964D)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        pushNewScreen(context,
                            screen: ViewBookingScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                      },
                      child: Text(
                        'View Details',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1F7DE9)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
