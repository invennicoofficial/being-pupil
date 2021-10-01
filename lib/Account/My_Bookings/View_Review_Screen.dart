import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';

class ViewReviewScreen extends StatelessWidget {
  const ViewReviewScreen({Key key}) : super(key: key);

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
          'Review',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Review your experience',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Constants.bgColor),
                ),
              ),
              //Image
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
              //Rating
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Center(
                  child: Text(
                    'Rate your experience',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Constants.bgColor),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 0.5.h),
                  child: RatingBar(
                    initialRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/icons/greenStar.png'),
                      half: null,
                      empty: Image.asset('assets/icons/star.png'),
                    ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  )),
              Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: Center(
                  child: Text(
                    'Rate on a scale of 1-5 (1 being lowest)',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Divider(
                  height: 1.0.h,
                  thickness: 1.0,
                  color: Constants.formBorder,
                ),
              ),
              //headline
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Center(
                  child: Text(
                    'GOOD EXPERIENCE',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Constants.bgColor),
                  ),
                ),
              ),
              //review discription
              Container(
                width: 100.0.w,
                padding: EdgeInsets.only(top: 0.5.h),
                child: Text(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Constants.bgColor),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
