import 'package:being_pupil/Account/My_Bookings/Cancel_Booking_Screen.dart';
import 'package:being_pupil/Account/My_Bookings/View_Booking_Details.dart';
import 'package:flutter/material.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class UpComingList extends StatefulWidget {
  UpComingList({Key key}) : super(key: key);

  @override
  _UpComingListState createState() => _UpComingListState();
}

class _UpComingListState extends State<UpComingList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 0.0.h),
            child: Divider(
              height: 0.0.h,
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
                  children: [
                    InkWell(
                      onTap: () {
                        pushNewScreen(context,
                            screen: CancelBookingScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFEF1616)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
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
