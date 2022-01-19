import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/StudyBuddy/Connection_List.dart';
import 'package:being_pupil/StudyBuddy/Educator_List.dart';
import 'package:being_pupil/StudyBuddy/Learner_List.dart';
import 'package:being_pupil/StudyBuddy/Request_List.dart';
import 'package:being_pupil/StudyBuddy/Search_Screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class EducatorStudyBuddyScreen extends StatefulWidget {
  EducatorStudyBuddyScreen({Key? key}) : super(key: key);

  @override
  _EducatorStudyBuddyScreenState createState() =>
      _EducatorStudyBuddyScreenState();
}

class _EducatorStudyBuddyScreenState extends State<EducatorStudyBuddyScreen>
//with SingleTickerProviderStateMixin
{
  String? registerAs;
  //TabController _tabController;
  //int selectedIndex = 0;
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
      searchIn = registerAs == 'E' ? 'E' : 'L';
    });
    print(registerAs);
    // _tabController = TabController(length: 3, vsync: this);
    // _tabController.addListener(() {
    //   setState(() {
    //     selectedIndex = _tabController.index;
    //   });
    //   print('Selected Index::: ' +selectedIndex.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.bgColor,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.west_rounded,
          //     color: Colors.white,
          //     size: 35.0,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   padding: EdgeInsets.zero,
          // ),
          title: Text(registerAs == 'L' ? 'Study Buddy' : 'Fellow Educator',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 2.0.w),
                child: IconButton(
                    icon: Image.asset('assets/icons/searchNew.png', height: 20.0, width: 20.0, color: Colors.white),
                    onPressed: () {
                      pushNewScreen(context,
                          screen: SearchScreen(
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
                  //controller: _tabController,
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
                  isScrollable: false,
                  onTap: (index) {
                    if (index == 0) {
                      if (registerAs == 'E') {
                        setState(() {
                          searchIn = 'E';
                        });
                      } else {
                        setState(() {
                          searchIn = 'L';
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
                    print('Selected Index::: ' + searchIn!);
                  },
                  tabs: [
                    Tab(
                      text: registerAs == 'E' ? 'Educators' : 'Learners',
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
                registerAs == 'E' ? EducatorList() : LearnerList(),      
                RequestList(),
                ConnectionList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
