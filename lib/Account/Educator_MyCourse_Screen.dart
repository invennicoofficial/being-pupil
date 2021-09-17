import 'package:being_pupil/Account/Course_Details.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

import 'Create_Course_Screen.dart';

class EducatorMyCourseScreen extends StatefulWidget {
  EducatorMyCourseScreen({Key key}) : super(key: key);

  @override
  _EducatorMyCourseScreenState createState() => _EducatorMyCourseScreenState();
}

class _EducatorMyCourseScreenState extends State<EducatorMyCourseScreen> {
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
        title: Text('My Course',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 2.0.w),
              child: IconButton(
                  icon: Icon(Icons.add_box_outlined, color: Colors.white),
                  onPressed: () {
                    print('ADD!!!');
                    pushNewScreen(context,
                        screen: CreateCourseScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  })),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.0.w),
                child: ListTile(
                  onTap: () {
                    pushNewScreen(context,
                        screen: CourseDetailScrenn(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
                  title: Row(
                    children: <Widget>[
                      Container(
                        height: 10.0.h,
                        width: 18.0.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/postImage.png'),
                                fit: BoxFit.cover)),
                      ),
                      SizedBox(
                        width: 5.0.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 65.0.w,
                            child: Text(
                              'Lorem ipsum dolor sit amet, consetetur',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.bgColor),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text('21 Jan 2021 to 21 Mar 2021',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 8.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
