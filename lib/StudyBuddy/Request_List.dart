import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Educator_ProfileView_Screen.dart';
import 'Learner_ProfileView_Screen.dart';

class RequestList extends StatefulWidget {
  RequestList({Key key}) : super(key: key);

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  String registerAs;

  @override
  void initState() {
    super.initState();
    getData();
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 15,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              child: Padding(
                padding: EdgeInsets.only(left: 2.0.w),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  //leading:
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          registerAs == 'E'
                              ? pushNewScreen(context,
                                  screen: EducatorProfileViewScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino)
                              : pushNewScreen(context,
                                  screen: LearnerProfileViewScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/dp2.png',
                            width: 8.5.w,
                            height: 5.0.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 2.0.w,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(right: 13.0.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rebecca Wells",
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
                          ],
                        ),
                      ),

                      //Buttons
                      Padding(
                        padding: EdgeInsets.only(right: 2.0.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('$index is Rejected');
                              },
                              child: Container(
                                height: 3.5.h,
                                width: 16.0.w,
                                decoration: BoxDecoration(
                                    color: Constants.bgColor,
                                    border: Border.all(
                                        color: Constants.bgColor, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Center(
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.0.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                print('$index is Connected');
                              },
                              child: Container(
                                height: 3.5.h,
                                width: 16.0.w,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.bgColor, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Center(
                                  child: Text(
                                    'Connect',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Constants.bgColor,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
