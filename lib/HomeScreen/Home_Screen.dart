import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/ConnectyCube/select_dialog_screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen_From_Link.dart';
import 'package:being_pupil/HomeScreen/Create_Post_Screen.dart';
import 'package:being_pupil/HomeScreen/Fulll_Screen_Image_Screen.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Device_Token_Model.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'package:being_pupil/StayAndStudy/Property_Details_Screen.dart';
import 'package:being_pupil/StudyBuddy/Educator_ProfileView_Screen.dart';
import 'package:being_pupil/Widgets/Post_Widget.dart';
import 'package:being_pupil/Widgets/Shimmer_Widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Comment_Screen.dart';
import 'Report_Feed.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class EducatorHomeScreen extends StatefulWidget {
  EducatorHomeScreen({Key? key}) : super(key: key);

  @override
  _EducatorHomeScreenState createState() => _EducatorHomeScreenState();
}

class _EducatorHomeScreenState extends State<EducatorHomeScreen> {
  List<bool?> isLiked = [];
  List<bool?> isSaved = [];

  Map<String, dynamic>? map;
  List<dynamic>? mapData;

  String name = '';
  String profileImageUrl = '';
  String degreeName = '';
  String schoolName = '';

  int page = 1;

  bool isLoading = true;
  bool isPostLoading = true;

  ScrollController _scrollController = ScrollController();
  int k = 0;

  List<int?> postIdList = [];
  List<int?> userIdList = [];
  List<String?> dateList = [];
  List<String?> nameList = [];
  List<String?> profileImageList = [];
  List<String?> degreeList = [];
  List<String?> schoolList = [];
  List<String?> cityList = [];
  List<String?> durationList = [];
  List<String?> descriptionList = [];
  List<String?> commentTextList = [];
  List<String?> mutualList = [];
  List<String?> commentProfile = [];
  Map<int, dynamic> imageListMap = {};
  List<int?> likesList = [];
  List<int?> totalCommentsList = [];

  String? authToken, registerAs;
  Map<String, dynamic>? saveMap;
  Map<String, dynamic>? refreshTokenMap;
  LikePostAPI like = LikePostAPI();
  static const String TAG = "_LoginPageState";
  CubeUser? user;
  CubeSession? session;
  String? ccToken;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int? commentResult;
  Map<String, dynamic> resultComment = {};

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  GetAllProperty propertyDetails = GetAllProperty();
  Map<String, dynamic>? propMap;
  Map<String, dynamic> postMap = {};
  List<dynamic> propDataList = [];

  List<int> _current = [];
  final CarouselController _controller = CarouselController();
  List<List<String>> imageList = [];
  List<String> list = [];
  String? _linkMessage;
  bool _isCreatingLink = false;
  var dLink = CreateDynamicLink();

  @override
  void initState() {
    getToken();
    initDynamicLinks();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    getData();
    generateFirebaseToken();
  }

  generateFirebaseToken() async {
    _firebaseMessaging.requestPermission(sound: true, alert: true, badge: true);

    _firebaseMessaging.getToken().then((token) {
      var firebaseToken = token!;

      saveFirebaseToken(token);
      setState(() {});
      deviceTokenAPi(token);
    });
  }

