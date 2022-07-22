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
  //List<dynamic>? mapData;
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
    //print(authToken);
    getData();
    generateFirebaseToken();
  }

  //Generate firebase token
  generateFirebaseToken() async {
    _firebaseMessaging.requestPermission(sound: true, alert: true, badge: true);
    //FirebaseMessaging.onMessage.listen((remoteMessage) {
    //   log('[onMessage] message: $remoteMessage');
    //showNotification(remoteMessage);
    //});
    _firebaseMessaging.getToken().then((token) {
      var firebaseToken = token!;
      //print('token::: ' + token);
      saveFirebaseToken(token);
      setState(() {});
      deviceTokenAPi(token);
    });
  }

  saveFirebaseToken(String token) async {
    // Create storage
    final storage = new FlutterSecureStorage();

    // Write value
    await storage.write(key: 'firebaseToken', value: token);
  }

  // getAllImagesList(){
  //   for(int i = 0; i < )
  //   for (int i = 0; i < imageListMap[index].length; i++) {
  //    imgList.add(imageListMap[index][i]['file']);
  //    }
  // }

//   pushNotificationOnMsg() async{
//     FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
// String? token;
// if (Platform.isAndroid || kIsWeb) {
//     token = (await firebaseMessaging.getToken())!;
// } else if (Platform.isIOS || Platform.isMacOS) {
//     token = (await firebaseMessaging.getAPNSToken())!;
// }

// if (!isEmpty(token)) {
//     subscribe(token!);
// }

// firebaseMessaging.onTokenRefresh.listen((newToken) {
//     subscribe(newToken);
// });
//   }

//   subscribe(String token) async {
//     log('[subscribe] token: $token');

//     bool isProduction = bool.fromEnvironment('dart.vm.product');

//     CreateSubscriptionParameters parameters = CreateSubscriptionParameters();
//     parameters.environment =
//         isProduction ? CubeEnvironment.PRODUCTION : CubeEnvironment.DEVELOPMENT;

//     if (Platform.isAndroid) {
//       parameters.channel = NotificationsChannels.GCM;
//       parameters.platform = CubePlatform.ANDROID;
//       parameters.bundleIdentifier = "com.connectycube.flutter.chat_sample";
//     } else if (Platform.isIOS) {
//       parameters.channel = NotificationsChannels.APNS;
//       parameters.platform = CubePlatform.IOS;
//       parameters.bundleIdentifier = Platform.isIOS
//           ? "com.connectycube.flutter.chatSample.app"
//           : "com.connectycube.flutter.chatSample.macOS";
//     }

//     String deviceId = await DeviceId.getID;
//     parameters.udid = deviceId;
//     parameters.pushToken = token;

