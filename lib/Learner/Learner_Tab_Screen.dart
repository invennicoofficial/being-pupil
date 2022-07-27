import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Learner/Connection_List_Learner.dart';
import 'package:being_pupil/Learner/Educator_List_For_Learner.dart';
import 'package:being_pupil/Learner/Learner_List_For_Learner.dart';
import 'package:being_pupil/Learner/Request_List_Learner.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Search_Learner_Screen.dart';

class LearnerStudyBuddyScreen extends StatefulWidget {
  LearnerStudyBuddyScreen({Key? key}) : super(key: key);

  @override
  _LearnerStudyBuddyScreenState createState() =>
      _LearnerStudyBuddyScreenState();
}

class _LearnerStudyBuddyScreenState extends State<LearnerStudyBuddyScreen> {
  String? registerAs;

  String? searchIn;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      searchIn = registerAs == 'E' ? 'L' : 'E';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.bgColor,
          title: Text(registerAs == 'E' ? 'Learners' : 'Educators',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 2.0.w),
                child: IconButton(
                    icon: Image.asset('assets/icons/searchNew.png',
                        height: 20.0, width: 20.0, color: Colors.white),
                    onPressed: () {
                      pushNewScreen(context,
                          screen: SearchForLearnerScreen(
                            searchIn: searchIn,
                          ),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    })),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(7.0.h),
            child: ColoredBox(
              color: Colors.white,
              child: TabBar(
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  labelColor: Constants.bgColor,
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Constants.bgColor),
                  unselectedLabelColor: Constants.bpSkipStyle,
                  unselectedLabelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Constants.bpSkipStyle),
                  indicatorColor: Colors.black,
                  indicatorWeight: 2.0,
                  isScrollable: false,
                  onTap: (index) {
                    if (index == 0) {
                      if (registerAs == 'E') {
                        setState(() {
                          searchIn = 'L';
                        });
                      } else {
                        setState(() {
                          searchIn = 'E';
                        });
                      }
                    } else if (index == 1) {
                      setState(() {
                        searchIn = 'R';
                      });
                    } else {
                      setState(() {
                        searchIn = 'C';
                      });
                    }
                  },
                  tabs: [
                    Tab(
                      text: registerAs == 'E' ? 'Learners' : 'Educators',
                    ),
                    Tab(
                      text: 'Requests',
                    ),
                    Tab(
                      text: 'Connections',
                    ),
                  ]),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: 100.0.h,
              width: 100.0.w,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  image: DecorationImage(
                      image: AssetImage('assets/images/studyBudyBg.png'),
                      fit: BoxFit.cover)),
            ),
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                registerAs == 'E'
                    ? LearnerListForLearner()
                    : EducatorListForLearner(),
                RequestListLearner(),
                ConnectionListLearner(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
