import 'dart:convert';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Subscription_Model/Create_Subscription_Model.dart';
import 'package:being_pupil/Model/Subscription_Model/Get_All_Plan_List_Model.dart';
import 'package:being_pupil/Model/Subscription_Model/Update_Subscription_Model.dart';
import 'package:being_pupil/Model/Subscription_Model/Verify_Subscription_Model.dart';
import 'package:being_pupil/Subscription/Current_Subscription_Screen.dart';
import 'package:being_pupil/Subscription/Failed_Payment_Screen.dart';
import 'package:being_pupil/Subscription/Successful_Payment_Screen.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:http/http.dart' as http;

class UpdateSubscriptionPlanScreen extends StatefulWidget {
  UpdateSubscriptionPlanScreen({Key? key}) : super(key: key);

  @override
  State<UpdateSubscriptionPlanScreen> createState() =>
      _UpdateSubscriptionPlanScreen();
}

class _UpdateSubscriptionPlanScreen
    extends State<UpdateSubscriptionPlanScreen> {
  String? registerAs;
  List<String> content = [
    // 'Live Stream',
    // 'Create your own Courses',
    // 'Connect with Educators',
    // 'Connect with Educators'
  ];

  List<String> planList = [];
  //'One Month', 'Monthly Recuring', 'Yearly Recuring'];

  List<double> planPrice = [];
  List<String> planId = [];
  //501, 301, 2001];

  var result = GetAllPlanList();
  bool isLoading = true;
  String? authToken;
  String? mobileNumber, email, userName, subscriptionId;
  var _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getData();
    getAllPlanList();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      // mobileNumber = preferences.getString('mobileNumber');
      // email = preferences.getString('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Constants.bgColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                size: 25.0,
                color: Colors.white,
              ))
        ],
        title: Text(
          registerAs == 'L' ? "Hello Study Buddy" : "Hello Fellow Educator",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0.h),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/subscription.png",
                      height: 170.0,
                      width: 170.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Container(
                      //color: Colors.grey,
                      padding: EdgeInsets.only(left: 100.0),
                      //width: 200.0,
                      child: ListView.builder(
                          itemCount: content.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1.0.h),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icons/checked.png",
                                      height: 15.0,
                                      width: 15.0,
                                    ),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Text(content[index],
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'Montserrat',
                                            fontSize: 12.0.sp,
                                            fontWeight: FontWeight.w400)),
                                  ]),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),

                    //mian Devider
                    Divider(
                      height: 0.5.h,
                      thickness: 0.5,
                      color: Colors.white54,
                    ),

                    //plan list
                    ListView.builder(
                        itemCount: planList.isEmpty ? 0 : planList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                            child: Column(
                              children: [
                                ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Row(
                                    children: [
                                      Text(planList[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontSize: 12.0.sp,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      index == 1
                                          ? Container(
                                              height: 20.0,
                                              width: 100.0,
                                              decoration: BoxDecoration(
                                                  color: Constants.selectedIcon,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0)),
                                              child: Center(
                                                child: Text('Recommended',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 8.0.sp,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                  subtitle: Text(
                                      "₹ ${planPrice[index].toString()} / user",
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontFamily: 'Montserrat',
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.w400)),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _showDialog(
                                          planList[index],
                                          planPrice[index].toInt(),
                                          planId[index]);
                                    },
                                    icon: Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.white70,
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0.h,
                                ),

                                //mian Devider
                                Divider(
                                  height: 0.5.h,
                                  thickness: 0.5,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
    );
  }

  //Alert Dialog
  void _showDialog(String planName, int amount, String planId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                planName,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Constants.bgColor),
              ),
              // IconButton(
              //   icon: Icon(Icons.close),
              //   iconSize: 20.0,
              //   color: Constants.bpOnBoardSubtitleStyle,
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // )
            ],
          ),
          actionsPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          content: Text("You will be charged ₹$amount for one month.",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Constants.bgColor),
              textAlign: TextAlign.center),
          actions: [
            // usually buttons at the bottom of the dialog

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
                updateSubscriptionIdAPI(planId, amount, planName);
                //createRazorPaySubscriptionId(amount, planName);
                // pushNewScreen(context,
                //     screen: CurrentSubscriptionScreen(),
                //     withNavBar: false,
                //     pageTransitionAnimation: PageTransitionAnimation.cupertino);
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

//Get All PLan LIst API
  Future<void> getAllPlanList() async {
    var dio = Dio();
    try {
      var response = await dio.get(Config.getAllPlanUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        result = GetAllPlanList.fromJson(response.data);
        print(response);
        if (result.status == true) {
          for (int i = 0; i < result.data!.plan!.length; i++) {
            planList.add(result.data!.plan![i].planName!);
            planPrice.add(double.parse(result.data!.plan![i].planPrice!));
            planId.add(result.data!.plan![i].planId.toString());
          }
          for (int i = 0; i < result.data!.feature!.length; i++) {
            content.add(result.data!.feature![i]);
          }
          isLoading = false;
          setState(() {});
        }
      }
    } on DioError catch (e, stack) {
      print(e.message);
      print(stack);
    }
  }

  //Create SubscriptionId
  Future<UpdateSubscription> updateSubscriptionIdAPI(
      String planId, int price, String name) async {
    displayProgressDialog(context);
    var result = UpdateSubscription();
    var dio = Dio();
    FormData formData = FormData.fromMap({'plan_id': planId});
    try {
      var response = await dio.post(Config.updateSubscription,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        result = UpdateSubscription.fromJson(response.data);
        print(response);
        if (result.status == true) {
          setState(() {
            subscriptionId = result.data!.updatedPlanSubscriptionId;
            userName = result.data!.userName;
            mobileNumber = result.data!.userMobile;
            email = result.data!.userEmail;
          });
          Fluttertoast.showToast(
            msg: result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          createRazorPaySubscriptionId(price, name, subscriptionId!);
        }
      } else {
        Fluttertoast.showToast(
          msg: result.errorMsg!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    } on DioError catch (e, stack) {
      closeProgressDialog(context);
      print(e.message);
      print(stack);
    }
    return result;
  }

  //Verify Subscription
  Future<VerifySubscription> verifySubscriptionAPI(
      String paymentId, String subscriptioId, String signature) async {
    displayProgressDialog(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = VerifySubscription();
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'razorpay_payment_id': paymentId,
      'razorpay_subscription_id': subscriptioId,
      'razorpay_signature': signature
    });
    try {
      var response = await dio.post(Config.verifySubscription,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        result = VerifySubscription.fromJson(response.data);
        print(response);
        if (result.status == true) {
          setState(() {
            preferences.setString('razorpayLink', result.data!.razorpayLink!);
            preferences.setInt('isSubscribed', 1);
          });
          debugPrint('LINK:::${preferences.getString('razorpayLink')}');
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => PaymentSucessScreen()),
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
    } on DioError catch (e, stack) {
      closeProgressDialog(context);
      print(e.message);
      print(stack);
    }
    return result;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('kama liyaa!');
    print(subscriptionId);
    print(response.paymentId);
    print(response.signature);
    //createBookingAPI(response.orderId, response.paymentId, response.signature);
    verifySubscriptionAPI(
        response.paymentId!, subscriptionId!, response.signature!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: 'Payment Failed! Please try again');
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PaymentFailedScreen()),
        (Route<dynamic> route) => false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  Future<void> createRazorPaySubscriptionId(
      int price, String name, String subId) async {
    Map<String, dynamic>? map = {};
    var headers = {
      'Authorization':
          'Basic cnpwX3Rlc3RfTXREclBQTFdiVWRzWTc6TlZiWU5VNHRQMVdrQlU4SGlpWlljU21i'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.razorpay.com/v1/orders'));
    request.fields
        .addAll({'amount': (price * 100).toString(), 'currency': 'INR'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      map = json.decode(jsonResponse);
      print(map!['id']);
      print('MAP:::::' + map.toString());
      //TODO: Change Razorpay Keys
      var options = {
        'key': 'rzp_test_MtDrPPLWbUdsY7',
        'amount': (price * 100),
        'name': name,
        'subscription_id': subId,
        //'description': widget.propertyDetails![widget.index!]['name'],//widget.propertyDetails.data[widget.index].name,
        'prefill': {'contact': mobileNumber, 'email': email}
      };
      _razorpay.open(options);
    } else {
      Fluttertoast.showToast(
        msg: 'Please try again',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.bgColor,
        textColor: Colors.white,
        fontSize: 10.0.sp,
      );
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
