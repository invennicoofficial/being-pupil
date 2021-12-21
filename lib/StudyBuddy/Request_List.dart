import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Request_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Educator_ProfileView_Screen.dart';
import 'Learner_ProfileView_Screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class RequestList extends StatefulWidget {
  RequestList({Key key}) : super(key: key);

  @override
  _RequestListState createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  String registerAs, authToken;
  int userId;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int k = 0;

  bool isLoading = true;
  Request request = Request();

  List<int> _userId = [];
  List<String> _profileImage = [];
  List<String> _name = [];
  List<String> _lastDegree = [];
  List<String> _schoolName = [];
  List<String> _status = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Map<String, dynamic> actionMap;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      userId = preferences.getInt('userId');
    });
    print('ID::::::' + userId.toString());
    getRequestApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (request.data.length > 0) {
            page++;
            getRequestApi(page);
            print(_name);
            print(page);
          }
        } else {
          page++;
          getRequestApi(page);
          print(_name);
          print(page);
        }
      }
    });
  }

  void _onLoading() async {
    //if (mounted) setState(() {});
    // if (request.data.length > 0) {
    //   //_refreshController.loadComplete();
    //   _refreshController.requestLoading();
    // } else {
    _refreshController.loadComplete();
    _refreshController.loadNoData();
    //}
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.bgColor),
            ),
          )
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              noDataText: 'No More Request',
              //noMoreIcon: Icon(Icons.refresh_outlined),
            ),
            onLoading: _onLoading,
            //   SingleChildScrollView(
            // controller: _scrollController,
            //physics: BouncingScrollPhysics(),
            child: ListView.builder(
                controller: _scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 2.0.h),
                //physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _userId.length == 0 ? 0 : _userId.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Container(
                        height: 10.0.h,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          //leading:
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  getUserProfile(_userId[index]);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    _profileImage[index],
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: 2.0.w,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.0.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _name[index],
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      //color: Colors.grey,
                                      width: 25.0.w,
                                      child: Text(
                                        _lastDegree[index] != null &&
                                                _schoolName[index] != null
                                            ? '${_lastDegree[index]} | ${_schoolName[index]}'
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

                              //Buttons
                              Padding(
                                padding: EdgeInsets.only(right: 2.0.w),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('$index is Rejected');
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
                                        print('$index is Connected');
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
                  );
                }),
          );
  }

  //Get request List API
  Future<void> getRequestApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getRequestUrl}$userId?page=$page&user_type=$registerAs');
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.data);
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        request = Request.fromJson(response.data);

        print('LENGTH: ' + request.data.length.toString());
        if (request.data.length > 0) {
          for (int i = 0; i < request.data.length; i++) {
            _userId.add(request.data[i].userId);
            _profileImage.add(request.data[i].profileImage);
            _name.add(request.data[i].name);
            _lastDegree.add(request.data[i].lastDegree);
            _schoolName.add(request.data[i].schoolName);
            _status.add(request.data[i].status);
            // isSaved.add(true);
            // for (int j = 0; j < map['data'].length; j++) {
            //   imageListMap.putIfAbsent(k, () => map['data'][i]['post_media']);
            //   k++;
            // print(k);
          }
          // k++;
          // print(k);
          print(_profileImage);
          print(_lastDegree);
          print(_schoolName);

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
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }

  Future<void> requestActionApi(int reqId, String action) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData =
          FormData.fromMap({'request_id': reqId, 'action': action});
      var response = await dio.post(Config.requestActionUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        actionMap = response.data;
        //saveMapData = map['data']['status'];

        print(actionMap);
        // setState(() {
        //   isLoading = false;
        // });
        if (actionMap['status'] == true) {
          print('true');
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
              msg: actionMap['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
          if (actionMap['message'] == null) {
            Fluttertoast.showToast(
                msg: actionMap['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: actionMap['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
        //getEducatorPostApi(page);
        //print(saveMap);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }

  Future<void> getUserProfile(id) async {
    // displayProgressDialog(context);

    Map<String, dynamic> map = {};
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        map = response.data;

        print(map['data']);
        //print(mapData);
        if (map['data'] != null) {
          setState(() {});
          map['data']['role'] == 'E'
              ? pushNewScreen(context,
              screen: EducatorProfileViewScreen(id: id,),
              withNavBar: false,
              pageTransitionAnimation:
              PageTransitionAnimation.cupertino)
              :
          pushNewScreen(context,
              screen: LearnerProfileViewScreen(id: id,),
              withNavBar: false,
              pageTransitionAnimation:
              PageTransitionAnimation
                  .cupertino);
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
