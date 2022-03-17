import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class VerificationScreen extends StatefulWidget {
  String? verificationStatus;
  VerificationScreen({Key? key, this.verificationStatus}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

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
          'Verification Screen',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.verificationStatus == 'R'
                ? 'assets/icons/failed.png'
                : 'assets/icons/ok.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 15,),
              Text(widget.verificationStatus == 'R'
                ? 'Your profile is Rejected!\nPlease fill proper details and try again.'
                : 'Your profile is under verification!\nPlease try again after sometime.',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                    textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
