import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/StudyBuddy/Connection_List.dart';
import 'package:being_pupil/StudyBuddy/Educator_List.dart';
import 'package:being_pupil/StudyBuddy/Request_List.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LearnerStudyBuddyScreen extends StatefulWidget {
  LearnerStudyBuddyScreen({Key key}) : super(key: key);

  @override
  _LearnerStudyBuddyScreenState createState() => _LearnerStudyBuddyScreenState();
}

class _LearnerStudyBuddyScreenState extends State<LearnerStudyBuddyScreen> {
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          title: Text('Study Buddy',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 2.0.w),
                child: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      print('Search!!!');
                    })),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(7.0.h),
            child: ColoredBox(
              color: Colors.white,
              child: TabBar(
                  //indicatorPadding: EdgeInsets.symmetric(horizontal: 3.0.w),
                  //indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  labelColor: Constants.bgColor,
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Constants.bgColor),
                  unselectedLabelColor: Constants.bpSkipStyle,
                  unselectedLabelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Constants.bpSkipStyle),
                  indicatorColor: Colors.black,
                  indicatorWeight: 2.0,
                  tabs: [
                    Tab(
                      text: 'Connection',
                    ),
                    Tab(
                      text: 'Request',
                    ),
                    Tab(
                      text: 'Learner',
                    )
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
                  image: DecorationImage(
                      image: AssetImage('assets/images/studyBudyBg.png'),
                      fit: BoxFit.cover)),
            ),
            TabBarView(
              children: <Widget>[
                ConnectionList(),
                RequestList(),
                EducatorList()
              ],
            ),
          ],
        ),
      ),
    );
  }
}