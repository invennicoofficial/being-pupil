import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:being_pupil/Constants/Const.dart';

class TermsAndPolicyScreen extends StatefulWidget {
  final String url;
  const TermsAndPolicyScreen({
    Key? key,
    required this.url,
  }) : super(key: key);
  @override
  _TermsAndPolicyScreenState createState() => _TermsAndPolicyScreenState();
}

class _TermsAndPolicyScreenState extends State<TermsAndPolicyScreen> {
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
            // pushNewScreen(context,
            //     screen: HomeScreen(),
            //     pageTransitionAnimation: PageTransitionAnimation.fade);
          },
          padding: EdgeInsets.zero,
        ),
        title: Text(
          'Terms & Policy',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: WebView(
       initialUrl: widget.url,
      )
      // Container(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      //       style: TextStyle(
      //           fontFamily: 'Montserrat',
      //           fontSize: 12.0.sp,
      //           fontWeight: FontWeight.w500,
      //           color: Colors.black),
      //     ),
      //   ),
      // ),
    );
  }
}
