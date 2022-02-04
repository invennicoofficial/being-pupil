import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Subscription_Model/Get_All_Plan_List_Model.dart';
import 'package:being_pupil/Subscription/Current_Subscription_Screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class SubscriptionPlanScreen extends StatefulWidget {
  SubscriptionPlanScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String? registerAs;
  List<String> content = [
    'Live Stream',
    'Create your own Courses',
    'Connect with Educators',
    'Connect with Educators'
  ];

  List<String> planList = [];
    //'One Month', 'Monthly Recuring', 'Yearly Recuring'];

  List<String> planPrice = [];
    //501, 301, 2001];

  var result = GetAllPlanList();
  bool isLoading = true;
  String? authToken;

  @override
  void initState() {
    super.initState();
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
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.bgColor),
            ))
          :SingleChildScrollView(
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
                                                BorderRadius.circular(50.0)),
                                        child: Center(
                                          child: Text('Recommended',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 8.0.sp,
                                                  fontWeight: FontWeight.w500)),
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
                                _showDialog(planList[index],
                                    planPrice[index].toString());
                                
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
  void _showDialog(String planName, String amount) {
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
                pushNewScreen(context, screen: CurrentSubscriptionScreen(), withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino);
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
                  color: Colors.white)),)),
            ),
          ],
        );
      },
    );
  }

//Get All PLan LIst API
  Future<void> getAllPlanList() async{
    var dio = Dio();
    try{
      var response = await dio.get(Config.getAllPlanUrl, options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
        if(response.statusCode == 200){
          result = GetAllPlanList.fromJson(response.data);
          print(response);
          if(result.status == true){
            for(int i = 0; i < result.data!.plan!.length; i++){
              planList.add(result.data!.plan![i].planName!);
              planPrice.add(result.data!.plan![i].planPrice!);
            }
            isLoading = false;
            setState(() {
              
            });
          }
        }
    }on DioError catch(e, stack){
      print(e.message);
      print(stack);
    }
  }
}
