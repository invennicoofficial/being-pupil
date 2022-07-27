import 'package:being_pupil/Account/Account_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Home_Screen.dart';
import 'package:being_pupil/Learner/Educator_Screen.dart';
import 'package:being_pupil/Learner/Learner_Screen.dart';
import 'package:being_pupil/Learner/Learner_Tab_Screen.dart';
import 'package:being_pupil/StayAndStudy/Stay_And_Study_Screen.dart';
import 'package:being_pupil/StudyBuddy/Study_Buddy_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bottomNavBar extends StatefulWidget {
  final int index;
  bottomNavBar(
    this.index,
  );
  _bottomNavBarState createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  int currentIndex = 0;
  bool _color = true;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  int? isSubscribed;
  String? authToken;
  String? registerAs;

  @override
  void initState() {
    setIndex();
    getData();
    setState(() {});
    super.initState();
  }

  setIndex() {
    if (widget.index == null) {
      setState(() {
        currentIndex = 0;
        _controller.jumpToTab(0);
      });
    } else {
      setState(() {
        currentIndex = widget.index;
        _controller.jumpToTab(widget.index);
      });
    }
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      isSubscribed = preferences.getInt('isSubscribed');
    });
  }

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new EducatorHomeScreen();

      case 1:
        return new StayAndStudyScreen();

      case 2:
        return registerAs == 'E' ? new EducatorScreen() : new LearnerScreen();

      case 3:
        return new EducatorStudyBuddyScreen();

      case 4:
        return new AccountScreen();

      default:
        return new EducatorHomeScreen();
    }
  }

  List<Widget> _buildScreens() {
    return [
      EducatorHomeScreen(),
      StayAndStudyScreen(),
      LearnerStudyBuddyScreen(),
      EducatorStudyBuddyScreen(),
      AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/icons/selectedHome.svg'),
          activeColorPrimary: Constants.selectedIcon,
          inactiveColorPrimary: Constants.bgColor,
          inactiveIcon: SvgPicture.asset('assets/icons/homeSvg.svg')),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/icons/selectedSS.svg'),
        activeColorPrimary: Constants.selectedIcon,
        inactiveColorPrimary: Constants.bgColor,
        inactiveIcon: SvgPicture.asset('assets/icons/ssSvg.svg'),
      ),
      PersistentBottomNavBarItem(
          icon: registerAs == 'E'
              ? SvgPicture.asset('assets/icons/selectedLearner.svg')
              : SvgPicture.asset('assets/icons/newSelEduSvg.svg'),
          activeColorPrimary: Constants.selectedIcon,
          inactiveColorPrimary: Constants.bgColor,
          inactiveIcon: registerAs == 'E'
              ? SvgPicture.asset('assets/icons/learnerSvg.svg')
              : SvgPicture.asset('assets/icons/newEduSvg.svg')),
      PersistentBottomNavBarItem(
          icon: registerAs == 'E'
              ? SvgPicture.asset('assets/icons/newSelSbSvg.svg')
              : SvgPicture.asset('assets/icons/selectedSBsvg.svg'),
          activeColorPrimary: Constants.selectedIcon,
          inactiveIcon: registerAs == 'E'
              ? SvgPicture.asset('assets/icons/newSbSvg.svg')
              : SvgPicture.asset('assets/icons/studybuddySvg.svg')),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/icons/selectedAccount.svg'),
        activeColorPrimary: Constants.selectedIcon,
        inactiveColorPrimary: Constants.bgColor,
        inactiveIcon: SvgPicture.asset('assets/icons/account.svg'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      padding: NavBarPadding.all(0.0),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
