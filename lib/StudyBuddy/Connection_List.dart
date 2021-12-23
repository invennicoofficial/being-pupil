import 'package:being_pupil/ConnectyCube/chat_dialog_screen.dart';
import 'package:being_pupil/ConnectyCube/consts.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Connection_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Educator_ProfileView_Screen.dart';
import 'Learner_ProfileView_Screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class ConnectionList extends StatefulWidget {
  ConnectionList({Key? key}) : super(key: key);

  @override
  _ConnectionListState createState() => _ConnectionListState();
}

class _ConnectionListState extends State<ConnectionList> {
  String? registerAs, authToken;
  int? userId;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int k = 0;

  bool isLoading = true;
  Connection connection = Connection();

  List<int?> _userId = [];
  List<String?> _profileImage = [];
  List<String?> _name = [];
  List<String?> _email = [];
  List<String?> _lastDegree = [];
  List<String?> _schoolName = [];
  List<String?> _status = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
    getConnectionApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (connection.data!.length > 0) {
            page++;
            getConnectionApi(page);
            print(_name);
            print(page);
          }
        } else {
          page++;
          getConnectionApi(page);
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
            SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              noDataText: 'No More Connection',
              //noMoreIcon: Icon(Icons.refresh_outlined),
            ),
            onLoading: _onLoading,
            child: ListView.builder(
              controller: _scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
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
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    getUserProfile(_userId[index]);
                                  },
                                  child: ClipRRect(
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
                                        fit: BoxFit.fitWidth,
                                      )
                                  ),
                                ),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _name[index]!,
                                      //connection.data[index].name,
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      width: 45.0.w,
                                      //color: Colors.grey,
                                      child: Text(
                                        _lastDegree[index] != null &&
                                                _schoolName[index] != null
                                            ? '${_lastDegree[index]} | ${_schoolName[index]}'
                                            : '',
                                        // connection.data[index].lastDegree != null && connection.data[index].schoolName != null
                                        // ? "${connection.data[index].lastDegree} | ${connection.data[index].schoolName}" : '',
                                        style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Constants.bgColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.clip
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 2.0.w, top: 2.0.h),
                              child: GestureDetector(
                                onTap: () {
                                  print('$index is Connected');
                                },
                                child: _status[index] == '0'
                                    //connection.data[index].status == '0'
                                    ? Container(
                                        height: 3.5.h,
                                        width: 25.0.w,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Constants.bgColor,
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            'Request Sent',
                                            style: TextStyle(
                                                fontSize: 8.0.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                  onTap: () async {
                                    displayProgressDialog(context);
                                    SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
                                    CubeUser? user = sharedPrefs.getUser();
                                    print(_email[index]);
                                    getUserByEmail(_email[index]!)
                                        .then((cubeUser) {
                                          CubeDialog newDialog = CubeDialog(
                                        CubeDialogType.PRIVATE,
                                        occupantsIds: [cubeUser!.id!]);
                                    createDialog(newDialog)
                                        .then((createdDialog) {
                                      closeProgressDialog(context);
                                      pushNewScreen(context,
                                          screen: ChatDialogScreen(user, createdDialog, _profileImage[index]),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                          PageTransitionAnimation
                                              .cupertino);
                                    })
                                        .catchError((error) {
                                      displayProgressDialog(context);
                                    });
                                    })
                                        .catchError((error) {
                                      displayProgressDialog(context);
                                    });

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
                                              'Chat',
                                              style: TextStyle(
                                                  fontSize: 8.0.sp,
                                                  color: Constants.bgColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                    ),
                              ),
                            )),
                      ),
                    ),
                  );
                }),
          );
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
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
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

  //Get Connection List API
  Future<void> getConnectionApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response =
          await dio.get('${Config.getConnectionUrl}$userId?page=$page&user_type=$registerAs');
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        connection = Connection.fromJson(response.data);
        print(response.data);
        if (connection.data!.length > 0) {
          for (int i = 0; i < connection.data!.length; i++) {
            _userId.add(connection.data![i].userId);
            _profileImage.add(connection.data![i].profileImage);
            _name.add(connection.data![i].name);
            _email.add(connection.data![i].email);
            _lastDegree.add(connection.data![i].lastDegree);
            _schoolName.add(connection.data![i].schoolName);
            _status.add(connection.data![i].status);
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
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }
}


class ProgressDialog1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          color: Constants.bgColor,
            border: Border.all(
                color: Constants.bgColor, width: 0.5),
            borderRadius: BorderRadius.all(
                Radius.circular(8.0))),
        child: new GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(Constants.selectedIcon),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}