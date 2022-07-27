import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Learner/Connection_API.dart';
import 'package:being_pupil/Learner/Connection_List_Learner.dart';
import 'package:being_pupil/Model/Config.dart';
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

class SearchForLearnerScreen extends StatefulWidget {
  String? searchIn;
  SearchForLearnerScreen({Key? key, this.searchIn}) : super(key: key);

  @override
  _SearchForLearnerScreenState createState() => _SearchForLearnerScreenState();
}

class _SearchForLearnerScreenState extends State<SearchForLearnerScreen> {
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic>? map;
  List<dynamic>? mapData;
  ScrollController _scrollController = ScrollController();
  ConnectionAPI connect = ConnectionAPI();
  int page = 1;
  int k = 0;
  bool isLoading = false;
  String? registerAs, authToken;

  List<int?> _userId = [];
  List<String?> _profileImage = [];
  List<String?> _name = [];
  List<String?> _lastDegree = [];
  List<String?> _schoolName = [];
  List<String?> _date = [];
  List<String?> _email = [];
  List<String?> _distance = [];
  List<String?> _status = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map<String, dynamic>? actionMap;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
  }

  void _onLoading() async {
    _refreshController.loadComplete();
    _refreshController.loadNoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: Center(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.text = '';
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    hintText: 'Search by name and city...',
                    border: InputBorder.none),
                onChanged: (value) {
                  Future.delayed(Duration(seconds: 2));

                  searchApi(value);

                  setState(() {});
                },
              ),
            ),
          ),
          backgroundColor: Colors.black,
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
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Constants.bgColor),
                ),
              )
            : SmartRefresher(
                controller: _refreshController,
                enablePullDown: false,
                enablePullUp: true,
                footer: ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                  noDataText: 'No More Connection',
                ),
                onLoading: _onLoading,
                child: widget.searchIn == 'R'
                    ? ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0.w, vertical: 1.0.h),
                        shrinkWrap: true,
                        itemCount: _userId.length == 0 ? 0 : _userId.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3.0,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.0.w),
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    getUserProfile(_userId[index]);
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0.0),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              imageUrl: _profileImage[index]!,
                                              width: 40.0,
                                              height: 40.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 35.0.w,
                                              child: Text(
                                                _name[index]!,
                                                style: TextStyle(
                                                    fontSize: 9.0.sp,
                                                    color: Constants.bgColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            Container(
                                              width: 35.0.w,
                                              child: Text(
                                                _lastDegree[index] != null &&
                                                        _schoolName[index] !=
                                                            null
                                                    ? '${_lastDegree[index]} | ${_schoolName[index]}'
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 6.5.sp,
                                                    color: Constants.bgColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w400),
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(right: 2.0.w),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  requestActionApi(
                                                      _userId[index], 'R');
                                                },
                                                child: Container(
                                                  height: 3.5.h,
                                                  width: 16.0.w,
                                                  decoration: BoxDecoration(
                                                      color: Constants.bgColor,
                                                      border: Border.all(
                                                          color:
                                                              Constants.bgColor,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0))),
                                                  child: Center(
                                                    child: Text(
                                                      'Reject',
                                                      style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.0.w,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  requestActionApi(
                                                      _userId[index], 'A');
                                                },
                                                child: Container(
                                                  height: 3.5.h,
                                                  width: 16.0.w,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              Constants.bgColor,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0))),
                                                  child: Center(
                                                    child: Text(
                                                      'Connect',
                                                      style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          color:
                                                              Constants.bgColor,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500),
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
                        })
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0.w, vertical: 1.0.h),
                        shrinkWrap: true,
                        itemCount: _userId.length == 0 ? 0 : _userId.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.0.w),
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    getUserProfile(_userId[index]);
                                  },
                                  child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: _profileImage[index]!,
                                                width: 40.0,
                                                height: 40.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.0.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 45.0.w,
                                                child: Text(
                                                  _name[index]!,
                                                  style: TextStyle(
                                                      fontSize: 9.0.sp,
                                                      color: Constants.bgColor,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Container(
                                                width: 45.0.w,
                                                child: Text(
                                                    _lastDegree[index] !=
                                                                null &&
                                                            _schoolName[
                                                                    index] !=
                                                                null
                                                        ? '${_lastDegree[index]} | ${_schoolName[index]}'
                                                        : '',
                                                    style: TextStyle(
                                                        fontSize: 6.5.sp,
                                                        color:
                                                            Constants.bgColor,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    overflow:
                                                        TextOverflow.clip),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: widget.searchIn == 'C'
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                right: 2.0.w,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: _status[index] == '0'
                                                    ? Container(
                                                        height: 3.5.h,
                                                        width: 25.0.w,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Constants
                                                                    .bgColor,
                                                                width: 0.5),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        8.0))),
                                                        child: Center(
                                                          child: Text(
                                                            'Request Sent',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    8.0.sp,
                                                                color: Constants
                                                                    .bgColor,
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      )
                                                    : GestureDetector(
                                                        child: Container(
                                                          height: 3.5.h,
                                                          width: 16.0.w,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Constants
                                                                      .bgColor,
                                                                  width: 0.5),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8.0))),
                                                          child: Center(
                                                            child: Text(
                                                              'Chat',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  color: Constants
                                                                      .bgColor,
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            )
                                          : widget.searchIn == 'E' ||
                                                  widget.searchIn == 'L'
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    right: 2.0.w,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await connect
                                                          .connectionApi(
                                                              _userId[index],
                                                              authToken!);
                                                    },
                                                    child: Container(
                                                      height: 3.5.h,
                                                      width: 16.0.w,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Constants
                                                                  .bgColor,
                                                              width: 0.5),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                      child: Center(
                                                        child: Text(
                                                          'Connect',
                                                          style: TextStyle(
                                                              fontSize: 8.0.sp,
                                                              color: Constants
                                                                  .bgColor,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()),
                                ),
                              ),
                            ),
                          );
                        }),
              ));
  }

  Future<void> searchApi(String search) async {
    setState(() {
      isLoading = true;
      registerAs = registerAs == 'E' ? 'L' : 'E';
    });
    try {
      Dio dio = Dio();

      var response = await dio.get(
          '${Config.searchUserUrl}?search_in=${widget.searchIn}&search=$search&page=$page&user_type=$registerAs',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map!['data'];

        _userId = [];
        _profileImage = [];
        _name = [];
        _lastDegree = [];
        _schoolName = [];
        _status = [];
        _date = [];
        _distance = [];
        _email = [];
        setState(() {});
        if (mapData!.length > 0) {
          for (int i = 0; i < mapData!.length; i++) {
            _userId.add(mapData![i]['user_id']);
            _profileImage.add(mapData![i]['profile_image']);
            _name.add(mapData![i]['name']);
            _lastDegree.add(mapData![i]['last_degree']);
            _schoolName.add(mapData![i]['school_name']);
            _date.add(mapData![i]['date']);

            if (widget.searchIn == 'C' || widget.searchIn == 'R') {
              _status.add(mapData![i]['status']);
            } else {
              _distance.add(mapData![i]['distance']);
            }
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

  Future<void> searchApiTwo(String search) async {
    setState(() {
      isLoading = true;
    });
    try {
      Dio dio = Dio();

      var response = await dio.get(
          '${Config.searchUserUrl}?search_in=${widget.searchIn}&search=$search',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map!['data'];

        _userId = [];
        _profileImage = [];
        _name = [];
        _lastDegree = [];
        _schoolName = [];
        _date = [];
        _distance = [];
        setState(() {});
        if (mapData!.length > 0) {
          for (int i = 0; i < mapData!.length; i++) {
            _userId.add(mapData![i]['user_id']);
            _profileImage.add(mapData![i]['profile_image']);
            _name.add(mapData![i]['name']);
            _lastDegree.add(mapData![i]['last_degree']);
            _schoolName.add(mapData![i]['school_name']);
            _date.add(mapData![i]['date']);
            _distance.add(mapData![i]['distance']);
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
    } on DioError catch (e, stack) {}
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

  displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog1();
        }));
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
