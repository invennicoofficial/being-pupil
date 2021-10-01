import 'package:being_pupil/Account/My_Bookings/Cancelled_List.dart';
import 'package:being_pupil/Account/My_Bookings/Completed_List.dart';
import 'package:being_pupil/Account/My_Bookings/Upcoming_List.dart';
import 'package:flutter/material.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:sizer/sizer.dart';

class MyBookingScreen extends StatefulWidget {
  MyBookingScreen({Key key}) : super(key: key);

  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  bool noBooking = false;

  @override
  Widget build(BuildContext context) {
    return noBooking
        ? Scaffold(
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
            body: Center(
              child: Container(
                height: 50.0.h,
                width: 100.0.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/noBookings.png'),
                        fit: BoxFit.contain)),
              ),
            ),
          )
        : DefaultTabController(
            length: 3,
            child: Scaffold(
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(7.0.h),
                  child: ColoredBox(
                    color: Colors.white,
                    child: TabBar(
                        //indicatorPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
                        //indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        labelColor: Constants.bgColor,
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w500,
                            color: Constants.bgColor),
                        unselectedLabelColor: Constants.bpSkipStyle,
                        unselectedLabelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bpSkipStyle),
                        indicatorColor: Colors.black,
                        indicatorWeight: 2.0,
                        tabs: [
                          Tab(
                            text: 'Upcoming',
                          ),
                          Tab(
                            text: 'Completed',
                          ),
                          Tab(
                            text: 'Cancelled',
                          )
                        ]),
                  ),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  UpComingList(),
                  CompletedList(),
                  CancelledList(),
                ],
              ),
            ),
          );
  }
}
