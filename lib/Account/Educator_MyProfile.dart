import 'package:being_pupil/Account/Edit_Profile_Educator.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Edit_Profile_Learner.dart';

class EducatorMyProfileScreen extends StatefulWidget {
  EducatorMyProfileScreen({Key key}) : super(key: key);

  @override
  _EducatorMyProfileScreenState createState() =>
      _EducatorMyProfileScreenState();
}

class _EducatorMyProfileScreenState extends State<EducatorMyProfileScreen> {
  bool isLiked = false;
  bool isSaved = true;
  String registerAs;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    print(registerAs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Constants.bgColor,
        leading: IconButton(
          icon: Icon(
            Icons.west_rounded,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: //null,
              () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              registerAs == 'E'
                  ? pushNewScreen(context,
                      screen: EditEducatorProfile(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino)
                  : pushNewScreen(context,
                      screen: EditLearnerProfile(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
            },
            child: Container(
              //color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
              child: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'Study Buddy',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Column(
        //shrinkWrap: true,
        //physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height: 41.0.h,
            width: 100.0.w,
            //color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
              child: Column(
                children: <Widget>[
                  //Profile DP
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/profileImage.png',
                      width: 20.5.w,
                      height: 12.0.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  //Name of Educator
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Text(
                      'Praveen Kumar',
                      style: TextStyle(
                          fontSize: 10.0.sp,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Constants.bgColor),
                    ),
                  ),
                  //Degree
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Text(
                      'B.tech | M.S University',
                      style: TextStyle(
                          fontSize: 8.0.sp,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                          color: Constants.bgColor),
                    ),
                  ),
                  //Location
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/locationPin.png'),
                          color: Constants.bgColor,
                          size: 15.0,
                        ),
                        SizedBox(
                          width: 0.5.w,
                        ),
                        Text(
                          'Talwandi, Kota',
                          style: TextStyle(
                              fontSize: 8.0.sp,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              color: Constants.bgColor),
                        ),
                      ],
                    ),
                  ),
                  //Social Handle
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            print('Apple!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/apple.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Google!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/google.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Facebook!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/facebook.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('LinkedIn!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/linkedin.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                      ],
                    ),
                  ),
                  //Other Details
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Column>[
                        Column(
                          children: <Widget>[
                            Text(
                              '10 Yrs',
                              style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Constants.bgColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Text(
                              'Experience',
                              style: TextStyle(
                                  fontSize: 8.0.sp,
                                  color: Constants.bgColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat'),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '50',
                              style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Constants.bgColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  fontSize: 8.0.sp,
                                  color: Constants.bgColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat'),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '200',
                              style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Constants.bgColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                            ),
                            SizedBox(
                              height: 1.0.h,
                            ),
                            Text(
                              'Connections',
                              style: TextStyle(
                                  fontSize: 8.0.sp,
                                  color: Constants.bgColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Profile Divider
          Divider(
            height: 1.0.h,
            color: Constants.bgColor.withOpacity(0.5),
          ),
          //Educator Post
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      //main horizontal padding
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        //Container for one post
                        child: Container(
                          height: 57.5.h,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                //   trailing: GestureDetector(
                                //     onTap: () {
                                //       pushNewScreen(context,
                                //           withNavBar: false,
                                //           screen: ReportFeed(),
                                //           pageTransitionAnimation:
                                //               PageTransitionAnimation.cupertino);
                                //     },
                                //     child: Container(
                                //   height: 2.5.h,
                                //   width: 4.0.w,
                                //   child: ImageIcon(
                                //     AssetImage('assets/icons/menu.png'),
                                //     size: 15,
                                //   ),
                                // ),
                                //   ),
                                trailing: PopupMenuButton(
                                  color: Color(0xFFF0F2F4),
                                  elevation: 2.0,
                                  padding: EdgeInsets.only(left: 8.0.w),
                                  onSelected: (value){
                                   Fluttertoast.showToast(
                                     msg: value == 1
                                     ? 'Edit Post'
                                     : 'Delete Post',
                                     backgroundColor: Constants.bgColor,
                                     gravity: ToastGravity.BOTTOM,
                                     fontSize: 10.0.sp,
                                     toastLength: Toast.LENGTH_SHORT,
                                     textColor: Colors.white
                                   );
                                  },
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: Text("Edit",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bgColor
                                            ),),
                                            value: 1,
                                          ),
                                          PopupMenuItem(
                                            child: Text("Delete",
                                             style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.formBorder
                                            ),),
                                            value: 2,
                                          )
                                        ]),
                              ),
                              //Post descriptionText
                              Container(
                                width: 88.0.w,
                                child: Text(
                                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam...',
                                    style: TextStyle(
                                        fontSize: 9.0.sp,
                                        color: Constants.bpOnBoardSubtitleStyle,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.justify),
                              ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                color: Constants
                                                    .bpOnBoardSubtitleStyle,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 1.0.h),
                                      child: Text(
                                        "9 Comments",
                                        style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Constants
                                                .bpOnBoardSubtitleStyle,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //divider
                              Divider(
                                height: 1.0.h,
                                color: Constants.bpOnBoardSubtitleStyle
                                    .withOpacity(0.5),
                                thickness: 1.0,
                              ),
                              //Row for Like comment and Share
                              Padding(
                                padding: EdgeInsets.only(top: 1.0.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLiked = !isLiked;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            isLiked
                                                ? Icons.thumb_up_sharp
                                                : Icons.thumb_up_outlined,
                                            color: isLiked
                                                ? Constants.selectedIcon
                                                : Constants
                                                    .bpOnBoardSubtitleStyle,
                                            size: 30.0,
                                          ),
                                          SizedBox(
                                            width: 1.0.w,
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(top: 1.0.h),
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
                                    GestureDetector(
                                      onTap: () {
                                        pushNewScreen(context,
                                            withNavBar: false,
                                            screen: CommentScreen(),
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.comment_outlined,
                                            color: Constants
                                                .bpOnBoardSubtitleStyle,
                                            size: 30.0,
                                          ),
                                          SizedBox(
                                            width: 1.0.w,
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(top: 1.0.h),
                                            child: Text(
                                              "Comment",
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
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isSaved = !isSaved;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            isSaved
                                                ? Icons.bookmark_sharp
                                                : Icons
                                                    .bookmark_outline_outlined,
                                            color: isSaved
                                                ? Constants.selectedIcon
                                                : Constants
                                                    .bpOnBoardSubtitleStyle,
                                            size: 30.0,
                                          ),
                                          SizedBox(
                                            width: 1.0.w,
                                          ),
                                          Container(
                                            padding:
                                                EdgeInsets.only(top: 1.0.h),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
