import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class LearnerProfileViewScreen extends StatefulWidget {
  final id;
  const LearnerProfileViewScreen({Key key, this.id}) : super(key: key);

  @override
  _LearnerProfileViewScreenState createState() =>
      _LearnerProfileViewScreenState();
}

class _LearnerProfileViewScreenState extends State<LearnerProfileViewScreen> {
  Map<String, dynamic> map = {};
  bool isLoading = true;
  String authToken;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getUserProfile();
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
        title: Text(
          'Study Buddy',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          height: 50.0.h,
          width: 100.0.w,
          //color: Colors.grey,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Constants.bgColor),
                  ),
                )
              : map['data'] == null || map['data'] == {}
                  ? Center(
                      child: Text(
                        'No Data Found!',
                        style: TextStyle(
                            fontSize: 12.0.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Constants.bgColor),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0.h, horizontal: 4.0.w),
                      child: Column(
                        children: <Widget>[
                          //Profile DP
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              map['data']['profile_image'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          //Name of Learner
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Text(
                              map['data']['name'],
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Constants.bgColor),
                            ),
                          ),
                          //Degree
                          map['data']['last_degree'] == null ? Container() : Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Text(
                              '${map['data']['last_degree']} | ${map['data']['school_name']}',
                              style: TextStyle(
                                  fontSize: 10.0.sp,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                          //Location
                          map['data']['city'] == null ? Container() : Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ImageIcon(
                                  AssetImage('assets/icons/locationPin.png'),
                                  color: Constants.bgColor,
                                  size: 15.0,
                                ),
                                SizedBox(
                                  width: 0.5.w,
                                ),
                                Text(
                                  map['data']['city'] == null ? '' : map['data']['city'],
                                  style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      color: Constants.bgColor),
                                ),
                              ],
                            ),
                          ),



                          // //Social Handle
                          // Padding(
                          //   padding: EdgeInsets.only(top: 2.0.h),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       GestureDetector(
                          //         onTap: () {
                          //           print('Apple!!!');
                          //         },
                          //         child: Container(
                          //             height: 4.0.h,
                          //             width: 8.0.w,
                          //             child: Image.asset(
                          //               'assets/icons/apple.png',
                          //               fit: BoxFit.contain,
                          //             )),
                          //       ),
                          //       SizedBox(
                          //         width: 1.0.w,
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           print('Google!!!');
                          //         },
                          //         child: Container(
                          //             height: 4.0.h,
                          //             width: 8.0.w,
                          //             child: Image.asset(
                          //               'assets/icons/google.png',
                          //               fit: BoxFit.contain,
                          //             )),
                          //       ),
                          //       SizedBox(
                          //         width: 1.0.w,
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           print('Facebook!!!');
                          //         },
                          //         child: Container(
                          //             height: 4.0.h,
                          //             width: 8.0.w,
                          //             child: Image.asset(
                          //               'assets/icons/facebook.png',
                          //               fit: BoxFit.contain,
                          //             )),
                          //       ),
                          //       SizedBox(
                          //         width: 1.0.w,
                          //       ),
                          //       GestureDetector(
                          //         onTap: () {
                          //           print('LinkedIn!!!');
                          //         },
                          //         child: Container(
                          //             height: 4.0.h,
                          //             width: 8.0.w,
                          //             child: Image.asset(
                          //               'assets/icons/linkedin.png',
                          //               fit: BoxFit.contain,
                          //             )),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Future<void> getUserProfile() async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/${widget.id}',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        map = response.data;

        print(map['data']);
        //print(mapData);
        if (map['data'] != null) {
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }
        //print(result.data);
        //return result;
        setState(() {
          isLoading = false;
        });
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }
}
