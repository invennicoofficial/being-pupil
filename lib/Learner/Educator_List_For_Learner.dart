import 'package:being_pupil/ConnectyCube/consts.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Learner/Connection_API.dart';
import 'package:being_pupil/Learner/Subject_Selection.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Educator_List_Model.dart';
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

class EducatorListForLearner extends StatefulWidget {
  EducatorListForLearner({Key? key}) : super(key: key);

  @override
  _EducatorListForLearnerState createState() => _EducatorListForLearnerState();
}

class _EducatorListForLearnerState extends State<EducatorListForLearner> {
  String? registerAs, authToken;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int k = 0;

  bool isLoading = true;
  EducatorListModel educator = EducatorListModel();
  ConnectionAPI connect = ConnectionAPI();

  List<int?> _userId = [];
  List<String?> _profileImage = [];
  List<String?> _name = [];
  List<String?> _lastDegree = [];
  List<String?> _schoolName = [];
  List<String?> _date = [];
  List<String?> _distance = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String? result;
  Map<String, dynamic>? selectedSubjectMap = Map<String, dynamic>();
  List<dynamic> selectedSubjectMapData = [];
  bool isSubjectSelected = false;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getData();
    getSelectedSubjectListForLearner();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    getEducatorListApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (educator.data!.length > 0) {
            page++;
            getEducatorListApi(page);
            print(_name);
            print(page);
          }
        } else {
          page++;
          getEducatorListApi(page);
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
        :
        // SingleChildScrollView(
        //     controller: _scrollController,
        //     physics: BouncingScrollPhysics(),
        //     child:
        Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing preference results',
                      style: TextStyle(
                          fontSize: 9.0.sp,
                          color: Constants.bpOnBoardSubtitleStyle,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () async {
                        result = await Navigator.of(context,
                                rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => SubjectSelectionScreen(
                                    //isSubjectSelected: isSubjectSelected,
                                    )));

                        setState(() {});
                        print("STATUS::: $result");
                        if (result == 'true') {
                          getEducatorListApi(0);
                        }
                        //                     pushNewScreen(context, screen: SubjectSelectionScreen(), withNavBar: false,
                        //  pageTransitionAnimation: PageTransitionAnimation.cupertino);
                      },
                      child: Container(
                        height: 2.5.h,
                        width: 15.0.w,
                        //color: Colors.grey,
                        child: Center(
                          child: Text(
                            'Change',
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                color: Constants.bgColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: ClassicFooter(
                    loadStyle: LoadStyle.ShowWhenLoading,
                    noDataText: 'No More Educators',
                    //noMoreIcon: Icon(Icons.refresh_outlined),
                  ),
                  onLoading: _onLoading,
                  child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.0.w, vertical: 1.0.h),
                      //physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _userId.length == 0 ? 0 : _userId.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0.w),
                            child: Container(
                              //height: 10.0.h,
                              child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: GestureDetector(
                                    onTap: () {
                                      getUserProfile(_userId[index]);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Container(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.black),
                                                ),
                                                width: 40.0,
                                                height: 40.0,
                                                padding: EdgeInsets.all(70.0),
                                                decoration: BoxDecoration(
                                                  color: greyColor2,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 52.0.w,
                                              //color: Colors.grey,
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
                                              width: 52.0.w,
                                              //color: Colors.grey,
                                              child: Text(
                                                  '${_lastDegree[index]} | ${_schoolName[index]}',
                                                  style: TextStyle(
                                                      fontSize: 6.5.sp,
                                                      color: Constants.bgColor,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  overflow: TextOverflow.clip),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: EdgeInsets.only(
                                        right: 2.0.w, top: 0.0.h),
                                    child: GestureDetector(
                                      onTap: () async {
                                        print('$index is Connected');
                                        await connect.connectionApi(
                                            _userId[index], authToken!);
                                        setState(() {
                                          isLoading = true;
                                          page = 1;
                                          _userId = [];
                                          _profileImage = [];
                                          _name = [];
                                          _lastDegree = [];
                                          _schoolName = [];
                                          _date = [];
                                          _distance = [];
                                        });
                                        getEducatorListApi(page);
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
                                  )),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          );
  }

  //Get Educator List API
  Future<void> getEducatorListApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getEducatorListUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        educator = EducatorListModel.fromJson(response.data);

        if (educator.data!.length > 0) {
          for (int i = 0; i < educator.data!.length; i++) {
            _userId.add(educator.data![i].userId);
            _profileImage.add(educator.data![i].profileImage);
            _name.add(educator.data![i].name);
            _lastDegree.add(educator.data![i].lastDegree);
            _schoolName.add(educator.data![i].schoolName);
            _date.add(educator.data![i].date);
            _distance.add(educator.data![i].distance);
          }

          print(_name);

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
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }

  Future<void> getUserProfile(id) async {
    // displayProgressDialog(context);

    Map<String, dynamic>? map = {};
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        map = response.data;

        print(map!['data']);
        //print(mapData);
        if (map['data'] != null || map['data'] != []) {
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
        //print(result.data);
        //return result;
        setState(() {
          isLoading = false;
        });
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }

  //get Selected Subject API
  getSelectedSubjectListForLearner() async {
    //displayProgressDialog(context);
    //var result = CategoryList();

    try {
      Dio dio = Dio();
      var option = Options(headers: {"Authorization": 'Bearer ' + authToken!});
      var response =
          await dio.get(Config.getSelectedSubjectUrl, options: option);

      if (response.statusCode == 200) {
        //closeProgressDialog(context);
        selectedSubjectMap = response.data;
        debugPrint('SELECTED:::' + selectedSubjectMap.toString());
        if (selectedSubjectMap!['status'] == true) {
          // setState(() {
          //   selectedSubjectMapData = selectedSubjectMap!['data'];
          // });
          if (selectedSubjectMap!['data'].isEmpty ||
              selectedSubjectMap!['data'] == []) {
            setState(() {
              isSubjectSelected = false;
            });
            pushNewScreen(context,
                screen: SubjectSelectionScreen(
                    //isSubjectSelected: isSubjectSelected
                    ),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (context) => SubjectSelectionScreen(
            //             isSubjectSelected: isSubjectSelected)),
            //     (Route<dynamic> route) => false);
          } else {
            setState(() {
              isSubjectSelected = true;
            });
          }

          //closeProgressDialog(context);
        }
        // else {
        //   Fluttertoast.showToast(
        //     msg: selectedSubjectMap!['error_msg'],
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Constants.bgColor,
        //     textColor: Colors.white,
        //     fontSize: 10.0.sp,
        //   );
        // }
      } else {
        //closeProgressDialog(context);
        if (selectedSubjectMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: selectedSubjectMap!['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      //closeProgressDialog(context);
      if (e.response != null) {
        print(e.message);
        print(stack);
      }
    }
  }
}
