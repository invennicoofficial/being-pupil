import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Enroll_Course_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:url_launcher/url_launcher.dart';
import 'Update_Course_Screen.dart';

class CourseDetailScreen extends StatefulWidget {
  String? courseName, courseStartDate, courseEndDate, courseDescription;
  List<String>? courseLinks;
  int? courseId;
  CourseDetailScreen(
      {Key? key,
      this.courseId,
      this.courseName,
      this.courseStartDate,
      this.courseEndDate,
      this.courseDescription,
      this.courseLinks})
      : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  String? registerAs, authToken, enrollText = 'ENROLL';

  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    print(registerAs);
  }

   void _launchUrl(String url) async {
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        // actions: <Widget>[
        //   registerAs == 'E'
        //       ? Padding(
        //           padding: EdgeInsets.only(right: 0.0.w),
        //           child: Center(
        //               child: FlatButton(
        //             onPressed: () {
        //               print('EDIT!!!');
        //               pushNewScreen(context,
        //                   screen: UpdateCourseScreen(
        //                     courseId: widget.courseId!,
        //                     courseName: widget.courseName!,
        //                     courseDescription: widget.courseDescription!,
        //                     startDate: widget.courseStartDate!,
        //                     endDate: widget.courseEndDate!,
        //                     linkList: widget.courseLinks
        //                   ),
        //                   withNavBar: false,
        //                   pageTransitionAnimation:
        //                       PageTransitionAnimation.cupertino);
        //             },
        //             child: Text(
        //               'Edit',
        //               style: TextStyle(
        //                   fontFamily: 'Montserrat',
        //                   fontSize: 12.0.sp,
        //                   fontWeight: FontWeight.w500,
        //                   color: Colors.white.withOpacity(0.6)),
        //             ),
        //           )),
        //         )
        //       : Container(),
        // ],
        title: Text(
          'Course Details',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 2.0.h),
        child: GestureDetector(
          onTap: enrollText == 'ENROLLED'
          ? null
          : () {
            enrollCourseAPI();
          },
          child: Container(
            height: 7.0.h,
            width: 90.0.w,
            padding: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: Constants.bpOnBoardTitleStyle,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                color: Constants.formBorder,
                width: 0.15,
              ),
            ),
            child: Center(
              child: Text(
                enrollText!,
                //'Enroll'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 11.0.sp),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.courseName!,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w700,
                      color: Constants.bgColor),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/cal.png',
                      height: 4.0.h,
                      width: 5.5.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: 2.0.w,
                    ),
                    Text('${widget.courseStartDate!} to ${widget.courseStartDate!}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bgColor)),
                  ],
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Container(
                  child: Text(
                    widget.courseDescription!,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.courseLinks!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          _launchUrl(widget.courseLinks![index]);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0.h),
                          child: Container(
                            height: 7.0.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Constants.formBorder),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 7.0.h,
                                  width: 20.0.w,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/postImage.png'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      height: 5.0.h,
                                      //width: 70.0.w,
                                      child: Center(
                                        child: Text(
                                          widget.courseLinks![index],
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bgColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Course Enroll API
  Future<EnrollCourse> enrollCourseAPI() async {
    displayProgressDialog(context);
    var result = EnrollCourse();
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap({'course_id': widget.courseId});
      var response = await dio.post(Config.enrollCourseUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        print(response.data);
        result = EnrollCourse.fromJson(response.data);
        closeProgressDialog(context);
        if(result.status == true){
          setState(() {
            enrollText = 'ENROLLED';
          });
        }else{}
        if (result.message == null) {
          Fluttertoast.showToast(
            msg: result.errorMsg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else {
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
      } else {
        Fluttertoast.showToast(
          msg: result.errorMsg,
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
      if (e.response != null) {
        print("This is the error message::::" +
            e.response!.data['meta']['message']);
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
