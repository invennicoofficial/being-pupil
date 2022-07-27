import 'package:being_pupil/Account/About_Us_Screen.dart';
import 'package:being_pupil/Account/My_Bookings/My_Booking_Screen.dart';
import 'package:being_pupil/Account/My_Course/Educator_MyCourse_Screen.dart';
import 'package:being_pupil/Account/My_Profile/Educator_MyProfile.dart';
import 'package:being_pupil/Account/FAQ_Screen.dart';
import 'package:being_pupil/Account/My_Profile/Edit_Profile_Educator.dart';
import 'package:being_pupil/Account/My_Profile/Learner_MyProfile.dart';
import 'package:being_pupil/Account/Saved_Post.dart';
import 'package:being_pupil/Account/Terms_And_Policy_Screen.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Login/Login_Screen.dart';
import 'package:being_pupil/Subscription/Current_Subscription_Screen.dart';
import 'package:being_pupil/Subscription/Subscription_Plan_Screen.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'My_Course/Educator_MyCourse_Screen.dart';
import 'My_Course/Learner_MyCourse_Screen.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? registerAs, imageUrl;

  String? profilePicUrl;
  String? name;
  String? mobileNumber;
  String? degreeName;
  String? schoolName;
  int? isSubscribed;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final preferences = await SharedPreferences.getInstance();

    registerAs = preferences.getString('RegisterAs');
    imageUrl = preferences.getString('imageUrl');
    name = preferences.getString('name');
    mobileNumber = preferences.getString('mobileNumber');
    profilePicUrl = preferences.getString('imageUrl');
    degreeName = preferences.getString("qualification");
    schoolName = preferences.getString("schoolName");
    isSubscribed = preferences.getInt('isSubscribed');
    setState(() {});
  }

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
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              width: 100.0.w,
              child: Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: profilePicUrl!,
                            errorWidget: (context, url, error) => Text("error"),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 16.5.h,
                              width: 29.5.w,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              backgroundColor: Constants.bgColor,
                            ),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text(
                            name!,
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
                            mobileNumber!,
                            style: TextStyle(
                                color: Constants.bgColor,
                                fontFamily: 'Montserrat',
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Visibility(
                            visible: registerAs == 'E' ? true : false,
                            child: Text(
                              '$degreeName | $schoolName',
                              style: TextStyle(
                                  color: Constants.bgColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0.h),
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              registerAs == 'E'
                                  ? pushNewScreen(context,
                                      screen: EducatorMyProfileScreen(),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino)
                                  : pushNewScreen(context,
                                      screen: LearnerMyProfileScreen(),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "My Profile",
                              image: "assets/icons/myProfile.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: registerAs == 'E' ? 1.0.h : 0.0,
                          ),
                          InkWell(
                            onTap: () {
                              registerAs == 'E'
                                  ? pushNewScreen(context,
                                      screen: EducatorMyCourseScreen(),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino)
                                  : pushNewScreen(context,
                                      screen: LearnerMyCourseScreen(),
                                      withNavBar: false,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                            },
                            child: Visibility(
                              visible: registerAs == 'E' ? true : false,
                              child: ProfileList(
                                txt: "My Courses",
                                image: "assets/icons/myCourse.png",
                                forwordIcon: true,
                                sizeImage: 20.0,
                                padding: 20.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              pushNewScreen(context,
                                  withNavBar: false,
                                  screen: MyBookingScreen(),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "My Bookings",
                              image: "assets/icons/myBooking.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              pushNewScreen(context,
                                  withNavBar: false,
                                  screen: SavedPostScreen(),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "Saved Posts",
                              image: "assets/icons/savedPost.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              pushNewScreen(context,
                                  screen: AboutUsScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "About",
                              image: "assets/icons/about.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 17.0,
                            ),
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              pushNewScreen(context,
                                  screen: FAQScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "FAQs",
                              image: "assets/icons/faq.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 17.0,
                            ),
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              pushNewScreen(context,
                                  screen: TermsAndPolicyScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: ProfileList(
                              txt: "Terms & Policy",
                              image: "assets/icons/termPolicy2.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 1.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              Share.share(
                                  'Download Being Pupil App! https://play.google.com/store/apps/details?id=com.beingPupil',
                                  subject: 'Download Being Pupil App!');
                            },
                            child: ProfileList(
                              txt: "Share",
                              image: "assets/icons/share.png",
                              forwordIcon: true,
                              sizeImage: 20.0,
                              padding: 19.0,
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
                          ),
                          InkWell(
                            onTap: () {
                              displayProgressDialog(context);
                              logout();
                              signOut()
                                  .then(
                                    (voidValue) {},
                                  )
                                  .catchError(
                                    (onError) {},
                                  )
                                  .whenComplete(() {
                                SharedPrefs.instance.deleteUser();
                                closeProgressDialog(context);

                                Navigator.of(context, rootNavigator: true)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                        (Route<dynamic> route) => false);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: ProfileList(
                                txt: "Logout",
                                image: "assets/icons/logout.png",
                                forwordIcon: false,
                                sizeImage: 20.0,
                                padding: 17.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.0.h,
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

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog();
        }));
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class ProfileList extends StatelessWidget {
  @override
  String? txt, image;
  GestureTapCallback? tap;
  double? padding, sizeImage;
  bool? forwordIcon;

  ProfileList(
      {this.txt,
      this.image,
      this.tap,
      this.padding,
      this.sizeImage,
      this.forwordIcon});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: padding!),
                      child: Image.asset(
                        image!,
                        height: sizeImage,
                        color: Constants.bgColor,
                      ),
                    ),
                    Text(
                      txt!,
                      style: TextStyle(
                          color: Constants.bgColor,
                          fontFamily: 'Montserrat',
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                forwordIcon == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Constants.bgColor,
                          size: 15.0,
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
