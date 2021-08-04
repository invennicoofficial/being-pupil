import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Create_Post_Screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';

import 'Report_Feed.dart';

class EducatorHomeScreen extends StatefulWidget {
  EducatorHomeScreen({Key key}) : super(key: key);

  @override
  _EducatorHomeScreenState createState() => _EducatorHomeScreenState();
}

class _EducatorHomeScreenState extends State<EducatorHomeScreen> {
  bool isLiked = false;
  bool isSaved = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Constants.bgColor,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  pushNewScreen(context,
                      screen: CreatePostScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                })
          ],
          title: Container(
              height: 8.0.h,
              width: 30.0.w,
              child: Image.asset('assets/images/beingPupil.png',
                  fit: BoxFit.contain)),
        ),
        body: ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                //main horizontal padding
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  //Container for one post
                  child: Container(
                    height: 58.0.h,
                    width: 100.0.w,
                    //color: Colors.grey[300],
                    //column for post content
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 1.0.h,
                        ),
                        //ListTile for educator details
                        ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          //leading:
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/images/educatorDP.png',
                                  width: 8.5.w,
                                  height: 5.0.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 2.0.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1.0.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Marilyn Brewer",
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "B.tech I M.S University",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "28 Jun 2021",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.report_gmailerrorred_outlined),
                              onPressed: () {
                                pushNewScreen(context,
                                    withNavBar: false,
                                    screen: ReportFeed(),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino);
                              }),
                          //ImageIcon(AssetImage('assets/icons/report.png'),)
                        ),
                        //Post descriptionText
                        Text(
                            'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam...',
                            style: TextStyle(
                                fontSize: 9.0.sp,
                                color: Constants.bpOnBoardSubtitleStyle,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.justify),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        // Container for image or video
                        Container(
                          height: 30.0.h,
                          width: 100.0.w,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/postImage.jpg',
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                        //Row for Liked, commented, shared
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_alt_rounded,
                                    color: Constants.bgColor,
                                  ),
                                  SizedBox(
                                    width: 1.0.w,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 1.0.h),
                                    child: Text(
                                      "20 Likes",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 1.0.h),
                                    child: Text(
                                      "9 Comments  . ",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 1.0.h),
                                    child: Text(
                                      "1 Share",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        //divider
                        Divider(
                          height: 1.0.h,
                          color: Color(0xFF7F7F7F).withOpacity(0.6),
                          thickness: 2.0,
                        ),
                        //Row for Like comment and Share
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      isLiked
                                          ? Icons.thumb_up_sharp
                                          : Icons.thumb_up_outlined,
                                      color: isLiked
                                          ? Constants.selectedIcon
                                          : Constants.bpOnBoardSubtitleStyle,
                                      size: 30.0,
                                    ),
                                    SizedBox(
                                      width: 1.0.w,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 1.0.h),
                                      child: Text(
                                        "Like",
                                        style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Constants
                                                .bpOnBoardSubtitleStyle,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.comment_outlined,
                                    color: Constants.bpOnBoardSubtitleStyle,
                                    size: 30.0,
                                  ),
                                  SizedBox(
                                    width: 1.0.w,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 1.0.h),
                                    child: Text(
                                      "Comment",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSaved = !isSaved;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      isSaved
                                          ? Icons.bookmark_sharp
                                          : Icons.bookmark_outline_outlined,
                                      color: isSaved
                                          ? Constants.selectedIcon
                                          : Constants.bpOnBoardSubtitleStyle,
                                      size: 30.0,
                                    ),
                                    SizedBox(
                                      width: 1.0.w,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 1.0.h),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Constants
                                                .bpOnBoardSubtitleStyle,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              //height: 2.0.h,
              thickness: 5.0,
              color: Color(0xFFD3D9E0),
            );
          },
        ));
  }
}