  saveFirebaseToken(String token) async {
    final storage = new FlutterSecureStorage();

    await storage.write(key: 'firebaseToken', value: token);
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });

    SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
    user = sharedPrefs.getUser();

    if (user != null) {
      user!.password = '12345678';
      createSession(user).then((cubeSession) {
        preferences.setString('ccToken', cubeSession.token!);

        signIn(user!).then((cubeUser) async {
          _loginToCubeChat(context, user!);
        }).catchError((error) {});
      }).catchError((error) {});
    }
    getAllPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map!['data'].length > 0) {
            page++;
            getAllPostApi(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getAllPostApi(page);
        }
      }
    });
  }

  void _onRefresh() async {
    setState(() {
      isLoading = true;
      page = 1;
      map!.clear();
      map = {};
      mapData = [];
      postIdList = [];
      userIdList = [];
      dateList = [];
      descriptionList = [];
      commentTextList = [];
      mutualList = [];

      likesList = [];
      totalCommentsList = [];
      nameList = [];
      profileImageList = [];
      cityList = [];
      durationList = [];
      commentProfile = [];
      degreeList = [];
      schoolList = [];
      isSaved = [];
      isLiked = [];
      imageListMap = {};
      k = 0;
      list = [];
      imageList = [];
      _current = [];
    });
    getAllPostApi(page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (map!['data'].length == 0) {
      _refreshController.loadNoData();
    } else {
      _refreshController.requestLoading();
    }
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {

      if (deepLink.toString().contains('/post')) {
        getPostById(deepLink.toString());
      } else {
        getPropertyAPI(
            deepLink.toString().substring(0, deepLink.toString().length - 2));
      }
    }
    dynamicLinks.onLink.listen((dynamicLinkData) {
      if (dynamicLinkData.link.toString().contains('/post')) {
        getPostById(dynamicLinkData.link.toString());
      } else {
        getPropertyAPI(dynamicLinkData.link
            .toString()
            .substring(0, dynamicLinkData.link.toString().length - 3));
      }
    }).onError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Constants.bgColor,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5.0.w),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.message_outlined),
                  onPressed: () {
                    pushNewScreen(context,
                        screen: SelectDialogScreen(user!),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  },
                ),
                registerAs == 'E'
                    ? IconButton(
                        icon: Icon(Icons.add_box_outlined),
                        onPressed: () {
                          pushNewScreen(context,
                              screen: CreatePostScreen(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                      )
                    : Container()
              ],
            ),
          )
        ],
        title: Container(
            height: 8.0.h,
            width: 30.0.w,
            child: Image.asset('assets/images/beingPupil.png',
                fit: BoxFit.contain)),
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
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: postIdList != null ? postIdList.length : 0,
                itemBuilder: (context, index) {
                  final tagName = mutualList[index];
                  final split = tagName.toString().split(',');
                  final Map<int, String> values = {
                    for (int i = 0; i < split.length; i++) i: split[i]
                  };
                  return PostWidget(
                    isCommentScreen: false,
                    commentImage: commentProfile[index],
                    postId: postIdList[index]!,
                    profileTap: () {
                      getUserProfile(userIdList[index]);
                    },
                    profileImage: profileImageList[index]!,
                    profileName: nameList[index]!,
                    profileSchool: cityList[index]!,
                    postTime: durationList[index]!,
                    reportTap: IconButton(
                      icon: Icon(
                        Icons.more_horiz_outlined,
                        color: Color(0xFF828282),
                      ),
                      onPressed: () async {
                        var result = await pushNewScreen(context,
                            withNavBar: false,
                            screen: ReportFeed(
                              postId: postIdList[index],
                            ),
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                        if (result == true) {
                          _onRefresh();
                        }
                      },
                    ),
                    description: descriptionList[index]!,
                    imageListView: imageListMap[index].length != 0
                        ? Container(
                            height: 25.0.h,
                            width: 100.0.w,
                            child: CarouselSlider.builder(
                                carouselController: _controller,
                                itemCount: imageListMap[index].length,
                                itemBuilder: (context, imageIndex, rindex) {
                                  return GestureDetector(
                                      onTap: () {
                                        List<String> imgList = [];
                                        for (int i = 0;
                                            i < imageListMap[index].length;
                                            i++) {
                                          imgList.add(
                                              imageListMap[index][i]['file']);
                                        }
                                        pushNewScreen(context,
                                            withNavBar: false,
                                            screen: FullScreenSlider(
                                                imageList: imgList,
                                                index: imageIndex,
                                                name: nameList[index]!),
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino);
                                      },
                                      child: CachedNetworkImage(
                                          imageUrl: imageListMap[index]
                                              [imageIndex]['file'],
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/images/404.gif',
                                                  fit: BoxFit.fitHeight,
                                                  width: 100.0.w),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                                    width: 100.0.w,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                    ),
                                                  ),
                                          placeholder: (context, url) =>
                                              PhotoLoadingWidget()));
                                },
                                options: CarouselOptions(
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1.0,
                                    onPageChanged: (cindex, reason) {
                                      setState(() {
                                        _current[index] = cindex;
                                      });
                                    })))
                        : Container(),
                    indicator: imageListMap[index].length != 0
                        ? Center(
                            child: imageListMap[index].length != 1
                                ? SizedBox(
                                    height: 18,
                                    child: ListView.builder(
                                        itemCount: imageListMap[index].length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, iIndex) {
                                          return Container(
                                            width: 15.0,
                                            height: 15.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .withOpacity(
                                                        _current[index] ==
                                                                iIndex
                                                            ? 0.9
                                                            : 0.3)),
                                          );
                                        }),
                                  )
                                : SizedBox(),
                          )
                        : Row(),
                    mutualLike: likesList[index]! - values.length,
                    mutualFriend: mutualList[index],
                    likeTap: () {
                      setState(() {
                        isLiked[index] = !isLiked[index]!;
                      });
                      like.likePostApi(postIdList[index], authToken!);
                      setState(() {
                        isLiked[index] == true
                            ? likesList[index] = likesList[index]! + 1
                            : likesList[index] = likesList[index]! - 1;
                      });
                    },
                    isLiked: isLiked[index]!,
                    totalLike: likesList[index].toString(),
                    commentTap: () async {
                      resultComment =
                          await Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                        postId: postIdList[index],
                                        userId: userIdList[index],
                                        name: nameList[index],
                                        profileImage: profileImageList[index],
                                        degree: cityList[index],
                                        schoolName: schoolList[index],
                                        date: durationList[index],
                                        description: descriptionList[index],
                                        like: likesList[index],
                                        comment: totalCommentsList[index],
                                        isLiked: isLiked[index],
                                        isSaved: isSaved[index],
                                        imageListMap: imageListMap,
                                        index: index,
                                        mutual: mutualList[index],
                                        otherCount:
                                            likesList[index]! - values.length,
                                      )));

                      setState(() {});

                      totalCommentsList[resultComment['index']] =
                          resultComment['count'];
                      likesList[resultComment['index']] =
                          resultComment['likeCount'];
                      isSaved[resultComment['index']] =
                          resultComment['isSaved'];
                      isLiked[resultComment['index']] =
                          resultComment['isLiked'];
                      setState(() {});
                    },
                    totalComments: totalCommentsList[index].toString(),
                    saveTap: () {
                      setState(() {
                        isSaved[index] = !isSaved[index]!;
                      });
                      savePostApi(postIdList[index]);
                    },
                    isSaved: isSaved[index]!,
                    shareTap: () async {
                      await dLink.createDynamicLink(
                        true,
                        postIdList[index].toString(),
                        index,
                        nameList[index]!,
                        descriptionList[index]!,
                        imageListMap[index].isEmpty
                            ? ''
                            : imageListMap[index][0]['file'].toString(),
                      );
                    },
                    iscomment: commentTextList[index] != null ? true : false,
                    commentText: commentTextList[index] != null
                        ? commentTextList[index]!
                        : '',
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 5.0,
                    color: Color(0xFFD3D9E0),
                  );
                },
              ),
            ),
    );
  }

  _loginToCubeChat(BuildContext context, CubeUser user) {
    user.password = '12345678';

    CubeChatConnectionSettings.instance.totalReconnections = 0;
    CubeChatConnection.instance
        .login(user)
        .then((cubeUser) {})
        .catchError((error) {
      _processLoginError(error);
    });
  }

  void _processLoginError(exception) {
    //log("Login error $exception", TAG);
    setState(() {});
    showDialogError(exception, context);
  }

  Future<void> getAllPostApi(int page) async {
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getAllPostUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer $authToken'}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map!['data'];

        if (map!['data'].length > 0) {
          for (int i = 0; i < map!['data'].length; i++) {
            _current.add(0);
            nameList.add(map!['data'][i]['name']);
            profileImageList.add(map!['data'][i]['profile_image']);
            cityList.add(map!['data'][i]['city']);
            durationList.add(map!['data'][i]['duration']);
            degreeList.add(map!['data'][i]['last_degree']);
            schoolList.add(map!['data'][i]['school_name']);
            postIdList.add(map!['data'][i]['post_id']);
            userIdList.add(map!['data'][i]['post_user_id']);
            dateList.add(map!['data'][i]['date']);
            descriptionList.add(map!['data'][i]['description']);
            isLiked.add(map!['data'][i]['isLiked']);
            isSaved.add(map!['data'][i]['isSaved']);
            likesList.add(map!['data'][i]['total_likes']);
            totalCommentsList.add(map!['data'][i]['total_comments']);
            commentTextList.add(map!['data'][i]['comment']);
            mutualList.add(map!['data'][i]['mutual']);
            commentProfile.add(map!['data'][i]['commenter_profile']);
            for (int j = 0; j < map!['data'].length; j++) {
              imageListMap.putIfAbsent(k, () => map!['data'][i]['post_media']);
            }
            k++;
          }

          isLoading = false;
          isPostLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          isPostLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
          isPostLoading = false;
        });

        if (map!['status'] == true) {
        } else if (map!['status'] == false && map!['error_code'] == 'ERR302') {
          refreshToken();
        }
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {}
  }

  void saveToken(String token) async {
    await storage.FlutterSecureStorage()
        .write(key: 'access_token', value: token);
    setState(() {
      authToken = token;
    });
    getAllPostApi(0);
  }

  Future<void> refreshToken() async {
    try {
      Dio dio = Dio();
      var response = await dio.get(Config.refreshTokenUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        refreshTokenMap = response.data;
        if (refreshTokenMap!.length > 1) {
          saveToken(refreshTokenMap!['access_token']);
        }
      } else {}
    } on DioError catch (e, stack) {}
  }

  Future<void> savePostApi(int? postID) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.savePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        saveMap = response.data;

        if (saveMap!['status'] == true) {
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          if (saveMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: saveMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: saveMap!['message'],
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

        if (map!['data'] != null || map['data'] != []) {
          setState(() {});

          pushNewScreen(context,
              screen: EducatorProfileViewScreen(
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

  Future<void> deviceTokenAPi(String token) async {
    var result = DeviceToken();

    try {
      var dio = Dio();
      FormData formData =
          FormData.fromMap({"deviceToken": token, "deviceType": 'A'});

      var response = await dio.post(Config.deviceTokenUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        result = DeviceToken.fromJson(response.data);

        if (result.status == true) {
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        }
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

  getPropertyAPI(String url) async {
    isLoading = true;
    propDataList.clear();
    setState(() {});
    try {
      var dio = Dio();
      var response = await dio.get(url,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        propMap = response.data;
        propDataList.add(propMap!['data'][0]);

        if (propMap!['status'] == true) {
          isLoading = false;
          setState(() {});

          pushNewScreen(context,
              screen: PropertyDetailScreen(
                  propertyDetails: propertyDetails,
                  propData: propDataList,
                  index: 0),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    } on DioError catch (e, stack) {
      isLoading = false;
      setState(() {});

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
      } else {}
    }
  }

  getPostById(String url) async {
    List<String> imageListMap1 = [];
    isLoading = true;
    propDataList.clear();
    setState(() {});
    try {
      var dio = Dio();
      var response = await dio.get(url,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        postMap = response.data;

        if (postMap['status'] == true) {
          isLoading = false;
          setState(() {});

          for (int j = 0; j < postMap['data']['post_media'].length; j++) {
            imageListMap1.add(postMap['data']['post_media'][j]['file']);
          }


          final tagName = postMap['data']['mutual'];
          final split = tagName.toString().split(',');
          final Map<int, String> values = {
            for (int i = 0; i < split.length; i++) i: split[i]
          };

          resultComment = await Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(
                  builder: (context) => CommentScreenFromLink(
                        postId: postMap['data']['post_id'],
                        userId: postMap['data']['post_user_id'],
                        name: postMap['data']['name'],
                        profileImage: postMap['data']['profile_image'],
                        degree: postMap['data']['city'],
                        schoolName: postMap['data']['school_name'],
                        date: postMap['data']['duration'],
                        description: postMap['data']['description'],
                        comment: postMap['data']['total_comments'],
                        like: postMap['data']['total_likes'],
                        isLiked: postMap['data']['isLiked'],
                        isSaved: postMap['data']['isSaved'],
                        imageListMap: imageListMap1,
                        index: 0,
                        mutual: postMap['data']['mutual'],
                        otherCount:
                            postMap['data']['total_likes']! - values.length,
                      )));

          setState(() {});

          totalCommentsList[resultComment['index']] = resultComment['count'];
          likesList[resultComment['index']] = resultComment['likeCount'];
          isSaved[resultComment['index']] = resultComment['isSaved'];
          isLiked[resultComment['index']] = resultComment['isLiked'];
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    } on DioError catch (e, stack) {
      isLoading = false;
      setState(() {});
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
      } else {}
    }
  }
}
