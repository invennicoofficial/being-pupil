import 'package:being_pupil/Account/My_Course/Course_Details.dart';
import 'package:being_pupil/Account/My_Course/Enrolled_Course_Details_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Get_Enrolled_Course_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Edit_Profile_Educator.dart';
import 'Edit_Profile_Learner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class LearnerMyProfileScreen extends StatefulWidget {
  const LearnerMyProfileScreen({Key key}) : super(key: key);

  @override
  _LearnerMyProfileScreenState createState() => _LearnerMyProfileScreenState();
}

class _LearnerMyProfileScreenState extends State<LearnerMyProfileScreen> {
  String registerAs, authToken;
  Map<String, dynamic> myProfileMap;
  bool isProfileLoading = true;
  String name = '';
  String profileImageUrl = '';
  String degreeName = '';
  String schoolName = '';
  String location = '';
  List<String> dateList = [];
  List<int> idList = [];
  List<String> nameList = [];
  List<String> descriptionList = [];
  List<List<dynamic>> linksList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int courseLength = 0;
  ScrollController _scrollController = ScrollController();
  var result = GetEnrolledCourse();
  int page = 1;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (courseLength > 0) {
            page++;
            getEnrolledCourseAPI(page);
            print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getEnrolledCourseAPI(page);
          print(page);
        }
      }
    });
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //setState(() {
    registerAs = preferences.getString('RegisterAs');
    //});
    print(registerAs);
    getMyProfileApi();
  }

  void _onLoading() async {
    //if (mounted) setState(() {});
    if (courseLength == 0) {
      //_refreshController.loadComplete();
      _refreshController.loadNoData();
    } else {
      _refreshController.requestLoading();
    }
  }

  void _refresh(){
    setState(() {
      isProfileLoading = true;
      page = 1;
      idList = [];
      nameList = [];
      descriptionList = [];
      dateList = [];
      linksList = [];
    });
    getMyProfileApi();
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
          },
          padding: EdgeInsets.zero,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              registerAs == 'E'
                  ? pushNewScreen(context,
                      screen: EditEducatorProfile(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino)
                  : pushNewScreen(context,
                      screen: EditLearnerProfile(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
            },
            child: Container(
              //color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
              child: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'My Profile',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: isProfileLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.bgColor),
            ))
          : Column(
              children: [
                Container(
                  //height: 50.0.h,
                  width: 100.0.w,
                  //color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.0.h, horizontal: 4.0.w),
                    child: Column(
                      children: <Widget>[
                        //Profile DP
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            profileImageUrl,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //Name of Learner
                        Padding(
                          padding: EdgeInsets.only(top: 2.0.h),
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Constants.bgColor),
                          ),
                        ),
                        //Degree
                        Padding(
                          padding: degreeName == ''
                              ? EdgeInsets.zero
                              : EdgeInsets.only(top: 2.0.h),
                          child: Text(
                            degreeName == '' ? '' : '$degreeName | $schoolName',
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                color: Constants.bgColor),
                          ),
                        ),
                        //Location
                        Padding(
                          padding: location == ''
                              ? EdgeInsets.zero
                              : EdgeInsets.only(top: 2.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              location == ''
                                  ? Container()
                                  : ImageIcon(
                                      AssetImage(
                                          'assets/icons/locationPin.png'),
                                      color: Constants.bgColor,
                                      size: 15.0,
                                    ),
                              SizedBox(
                                width: 0.5.w,
                              ),
                              Text(
                                location,
                                style: TextStyle(
                                    fontSize: 10.0.sp,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor),
                              ),
                            ],
                          ),
                        ),
                        //Social Handle
                        Padding(
                          padding: location == ''
                              ? EdgeInsets.zero
                              : EdgeInsets.only(top: 2.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  print('Apple!!!');
                                },
                                child: Container(
                                    height: 4.0.h,
                                    width: 8.0.w,
                                    child: Image.asset(
                                      'assets/icons/apple.png',
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              SizedBox(
                                width: 1.0.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('Google!!!');
                                },
                                child: Container(
                                    height: 4.0.h,
                                    width: 8.0.w,
                                    child: Image.asset(
                                      'assets/icons/google.png',
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              SizedBox(
                                width: 1.0.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('Facebook!!!');
                                },
                                child: Container(
                                    height: 4.0.h,
                                    width: 8.0.w,
                                    child: Image.asset(
                                      'assets/icons/facebook.png',
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              SizedBox(
                                width: 1.0.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('LinkedIn!!!');
                                },
                                child: Container(
                                    height: 4.0.h,
                                    width: 8.0.w,
                                    child: Image.asset(
                                      'assets/icons/linkedin.png',
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Profile Divider
                Divider(
                  height: 1.0.h,
                  color: Constants.bgColor.withOpacity(0.5),
                ),

                //Enrolled Course
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: nameList.length,
                      //physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.5.h, horizontal: 1.0.w),
                          child: ListTile(
                            onTap: () async{
                              var isLeaveCourse = await pushNewScreen(context,
                                  screen: EnrolledCourseDetailScreen(
                                    courseId: idList[index],
                                    courseName: nameList[index],
                                    coursDate: dateList[index],
                                    courseDescription: descriptionList[index],
                                    courseLinks: linksList[index],
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                                      print(isLeaveCourse);
                                      isLeaveCourse == 'leave' ? _refresh() : null;

                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 10.0.h,
                                  width: 18.0.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/postImage.png'),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  width: 5.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 65.0.w,
                                      child: Text(
                                        nameList[index],
                                        //result.data[index].courseName,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 11.0.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Constants.bgColor),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Text(dateList[index],
                                        //'${result.data[index].startDate} to ${result.data[index].endDate}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 8.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Constants.bgColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  //Get Profile Details
  Future<void> getMyProfileApi() async {
    try {
      Dio dio = Dio();

      var response = await dio.get(Config.myProfileUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        myProfileMap = response.data;

        print('PROFILE:::' + myProfileMap.toString());
        if (myProfileMap['data'] != null) {
          name = myProfileMap['data']['name'];
          profileImageUrl = myProfileMap['data']['profile_image'];
          degreeName = myProfileMap['data']['last_degree'] == null
              ? ''
              : myProfileMap['data']['last_degree'];
          schoolName = myProfileMap['data']['school_name'] == null
              ? ''
              : myProfileMap['data']['school_name'];
          location = myProfileMap['data']['city'] == null
              ? ''
              : myProfileMap['data']['city'];
          getEnrolledCourseAPI(page);
          isProfileLoading = false;
          setState(() {});
        } else {
          isProfileLoading = false;
          setState(() {});
        }
      } else {
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }

  Future<GetEnrolledCourse> getEnrolledCourseAPI(int page) async {
    //displayProgressDialog(context);

    try {
      var dio = Dio();
      var response = await dio.get('${Config.getEnrollCourseUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      if (response.statusCode == 200) {
        result = GetEnrolledCourse.fromJson(response.data);
        print(response.data);
        courseLength = 0;
        courseLength = result.data == [] ? 0 : result.data.length;

        setState(() {});
        //closeProgressDialog(context);
        if (courseLength > 0) {
          for (int i = 0; i < courseLength; i++) {
            idList.add(result.data[i].courseId);
            nameList.add(result.data[i].courseName);
            dateList.add(
                '${result.data[i].startDate} to ${result.data[i].endDate}');
            descriptionList.add(result.data[i].courseDescription);
            linksList.add(result.data[i].courseLink);
          }
          isProfileLoading = false;
          setState(() {});
        } else {
          isProfileLoading = false;
          setState(() {});
        }
      } else {
        isProfileLoading = false;
        setState(() {});
        Fluttertoast.showToast(
          msg: result.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      // closeProgressDialog(context);
      //closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::" +
            e.response.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return result;
  }
}