//     createSubscription(parameters.getRequestParameters())
//         .then((cubeSubscription) {})
//         .catchError((error) {});
// }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    //print('RoLE::::::' + registerAs.toString());
    SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
    user = sharedPrefs.getUser();

    if (user != null) {
      user!.password = '12345678';
      createSession(user).then((cubeSession) {
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
            //print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getAllPostApi(page);
          //print(page);
        }
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
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
      //imageListMap.removeWhere((key, value) => key == index);
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
    //if (mounted) setState(() {});
    if (map!['data'].length == 0) {
      //_refreshController.loadComplete();
      _refreshController.loadNoData();
    } else {
      _refreshController.requestLoading();
    }
  }

  //init dynamic link
  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print('DL:::::::$deepLink');
      // ignore: unawaited_futures
      //Future.delayed(const Duration(milliseconds: 1000), () {
      if (deepLink.toString().contains('/post')) {
        getPostById(deepLink.toString());
      } else {
        getPropertyAPI(deepLink.toString().substring(0, 51));
      }
      //setState(() {});
      //});
      //Navigator.pushNamed(context, deepLink.path);
    }
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print('DL:::' + dynamicLinkData.link.toString());
      if (dynamicLinkData.link.toString().contains('/post')) {
        getPostById(dynamicLinkData.link.toString());
      } else {
        getPropertyAPI(dynamicLinkData.link.toString().substring(0, 51));
      }
      //Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      //print('onLink error');
      //print(error.message);
    });
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
          :
          // SingleChildScrollView(
          //     controller: _scrollController,
          //     physics: BouncingScrollPhysics(),
          //     child:
          SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),

              //  footer:
              // CustomFooter(
              //   builder: (BuildContext context, LoadStatus mode) {
              //     Widget body;
              //     if (mode == LoadStatus.idle) {
              //       body = Text("pull up load");
              //     } else if (mode == LoadStatus.loading) {
              //       body = CupertinoActivityIndicator();
              //     } else if (mode == LoadStatus.failed) {
              //       body = Text("Load Failed!Click retry!");
              //     } else if (mode == LoadStatus.canLoading) {
              //       body = Text("release to load more");
              //     } else {
              //       body = Text("No more Data");
              //     }
              //     return Container(
              //       height: 55.0,
              //       child: Center(child: body),
              //     );
              //   },
              // ),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.separated(
                controller: _scrollController,
                //physics: BouncingScrollPhysics(),
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
                      print('ID:::' + userIdList[index].toString());
                      getUserProfile(userIdList[index]);
                    },
                    profileImage: profileImageList[index]!,
                    profileName: nameList[index]!,
                    profileSchool: cityList[index]!,
                    //'${degreeList[index]} | ${schoolList[index]}',
                    postTime: durationList[index]!,
                    //dateList[index]!.substring(0, 11),
                    reportTap: () async {
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
                                                    //height: 100,
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
                    mutualLike: likesList[index]! -
                        values.length, //likesList[index].toString(),
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
                    //height: 2.0.h,
                    thickness: 5.0,
                    color: Color(0xFFD3D9E0),
                  );
                },
              ),
            ),
      // )
    );
  }

  //ConnectyCube
  _loginToCubeChat(BuildContext context, CubeUser user) {
    user.password = '12345678';
    //print("_loginToCubeChat user $user");
    CubeChatConnectionSettings.instance.totalReconnections = 0;
    CubeChatConnection.instance
        .login(user)
        .then((cubeUser) {})
        .catchError((error) {
      //print('Came Here!!');
      _processLoginError(error);
    });
  }

  void _processLoginError(exception) {
    log("Login error $exception", TAG);
    setState(() {});
    showDialogError(exception, context);
  }

  //Get all Post API
  Future<void> getAllPostApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getAllPostUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer $authToken'}));
      //print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map!['data'];

        //print(map);
        print(mapData);
        if (map!['data'].length > 0) {
          // if (name == '') {
          //   name = map['data'][0]['name'];
          //   profileImageUrl = map['data'][0]['profile_image'];
          //   degreeName = map['data'][0]['last_degree'];
          //   schoolName = map['data'][0]['school_name'];
          // }
          //print("HELLO");

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
            // print('IMG:::'+imageList.toString());
          }
          //  for (int i = 0; i < imageListMap[index].length; i++) {
          //   for(int j = 0; j < imageListMap[i].length; j++) {
          //     list.add(imageListMap[i][j]['file']);
          //   }
          //   imageList.add(list);
          //   list = [];
          //   }
          // for (int i = 0; i < imageListMap.length; i++) {
          //   for (int p = 0; p < imageListMap[i].length; p++) {
          //     print('MAP+++++' + imageListMap.toString());
          //     list.add(imageListMap[i][p]['file']);
          //   }
          //   imageList.add(list);
          //   print(imageList);
          //   list = [];
          // }
          // print('LLLLL:::' + imageList.toString());
          isLoading = false;
          isPostLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          isPostLoading = false;
          setState(() {});
        }
        ////print(result.data);
        //return result;
        setState(() {
          isLoading = false;
          isPostLoading = false;
        });

        if (map!['status'] == true) {
          //print('TRUE');
        } else if (map!['status'] == false && map!['error_code'] == 'ERR302') {
          refreshToken();
        }
      } else {
        //print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      //print(e.response);
      //print(stack);
    }
  }

  void saveToken(String token) async {
    // Write value
    await storage.FlutterSecureStorage()
        .write(key: 'access_token', value: token);
    setState(() {
      authToken = token;
    });
    getAllPostApi(0);
  }

  Future<void> refreshToken() async {
    //print(authToken);
    try {
      Dio dio = Dio();
      var response = await dio.get(Config.refreshTokenUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        refreshTokenMap = response.data;
        if (refreshTokenMap!.length > 1) {
          saveToken(refreshTokenMap!['access_token']);
        }
      } else {
        //print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
    }
  }

  Future<void> savePostApi(int? postID) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.savePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        saveMap = response.data;
        //saveMapData = map['data']['status'];

        //print(saveMap);
        // setState(() {
        //   isLoading = false;
        // });
        if (saveMap!['status'] == true) {
          //print('true');
          //getEducatorPostApi(page);
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          //print('false');
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
        //getEducatorPostApi(page);
        //print(saveMap);
      } else {
        //print(response.statusCode);
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

//get User Profile
  Future<void> getUserProfile(id) async {
    // displayProgressDialog(context);

    Map<String, dynamic>? map = {};
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      //print(response.statusCode);

      if (response.statusCode == 200) {
        map = response.data;

        //print(map!['data']);
        //print(mapData);
        if (map!['data'] != null || map['data'] != []) {
          setState(() {});
          // map['data']['role'] == 'E'
          //     ?
          pushNewScreen(context,
              screen: EducatorProfileViewScreen(
                id: id,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
          //     :
          // pushNewScreen(context,
          //     screen: LearnerProfileViewScreen(id: id,),
          //     withNavBar: false,
          //     pageTransitionAnimation:
          //     PageTransitionAnimation
          //         .cupertino);
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
        //print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
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
        //print(response.data);
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

  //Future<GetAllProperty>
  getPropertyAPI(String url) async {
    //displayProgressDialog(context);
    //await getToken();
    isLoading = true;
    propDataList.clear();
    setState(() {});
    try {
      var dio = Dio();
      var response = await dio.get(url,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        //propertyDetails = GetAllProperty.fromJson(response.data);
        propMap = response.data;
        propDataList.add(propMap!['data'][0]);
        //mapData = map!['data'];
        print('PROP:::' + propMap.toString());
        //print('PROPDATA:::'+propDataList.toString());
        //closeProgressDialog(context);

        if (propMap!['status'] == true) {
          isLoading = false;
          setState(() {});
          // if(mounted){

          // } else{
          // print('NOT MOUNTED:::');
          // Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
          // pageBuilder: (_, __, ___) => new bottomNavBar(1),), (Route<dynamic> route) => false);

          pushNewScreen(context,
              screen: PropertyDetailScreen(
                  propertyDetails: propertyDetails,
                  propData: propDataList,
                  index: 0),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
          //}

          // propertyLength = 0;
          // propertyLength = result.data == [] ? 0 : result.data.length;
          // setState(() {});
          // print('PROP:::' + propertyLength.toString());
          // print('PROP:::' + page.toString());
          // if (page > 0) {
          //   for (int i = 0; i < mapData!.length; i++) {
          //     propertyId.add(mapData![i]['property_id']);
          //     propertyName.add(mapData![i]['name']);
          //     propertyLocation.add(mapData![i]['location']['address']);
          //     propertyImage.add(mapData![i]['featured_image'][0]);
          //     //propertyPrice.add('${int.parse(result.data[i].room[0].roomAmount)}');
          //     propertyRating.add(mapData![i]['rating'].toDouble());
          //     //allImage.add(result.data[i].featuredImage);
          //     propDataList.add(mapData![i]);
          //   }
          //   print('DATAPROP:::'+ propDataList.toString());
          // isLoading = false;
          // setState(() {});
          //} else {
          // isLoading = false;
          // setState(() {});
          //}
          //} else {
          // isLoading = false;
          // setState(() {});
          // Fluttertoast.showToast(
          //   msg: result.message,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Constants.bgColor,
          //   textColor: Colors.white,
          //   fontSize: 10.0.sp,
          // );
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
      isLoading = false;
      setState(() {});
      //closeProgressDialog(context);
      if (e.response != null) {
        //print("This is the error message::::" +
        //  e.response!.data['meta']['message']);
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
        //print(e.message);
      }
    }
    //return propertyDetails;
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
        //propertyDetails = GetAllProperty.fromJson(response.data);
        postMap = response.data;
        //propDataList.add(propMap!['data'][0]);

        if (postMap['status'] == true) {
          isLoading = false;
          setState(() {});

          for (int j = 0; j < postMap['data']['post_media'].length; j++) {
            imageListMap1.add(postMap['data']['post_media'][j]['file']);
          }

          print('IMMM:::' + imageListMap1.toString());

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
                      )));

          setState(() {});

          totalCommentsList[resultComment['index']] = resultComment['count'];
          likesList[resultComment['index']] = resultComment['likeCount'];
          isSaved[resultComment['index']] = resultComment['isSaved'];
          isLiked[resultComment['index']] = resultComment['isLiked'];
          // setState(() {});

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
