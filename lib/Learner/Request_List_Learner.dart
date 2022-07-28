import 'package:being_pupil/ConnectyCube/consts.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Request_Model.dart';
import 'package:being_pupil/StudyBuddy/Educator_ProfileView_Screen.dart';
import 'package:being_pupil/StudyBuddy/Learner_ProfileView_Screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class RequestListLearner extends StatefulWidget {
  RequestListLearner({Key? key}) : super(key: key);

  @override
  _RequestListLearnerState createState() => _RequestListLearnerState();
}

class _RequestListLearnerState extends State<RequestListLearner> {
  String? registerAs, authToken;
  int? userId;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int k = 0;

  bool isLoading = true;
  Request request = Request();

  List<int?> _userId = [];
  List<String?> _profileImage = [];
  List<String?> _name = [];
  List<String?> _lastDegree = [];
  List<String?> _schoolName = [];
  List<String?> _status = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Map<String, dynamic>? actionMap;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      userId = preferences.getInt('userId');
    });

    getRequestApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (request.data!.length > 0) {
            page++;
            getRequestApi(page);
          }
        } else {
          page++;
          getRequestApi(page);
        }
      }
    });
  }

  void _onLoading() async {
    _refreshController.loadComplete();
    _refreshController.loadNoData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.bgColor),
            ),
          )
          : _userId.isEmpty
            ? Center(
                child: Text(
                  'No Request Found',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Constants.bgColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500),
                ),
              )
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              noDataText: 'No More Request',
            ),
            onLoading: _onLoading,
            child: ListView.builder(
                controller: _scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                shrinkWrap: true,
                itemCount: _userId.length == 0 ? 0 : _userId.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          title: GestureDetector(
                            onTap: () {
                              getUserProfile(_userId[index]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                        width: 40.0,
                                        height: 40.0,
                                        padding: EdgeInsets.all(70.0),
                                        decoration: BoxDecoration(
                                          color: greyColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Material(
                                        child: Image.asset(
                                          'assets/images/studyBudyBg.png',
                                          width: 40.0,
                                          height: 40.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      imageUrl: _profileImage[index]!,
                                      width: 40.0,
                                      height: 40.0,
                                      fit: BoxFit.cover,
                                    )),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 0.0.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 38.0.w,
                                        child: Text(
                                          _name[index]!,
                                          style: TextStyle(
                                              fontSize: 9.0.sp,
                                              color: Constants.bgColor,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Container(
                                        width: 38.0.w,
                                        child: Text(
                                          _lastDegree[index] != null &&
                                                  _schoolName[index] != null
                                              ? '{_lastDegree[index]} | {_schoolName[index]}'
                                              : '',
                                          style: TextStyle(
                                              fontSize: 6.5.sp,
                                              color: Constants.bgColor,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 2.0.w),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          requestActionApi(_userId[index], 'R');
                                        },
                                        child: Container(
                                          height: 3.5.h,
                                          width: 16.0.w,
                                          decoration: BoxDecoration(
                                              color: Constants.bgColor,
                                              border: Border.all(
                                                  color: Constants.bgColor,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                  fontSize: 8.0.sp,
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          requestActionApi(_userId[index], 'A');
                                        },
                                        child: Container(
                                          height: 3.5.h,
                                          width: 16.0.w,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constants.bgColor,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),
                                          child: Center(
                                            child: Text(
                                              'Connect',
                                              style: TextStyle(
                                                  fontSize: 8.0.sp,
                                                  color: Constants.bgColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
  }

  Future<void> getRequestApi(int page) async {
    try {
      Dio dio = Dio();

      var response = await dio.get(
          '${Config.getRequestUrl}$userId?page=$page&user_type=${registerAs == 'E' ? 'L' : 'E'}');

      if (response.statusCode == 200) {
        request = Request.fromJson(response.data);

        if (request.data!.length > 0) {
          for (int i = 0; i < request.data!.length; i++) {
            _userId.add(request.data![i].userId);
            _profileImage.add(request.data![i].profileImage);
            _name.add(request.data![i].name);
            _lastDegree.add(request.data![i].lastDegree);
            _schoolName.add(request.data![i].schoolName);
            _status.add(request.data![i].status);
          }

          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
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

  Future<void> requestActionApi(int? reqId, String action) async {
    try {
      Dio dio = Dio();

      FormData formData =
          FormData.fromMap({'request_id': reqId, 'action': action});
      var response = await dio.post(Config.requestActionUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        actionMap = response.data;

        if (actionMap!['status'] == true) {
          setState(() {
            isLoading = true;
            page = 1;
            _userId = [];
            _profileImage = [];
            _name = [];
            _lastDegree = [];
            _schoolName = [];
            _status = [];
          });
          getRequestApi(page);
          Fluttertoast.showToast(
              msg: actionMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          if (actionMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: actionMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: actionMap!['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
      } else {}
    } on DioError catch (e, stack) {
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

  Future<void> getUserProfile(id) async {
    Map<String, dynamic>? map = {};
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;

        if (map!['data'] != null) {
          setState(() {});
          map['data']['role'] == 'E'
              ? pushNewScreen(context,
                  screen: EducatorProfileViewScreen(
                    id: id,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino)
              : pushNewScreen(context,
                  screen: LearnerProfileViewScreen(
                    id: id,
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino);
        } else {
          isLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
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
}
