import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Subscription_Model/Cancel_Subscription_Model.dart';
import 'package:being_pupil/Model/Subscription_Model/Current_Subscription_Model.dart';
import 'package:being_pupil/Subscription/Manage_Payment_Screen.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

import 'Update_SubScription_Screen.dart';

class CurrentSubscriptionScreen extends StatefulWidget {
  CurrentSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<CurrentSubscriptionScreen> createState() =>
      _CurrentSubscriptionScreenState();
}

class _CurrentSubscriptionScreenState extends State<CurrentSubscriptionScreen> {
  bool isLoading = true;
  String? authToken, razorpayLink;
  var result;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getData();
    getCurrentSubscriptionAPI();
  }

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      razorpayLink = preferences.getString('razorpayLink');
    });
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        title: Text(
          'Subscription',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constants.bgColor),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 3.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${result.data!.planName} Subscription Plan',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Constants.bgColor),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    'See your billing information and cancel the Plan',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Text(
                    'Billing information',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Constants.bgColor),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    result.data!.planType == 'O'
                        ? 'Your payment of ₹${result.data!.planAmount}* for ${result.data!.planName} Subscription valid till ${result.data!.subscriptionEndDate}.'
                        : 'Your next payment of ₹${result.data!.planAmount}* for ${result.data!.planName} Subscription is scheduled for ${result.data!.nextBillDate}.',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Text(
                    '*Sales tax not included',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      pushNewScreen(context,
                          screen:
                              ManagePaymentScreen(razorpayLink: razorpayLink!),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    child: Container(
                      child: Text(
                        'Manage payment methods',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w500,
                            color: Constants.selectedIcon),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Text(
                    'Manage subscription',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Constants.bgColor),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    'You’re currently subscribed to ${result.data!.planName} plan.',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Text(
                    '*Sales tax not included',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          pushNewScreen(context,
                              screen: UpdateSubscriptionPlanScreen(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                        child: Text(
                          'Switch Plan',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w500,
                              color: Constants.selectedIcon),
                        ),
                      ),
                      SizedBox(
                        width: 2.0.w,
                      ),
                      TextButton(
                        onPressed: () {
                          result.data!.planType == 'O'
                              ? Fluttertoast.showToast(
                                  msg: 'One time plan could not be cancelled.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Constants.bgColor,
                                  textColor: Colors.white,
                                  fontSize: 10.0.sp,
                                )
                              : _showDialog();
                        },
                        child: Text(
                          'Cancel Plan',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w500,
                              color: Constants.selectedIcon),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cancel Plan',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Constants.bgColor),
              ),
            ],
          ),
          actionsPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          content: Text(
              "Are You sure you want to cancel the one month subscription plan.",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Constants.bgColor),
              textAlign: TextAlign.center),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  height: 35.0,
                  width: 30.0.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Constants.bgColor, width: 1.0)),
                  child: Center(
                    child: Text("Cancel",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bgColor)),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                cancelSubscriptionAPI();
              },
              child: Container(
                  height: 35.0,
                  width: 30.0.w,
                  decoration: BoxDecoration(
                      color: Constants.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Constants.bgColor, width: 1.0)),
                  child: Center(
                    child: Text("Confirm",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  )),
            ),
          ],
        );
      },
    );
  }

  Future<void> getCurrentSubscriptionAPI() async {
    var dio = Dio();
    result = CurrentSubscription();
    try {
      var response = await dio.get(Config.currentSubscription,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        result = CurrentSubscription.fromJson(response.data);
        if (result.status == true) {
          isLoading = false;
          setState(() {});
        } else {
          Fluttertoast.showToast(
            msg: result.errorMsg == null ? result.message : result.errorMsg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      isLoading = false;
      setState(() {});

      if (e.response != null) {
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    }
  }

  Future<void> cancelSubscriptionAPI() async {
    displayProgressDialog(context);
    SharedPreferences preff = await SharedPreferences.getInstance();
    var dio = Dio();
    var result = CancelSubscription();
    try {
      var response = await dio.post(Config.cencelSubscription,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        result = CancelSubscription.fromJson(response.data);
        closeProgressDialog(context);

        if (result.status == true) {
          preff.setInt('isSubscribed', 0);
          setState(() {});
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => bottomNavBar(4)),
              (Route<dynamic> route) => false);
          Fluttertoast.showToast(
            msg: result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else {
          Fluttertoast.showToast(
            msg: result.errorMsg == null ? result.message : result.errorMsg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      closeProgressDialog(context);

      if (e.response != null) {
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    }
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
