import 'package:being_pupil/Account/My_Course/Enrolled_Course_Details_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Get_Enrolled_Course_Model.dart';
import 'package:being_pupil/Registration/Learner_Registration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Edit_Profile_Educator.dart';
import 'Edit_Profile_Learner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class LearnerMyProfileScreen extends StatefulWidget {
  const LearnerMyProfileScreen({Key? key}) : super(key: key);

  @override
  _LearnerMyProfileScreenState createState() => _LearnerMyProfileScreenState();
}

class _LearnerMyProfileScreenState extends State<LearnerMyProfileScreen> {
  String? registerAs, authToken;
  Map<String, dynamic>? myProfileMap;
  bool isProfileLoading = true;
  String? name = '';
  String? profileImageUrl = '';
  String? degreeName = '';
  String? schoolName = '';
  String? location = '';
  String? mobileNumber, email;
  List<String> dateList = [];
  List<int?> idList = [];
  List<String?> nameList = [];
  List<String?> descriptionList = [];
  List<List<dynamic>?> linksList = [];
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
    //print(authToken);
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (courseLength > 0) {
            page++;
            getEnrolledCourseAPI(page);
            //print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getEnrolledCourseAPI(page);
          //print(page);
        }
      }
    });
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
    registerAs = preferences.getString('RegisterAs');
    mobileNumber = preferences.getString('mobileNumber');
    email = preferences.getString('email');
    });
    //print(registerAs);
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

  void _refresh() {
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

   void _launchSocialUrl(String url) async {
    //final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                  : myProfileMap!['data']['profile_status'] == 0
                  ? pushNewScreen(context,
                      screen: LearnerRegistration(
                        name: name,
                        mobileNumber: mobileNumber,
                        email: email,
                      ),
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
                          child:CachedNetworkImage(
                                                imageUrl: profileImageUrl!,
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //Name of Learner
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            name!,
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Constants.bgColor),
                          ),
                        ),
                        //Degree
                        // Padding(
                        //   padding: degreeName == ''
                        //       ? EdgeInsets.zero
                        //       : EdgeInsets.only(top: 2.0.h),
                        //   child: Text(
                        //     degreeName == '' ? '' : '$degreeName | $schoolName',
                        //     style: TextStyle(
                        //         fontSize: 10.0.sp,
                        //         fontFamily: 'Montserrat',
                        //         fontWeight: FontWeight.w400,
                        //         color: Constants.bgColor),
                        //   ),
                        // ),
                        //Location
                        Padding(
                          padding: location == ''
                              ? EdgeInsets.zero
                              : EdgeInsets.only(top: 1.0.h),
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
                                location!,
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
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: myProfileMap!['data']
                                            ['facebook_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    //print('Facebook!!!');
                                    _launchSocialUrl(
                                        myProfileMap!['data']['facebook_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/fbSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/facebook.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),
                               SizedBox(
                                width: myProfileMap!['data']['facebook_link'] == null ? 0.0 : 2.0.w,
                              ),
                              Visibility(
                                visible: myProfileMap!['data']
                                            ['instagram_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    //print('Instagram!!!');
                                    _launchSocialUrl(myProfileMap!['data']
                                        ['instagram_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/instaSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/instagram.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),
                               SizedBox(
                                width: myProfileMap!['data']['instagram_link'] == null ? 0.0 : 2.0.w,
                              ),

                              Visibility(
                                visible: myProfileMap!['data']
                                            ['linkedin_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    //print('LinkedIn!!!');
                                    _launchSocialUrl(
                                        myProfileMap!['data']['linkedin_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/linkedinSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/linkedin.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),        
                              SizedBox(
                                width: myProfileMap!['data']['linkedin_link'] == null ? 0.0 : 2.0.w,
                              ),
                              Visibility(
                                visible:
                                    myProfileMap!['data']['other_link'] == null
                                        ? false
                                        : true,
                                child: GestureDetector(
                                  onTap: () {
                                    //print('Other!!!');
                                    _launchSocialUrl(
                                        myProfileMap!['data']['other_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/otherSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/other_link.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),
                             
                             
                            ],
                          ),
                        ),
                        //Other Details
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Column>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '${myProfileMap!['data']['total_experience']} Yrs',
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Text(
                                    'Experience',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  )
                                ],
                              ),
                              // Column(
                              //   children: <Widget>[
                              //     Text(
                              //       myProfileMap['data']['total_post']
                              //           .toString(),
                              //       style: TextStyle(
                              //           fontSize: 10.0.sp,
                              //           color: Constants.bgColor,
                              //           fontWeight: FontWeight.w700,
                              //           fontFamily: 'Montserrat'),
                              //     ),
                              //     SizedBox(
                              //       height: 1.0.h,
                              //     ),
                              //     Text(
                              //       'Posts',
                              //       style: TextStyle(
                              //           fontSize: 8.0.sp,
                              //           color: Constants.bgColor,
                              //           fontWeight: FontWeight.w500,
                              //           fontFamily: 'Montserrat'),
                              //     )
                              //   ],
                              // ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    myProfileMap!['data']['total_connections']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Text(
                                    'Connections',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  )
                                ],
                              )
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

                myProfileMap!['data']['profile_status'] == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          Image.asset(
                            'assets/images/completeProfile.png',
                            height: 150.0,
                            width: 200.0,
                            fit: BoxFit.contain,
                          ),
                          TextButton(
                            onPressed: () {
                              pushNewScreen(context,
                                  screen: LearnerRegistration(
                                    name: name,
                                    mobileNumber: mobileNumber,
                                    email: email,
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: Text(
                              'Complete Profile',
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  color: Constants.blueTitle,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      )
                    //Enrolled Course
                    : Expanded(
                        child: Column(
                         // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           nameList.isNotEmpty
                           ? Padding(
                              padding: EdgeInsets.only(top: 1.0.h, left: 5.0.w),
                              child: Text('Course taken',
                                                    //'${result.data[index].startDate} to ${result.data[index].endDate}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Constants.bgColor)),
                            ) : Container(),
                            ListView.builder(
                                controller: _scrollController,
                                itemCount: nameList.length,
                                //physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.5.h, horizontal: 1.0.w),
                                    child: ListTile(
                                      onTap: () async {
                                        var isLeaveCourse = await pushNewScreen(
                                            context,
                                            screen: EnrolledCourseDetailScreen(
                                              courseId: idList[index],
                                              courseName: nameList[index],
                                              coursDate: dateList[index],
                                              courseDescription:
                                                  descriptionList[index],
                                              courseLinks:
                                                  linksList[index] as List<String>?,
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.cupertino);
                                        //print(isLeaveCourse);
                                        isLeaveCourse == 'leave'
                                            ? _refresh()
                                            : null;
                                      },
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height: 70.0,
                                            width: 70.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/postImage.png'),
                                                    fit: BoxFit.cover)),
                                          ),
                                          SizedBox(
                                            width: 5.0.w,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0),
                                                child: Container(
                                                  width: 63.0.w,
                                                  child: Text(
                                                    nameList[index]!,
                                                    //result.data[index].courseName,
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 11.0.sp,
                                                        fontWeight: FontWeight.w600,
                                                        color: Constants.bgColor),
                                                    overflow: TextOverflow.clip,
                                                  ),
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
                          ],
                        ),
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
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        myProfileMap = response.data;

        //print('PROFILE:::' + myProfileMap.toString());
        if (myProfileMap!['data'] != null) {
          name = myProfileMap!['data']['name'];
          //print('NAME:::' + name!);
          profileImageUrl = myProfileMap!['data']['profile_image'];
          degreeName = myProfileMap!['data']['last_degree'] == null
              ? ''
              : myProfileMap!['data']['last_degree'];
          //print('DEGREE:::' + degreeName!);
          schoolName = myProfileMap!['data']['school_name'] == null
              ? ''
              : myProfileMap!['data']['school_name'];
          //print('SCHOOL:::' + schoolName!);
          location = myProfileMap!['data']['City'] == null
              ? ''
              : myProfileMap!['data']['City'];
          //print('LOCATION:::' + location!);
          getEnrolledCourseAPI(page);
          isProfileLoading = false;
          setState(() {});
        } else {
          isProfileLoading = false;
          setState(() {});
        }
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
      if (e.response != null) {
        //print("This is the error message::::" +
            //e.response!.data['meta']['message']);
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

  Future<GetEnrolledCourse> getEnrolledCourseAPI(int page) async {
    //displayProgressDialog(context);

    try {
      var dio = Dio();
      var response = await dio.get('${Config.getEnrollCourseUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        result = GetEnrolledCourse.fromJson(response.data);
        //print(response.data);
        courseLength = 0;
        courseLength = result.data == [] ? 0 : result.data!.length;

        setState(() {});
        //closeProgressDialog(context);
        if (courseLength > 0) {
          for (int i = 0; i < courseLength; i++) {
            idList.add(result.data![i].courseId);
            nameList.add(result.data![i].courseName);
            dateList.add(
                '${result.data![i].startDate} to ${result.data![i].endDate}');
            descriptionList.add(result.data![i].courseDescription);
            linksList.add(result.data![i].courseLink);
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
          msg: result.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
      // closeProgressDialog(context);
      //closeProgressDialog(context);
      if (e.response != null) {
        // print("This is the error message::::" +
        //     e.response!.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
       // print(e.message);
      }
    }
    return result;
  }
}
