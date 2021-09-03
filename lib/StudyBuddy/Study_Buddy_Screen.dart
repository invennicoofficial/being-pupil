import 'package:being_pupil/StudyBuddy/Educator_ProfileView_Screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Learner_ProfileView_Screen.dart';

class StudyBuddyScreen extends StatefulWidget {
  StudyBuddyScreen({Key key}) : super(key: key);

  @override
  _StudyBuddyScreenState createState() => _StudyBuddyScreenState();
}

class _StudyBuddyScreenState extends State<StudyBuddyScreen> {

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
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        registerAs == 'E'
        ? pushNewScreen(context,
            screen: EducatorProfileViewScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino)
        : pushNewScreen(context,
            screen: LearnerProfileViewScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino);
      },
      child: Container(
        child: Center(
          child: Text('For Study Buddy Profile Screen Tap on Me'),
        ),
      ),
    ));
  }
}
