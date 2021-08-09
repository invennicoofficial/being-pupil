import 'package:being_pupil/Account/About_Us_Screen.dart';
import 'package:being_pupil/Account/FAQ_Screen.dart';
import 'package:being_pupil/Account/My_Profile_Educator.dart';
import 'package:being_pupil/Account/Saved_Post.dart';
import 'package:being_pupil/Account/Terms_And_Policy_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Educator_Home_Screen.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.bgColor,
          title: Text(
            'My Account',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          leading: IconButton(
          icon: Icon(
            Icons.west_rounded,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: (){
            // Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 3.0.h, left: 5.0.w, right: 5.0.w),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              //height: 90.0.h,
              width: 100.0.w,
              //color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Column(
                  children: <Widget>[
                    //Column for User Info
                    Center(
                      child: Column(
                        children: <Widget>[
                          // Padding(padding: EdgeInsets.only(top: 2.0.h, left: 2.0.w, right: 2.0.w),
                          // child: ,)
                          Container(
                            height: 16.5.h,
                            width: 29.5.w,
                            //color: Colors.grey,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/profileImage.png'),
                              //backgroundColor: Colors.grey,
                              radius: 100.0,
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            'Praveen Kumar',
                            style: TextStyle(
                                color: Constants.profileTitle,
                                fontFamily: 'Montserrat',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            '9865743210',
                            style: TextStyle(
                                color: Constants.bgColor,
                                fontFamily: 'Montserrat',
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            'B.tech I M.S University',
                            style: TextStyle(
                                color: Constants.bgColor,
                                fontFamily: 'Montserrat',
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),

                    //Profile list
                    Padding(
                      padding: EdgeInsets.only(top: 5.0.h),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) =>
                                      EducatorProfile()));
                            },
                            child: ProfileList(
                              txt: "My Profile",
                              image: "assets/icons/myProfile.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) =>
                                      EducatorHomeScreen()));
                              // pushNewScreen(context, screen: EducatorHomeScreen(),
                              // pageTransitionAnimation: PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "My Courses",
                              image: "assets/icons/myCourse.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) =>
                                      EducatorHomeScreen()));
                            },
                            child: ProfileList(
                              txt: "My Bookings",
                              image: "assets/icons/myBooking.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.of(context).push(PageRouteBuilder(
                              //     pageBuilder: (_, __, ____) => EducatorHomeScreen()));
                              pushNewScreen(context,
                              withNavBar: false,
                                  screen: SavedPostScreen(),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "Saved Posts",
                              image: "assets/icons/savedPost.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 6.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) =>
                                      AboutUsScreen()));
                            },
                            child: ProfileList(
                              txt: "About",
                              image: "assets/icons/about.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) => FAQScreen()));
                            },
                            child: ProfileList(
                              txt: "FAQs",
                              image: "assets/icons/faqs.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) =>
                                      TermsAndPolicyScreen()));
                            },
                            child: ProfileList(
                              txt: "Terms & Policy",
                              image: "assets/icons/termPolicy.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Share.share(
                                  'check out Being Pupil App! https://google.com',
                                  subject: 'Download Being Pupil App!');
                            },
                            child: ProfileList(
                              txt: "Share",
                              image: "assets/icons/share.png",
                              sizeImage: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 6.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ____) =>
                                      EducatorHomeScreen()));
                            },
                            child: ProfileList(
                              txt: "Logout",
                              image: "assets/icons/logout.png",
                              sizeImage: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

//Profile Component
class ProfileList extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding, sizeImage;

  ProfileList({this.txt, this.image, this.tap, this.padding, this.sizeImage});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 4.0.w),
                      child: Image.asset(
                        image,
                        height: sizeImage,
                        color: Constants.bgColor,
                      ),
                    ),
                    Text(
                      txt,
                      style: TextStyle(
                          color: Constants.bgColor,
                          fontFamily: 'Montserrat',
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Constants.bgColor,
                    size: 15.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(PageRouteBuilder(
//                             pageBuilder: (_, __, ____) =>
//                                 PrivacyPolicyScreen()));
//                       },
//                       child: category(
//                         txt: "Privacy Policy",
//                         image: "assets/icon/privacyPolicy.png",
//                         padding: 20.0,
//                         sizeImage: 23.0,
//                       ),
//                     ),
