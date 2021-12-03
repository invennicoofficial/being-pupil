import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/StayAndStudy/Property_Details_Screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

class StayAndStudyScreen extends StatefulWidget {
  StayAndStudyScreen({Key key}) : super(key: key);

  @override
  _StayAndStudyScreenState createState() => _StayAndStudyScreenState();
}

class _StayAndStudyScreenState extends State<StayAndStudyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.bgColor,
        title: Text(
          'Stay & Study',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 1.0.h, left: 4.0.w, right: 4.0.w),
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: 5,
            shrinkWrap: true,
            separatorBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Divider(
                  height: 1.0,
                  color: Constants.formBorder,
                  thickness: 0.8,
                ),
              );
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('Select $index Property!!!');
                  pushNewScreen(context,
                      withNavBar: false,
                      screen: PropertyDetailScreen(),
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                      //Image and Rating
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 20.0.h,
                            width: 100.0.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/house.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 4.0.h,
                              width: 15.0.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/icons/greenStar.png',
                                    height: 2.5.h,
                                    width: 5.0.w,
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Title of property
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.5.h),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consetetur',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Constants.bgColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Location of Property
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ImageIcon(
                              AssetImage('assets/icons/locationPin.png'),
                              color: Constants.bpOnBoardSubtitleStyle,
                              size: 13.0,
                            ),
                            Text(
                              'Location will come here',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 8.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bpOnBoardSubtitleStyle),
                            ),
                          ],
                        ),
                        //Rent of Property
                        Text(
                          '₹5600/mth',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11.0.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF277344)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  //GetAll Property List API
}
