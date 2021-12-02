import 'package:being_pupil/Account/My_Course/Course_Details.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Get_My_Course_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import 'Create_Course_Screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class EducatorMyCourseScreen extends StatefulWidget {
  EducatorMyCourseScreen({Key key}) : super(key: key);

  @override
  _EducatorMyCourseScreenState createState() => _EducatorMyCourseScreenState();
}

class _EducatorMyCourseScreenState extends State<EducatorMyCourseScreen> {
  String authToken;
  int courseLength = 0;
  var result = GetMyCourse();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  int page = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getMyCourseAPI(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (courseLength > 0) {
            page++;
            getMyCourseAPI(page);
            print(page);
          }else{
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getMyCourseAPI(page);
          print(page);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('My Course',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 2.0.w),
              child: IconButton(
                  icon: Icon(Icons.add_box_outlined, color: Colors.white),
                  onPressed: () {
                    print('ADD!!!');
                    pushNewScreen(context,
                        screen: CreateCourseScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  })),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
          itemCount: courseLength,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.0.w),
              child: ListTile(
                onTap: () {
                  pushNewScreen(context,
                      screen: CourseDetailScreen(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
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
                              image: AssetImage('assets/images/postImage.png'),
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
                            result.data[index].courseName,
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
                        Text(
                            '${result.data[index].startDate} to ${result.data[index].endDate}',
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
    );
  }

  //Get My  Course API

  Future<GetMyCourse> getMyCourseAPI(int page) async {
    displayProgressDialog(context);

    try {
      var dio = Dio();
      var response = await dio.get(Config.getMyCourseUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      if (response.statusCode == 200) {
        result = GetMyCourse.fromJson(response.data);
        print(response.data);
        courseLength = result.data == [] ? 0 : result.data.length;
        setState(() {});
        closeProgressDialog(context);
      } else {
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
      closeProgressDialog(context);
      closeProgressDialog(context);
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
