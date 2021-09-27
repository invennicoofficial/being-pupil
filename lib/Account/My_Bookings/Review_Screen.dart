import 'package:being_pupil/Account/My_Bookings/Review_Done_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';

TextEditingController _headLineController = TextEditingController();
TextEditingController _descriptioController = TextEditingController();

class ReviewScreen extends StatefulWidget {
  ReviewScreen({Key key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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
                    initialRating: 2,
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
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 3.0.h),
                  child: Container(
                    height: 7.0.h,
                    //width: 90.0.w,
                    child: TextFormField(
                      controller: _headLineController,
                      decoration: InputDecoration(
                        labelText: "Add a headline",
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Constants.bpSkipStyle),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Constants.formBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: Constants.formBorder,
                            //width: 2.0,
                          ),
                        ),
                      ),
                      //keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                          fontFamily: "Montserrat", fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.0.h),
                child: Divider(
                  height: 1.0.h,
                  thickness: 1.0,
                  color: Constants.formBorder,
                ),
              ),
              //other description
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 3.0.h),
                  child: Container(
                    height: 13.0.h,
                    width: 90.0.w,
                    child: TextFormField(
                      controller: _descriptioController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      //maxLength: 100,
                      decoration: InputDecoration(
                          //labelText: "Please mention your achivements...",
                          //counterText: '',
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Constants.formBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Constants.formBorder,
                              //width: 2.0,
                            ),
                          ),
                          hintText:
                              "Tell us about your overall experience at the hotel including the amities, services, and all food etc."),
                      //keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                          fontFamily: "Montserrat", fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ),
              //button
              Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: GestureDetector(
                  onTap: () {
                    pushNewScreen(context,
                        screen: ReviewDoneScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
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
                        'Submit',
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
            ],
          ),
        ),
      ),
    );
  }
}
