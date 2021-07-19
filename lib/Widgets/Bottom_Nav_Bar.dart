import 'package:being_pupil/Account/Account_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Home_Screen.dart';
import 'package:being_pupil/Learner/Learner_Screen.dart';
import 'package:being_pupil/StayAndStudy/Stay_And_Study_Screen.dart';
import 'package:being_pupil/StudyBuddy/Study_Buddy_Screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
  bool isSubscribed = false;
  String authToken;

  @override
  void initState() {
    setIndex();
    //getUserData();
    setState(() {});
    super.initState();
  }

//for navigate to bottom navBar index 3
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
        //callPage(widget.index);
      });
      // BottomNavigationDotBarItem(
      //           icon: 'assets/icon/food_club_icon.webp',
      //           // icon: Icons.local_grocery_store,
      //           onTap: () {
      //             setState(() {
      //               currentIndex = widget.index;
      //             });
      //           });
    }
  }

  // getUserData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   authToken = await storage.FlutterSecureStorage().read(key: 'auth_token');
  //   isSubscribed = preferences.getBool('isSubscribed');

  //   setState(() {});
  //   print(authToken);
  // }

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new HomeScreen();
        break;
      case 1:
        return new StayAndStudyScreen();
        //return new MapsScreenT1();
        break;
      case 2:
        return new LearnerScreen();
        break;
      case 3:
        return new StudyBuddyScreen();
        break;
      case 4:
        return new AccountScreen();
        break;
      default:
        return new HomeScreen();
    }
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      StayAndStudyScreen(),
      LearnerScreen(),
      //isSubscribed ? PackageScreen() : FoodClubScreen(),
      StudyBuddyScreen(),
      AccountScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon:  ImageIcon(AssetImage('assets/icons/home.png'),size: 50),
          title: ("Home"),
          activeColorPrimary: Constants.selectedIcon,
          inactiveColorPrimary: Constants.bgColor),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/stayStudy.png'),size: 30),
        title: ("Stay Study"),
        activeColorPrimary: Constants.selectedIcon,
        inactiveColorPrimary: Constants.bgColor,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/learner.png'),size: 30),
        title: ("Learner"),
        activeColorPrimary: Constants.selectedIcon,
        inactiveColorPrimary: Constants.bgColor,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/support.png'),size: 30),
        title: ("Study Buddy"),
        activeColorPrimary: Constants.selectedIcon,
        inactiveColorPrimary: Constants.bgColor,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/account.png'),size: 30),
        title: ("Account"),
        activeColorPrimary: Constants.selectedIcon,
        inactiveColorPrimary: Constants.bgColor,
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
      // decoration: NavBarDecoration(
      //   borderRadius: BorderRadius.circular(10.0),
      //   colorBehindNavBar: Colors.white,
      // ),
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
      //navBarHeight: MediaQuery.of(context).size.height * 0.10,
      navBarStyle: NavBarStyle.style3,
    );
  }
}

//go to home page
// Navigator.of(context).pushAndRemoveUntil(
//     MaterialPageRoute(builder: (context) => bottomNavBar(0)),
//     (Route<dynamic> route) => false);
