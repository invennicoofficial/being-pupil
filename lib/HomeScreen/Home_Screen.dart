import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/ConnectyCube/select_dialog_screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Create_Post_Screen.dart';
import 'package:being_pupil/HomeScreen/Fulll_Screen_Image_Screen.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Device_Token_Model.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'package:being_pupil/StayAndStudy/Property_Details_Screen.dart';
import 'package:being_pupil/StudyBuddy/Educator_ProfileView_Screen.dart';
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
  List<String?> descriptionList = [];
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
  List<dynamic> propDataList = [];
  //List<dynamic>? mapData;

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

    if(user != null) {
      user!.password = '12345678';
      createSession(user)
          .then((cubeSession) {
        signIn(user!)
            .then((cubeUser) async {
          _loginToCubeChat(context, user!);
        })
            .catchError((error){});
      })
          .catchError((error){});

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
          }else{
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
      //imageListMap.removeWhere((key, value) => key == index);
      likesList = [];
      totalCommentsList = [];
      nameList = [];
      profileImageList = [];
      degreeList = [];
      schoolList = [];
      isSaved = [];
      isLiked = [];
      imageListMap = {};
      k = 0;
    });
    getAllPostApi(page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    //if (mounted) setState(() {});
    if(map!['data'].length == 0){
    //_refreshController.loadComplete();
    _refreshController.loadNoData();
    } else{
      _refreshController.requestLoading();
    }
  }

  //init dynamic link
  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
         final Uri? deepLink = data?.link;

         if (deepLink != null) {
           //print('DL:::::::$deepLink');
         // ignore: unawaited_futures
         //Future.delayed(const Duration(milliseconds: 1000), () {
           getPropertyAPI(deepLink.toString().substring(0, 51));
           //setState(() {});
      //});
         //Navigator.pushNamed(context, deepLink.path);
       }
    dynamicLinks.onLink.listen((dynamicLinkData) {
      //print('DL:::'+ dynamicLinkData.link.toString());
      getPropertyAPI(dynamicLinkData.link.toString().substring(0, 51));
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
                  return Column(
                    children: <Widget>[
                      //main horizontal padding
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        //Container for one post
                        child: Container(
                          // height: index == 0 ? 27.5.h : 57.5.h,
                          // width: 100.0.w,
                          //color: Colors.grey[300],
                          //column for post content
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 1.0.h,
                              ),
                              //ListTile for educator details
                              ListTile(
                                contentPadding: EdgeInsets.all(0.0),
                                //leading:
                                title: GestureDetector(
                                  onTap: (){
                                    getUserProfile(userIdList[index]);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            profileImageList[index]!,
                                            width: 35.0,
                                            height: 35.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.0.w,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.0.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              nameList[index]!,
                                              style: TextStyle(
                                                  fontSize: 9.0.sp,
                                                  color: Constants.bgColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(height: 1.0),
                                            Text(
                                              '${degreeList[index]} | ${schoolList[index]}',
                                              style: TextStyle(
                                                  fontSize: 6.5.sp,
                                                  color: Constants.bgColor,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(height: 1.0),
                                            Text(
                                              dateList[index]!.substring(0, 11),
                                              style: TextStyle(
                                                  fontSize: 6.5.sp,
                                                  color: Constants.bpOnBoardSubtitleStyle,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                     icon: SvgPicture.asset('assets/icons/reportSvg.svg'),
                                    //  Image.asset('assets/icons/issueIcon.png',
                                    //   height: 18.0,
                                    //   width: 18.0,),
                                    onPressed: () async{
                                      var result = await 
                                      pushNewScreen(context,
                                          withNavBar: false,
                                          screen: ReportFeed(
                                            postId: postIdList[index],
                                          ),
                                          pageTransitionAnimation:
                                              PageTransitionAnimation
                                                  .cupertino);
                                        if(result == true){
                                          _onRefresh();
                                        }
                                    }),
                                // GestureDetector(
                                //   onTap: () {
                                //     pushNewScreen(context,
                                //         withNavBar: false,
                                //         screen: ReportFeed(
                                //           postId: postIdList[index],
                                //         ),
                                //         pageTransitionAnimation:
                                //             PageTransitionAnimation.cupertino);
                                //   },
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(right: 10.0),
                                //     child: Container(
                                //         height: 20.0,
                                //         width: 20.0,
                                //         //color: Colors.grey,
                                //         child: Icon(Icons.error_outline_outlined, color: Constants.bpOnBoardSubtitleStyle, size: 20.0,)
                                //         //Image.asset('assets/icons/issueIcon.png',),
                                //         // size: 25.0,
                                //         // color: Constants.bgColor,
                                //             //Icons.report_gmailerrorred_outlined
                                //             ),
                                //   )),
                                //),
                              ),
                              //Post descriptionText
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 2),
                                child: Container(
                                  width: 100.0.w,
                                  child: Text(descriptionList[index]!,
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,),
                                      // textAlign: TextAlign.justify
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              // Container for image or video
                              imageListMap[index].length == 0
                                  ? Container()
                                  : Container(
                                      height: 25.0.h,
                                      width: 100.0.w,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        //itemExtent: MediaQuery.of(context).size.width / imageListMap[index].length,
                                        itemCount: imageListMap[index].length,
                                        itemBuilder: (context, imageIndex) {
                                          return imageListMap[index].length == 1
                                          ? Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                                            child: GestureDetector(
                                              onTap: () {
                                                List<String> imgList = [];
                                                for(int i = 0; i<imageListMap[index].length; i++) {
                                                  imgList.add(imageListMap[index][i]['file']);
                                                }
                                                pushNewScreen(context,
                                                    withNavBar: false,
                                                    screen: FullScreenSlider(
                                                      imageList: imgList,
                                                      index: imageIndex,
                                                      name: nameList[index]!
                                                    ),
                                                    pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino);
                                              },
                                              child: Image.network(
                                                imageListMap[index][imageIndex]['file'],
                                                height: 100,
                                                width: 250,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                          : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                List<String> imgList = [];
                                                for(int i = 0; i<imageListMap[index].length; i++) {
                                                  imgList.add(imageListMap[index][i]['file']);
                                                }
                                                pushNewScreen(context,
                                                    withNavBar: false,
                                                    screen: FullScreenSlider(
                                                      imageList: imgList,
                                                      index: imageIndex,
                                                      name: nameList[index]!
                                                    ),
                                                    pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino);
                                              },
                                              child: Image.network(
                                                imageListMap[index][imageIndex]['file'],
                                                height: 100,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),


                              // //Row for Liked, commented, shared
                              // Padding(
                              //   padding: EdgeInsets.only(top: 1.0.h),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: <Widget>[
                              //       Row(
                              //         children: [
                              //           // Icon(
                              //           //   Icons.thumb_up_alt_rounded,
                              //           //   color: Constants.bgColor,
                              //           // ),
                              //           ImageIcon(
                              //             AssetImage('assets/icons/likeNew.png'),
                              //             size: 25.0,
                              //             color: Constants.bgColor,
                              //           ),
                              //           SizedBox(
                              //             width: 1.0.w,
                              //           ),
                              //           Container(
                              //             padding: EdgeInsets.only(top: 1.0.h),
                              //             child: Text(
                              //               "${likesList[index]} Likes",
                              //               style: TextStyle(
                              //                   fontSize: 6.5.sp,
                              //                   color: Constants
                              //                       .bpOnBoardSubtitleStyle,
                              //                   fontFamily: 'Montserrat',
                              //                   fontWeight: FontWeight.w400),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       Container(
                              //         padding: EdgeInsets.only(top: 1.0.h),
                              //         child: Text(
                              //           "${totalCommentsList[index]} Comments",
                              //           style: TextStyle(
                              //               fontSize: 6.5.sp,
                              //               color: Constants
                              //                   .bpOnBoardSubtitleStyle,
                              //               fontFamily: 'Montserrat',
                              //               fontWeight: FontWeight.w400),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              //divider
                              Divider(
                                height: 1.0.h,
                                color: Constants.bpOnBoardSubtitleStyle
                                    .withOpacity(0.5),
                                thickness: 1.0,
                              ),


                              //Row for Like comment and Share
                              Padding(
                                padding: EdgeInsets.only(top: 0.3.h, bottom: 0.3.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLiked[index] = !isLiked[index]!;
                                        });
                                        like.likePostApi(
                                            postIdList[index], authToken!);
                                        setState(() {
                                          isLiked[index] == true
                                              ? likesList[index] = likesList[index]! + 1
                                              : likesList[index] = likesList[index]! - 1;
                                        });
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ImageIcon(
                                              isLiked[index]!
                                                  ? AssetImage('assets/icons/likeNew.png')
                                                  : AssetImage('assets/icons/likeThumb.png'),
                                              color: isLiked[index]!
                                                  ? Constants.selectedIcon
                                                  : Constants.bpOnBoardSubtitleStyle,
                                              size: 25.0,
                                            ),
                                            SizedBox(
                                              width: 2.0.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 1.0.h),
                                              child: Text(
                                                "${likesList[index]} Likes",
                                                style: TextStyle(
                                                    fontSize: 6.5.sp,
                                                    color: Constants
                                                        .bpOnBoardSubtitleStyle,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                            // Container(
                                            //   padding:
                                            //       EdgeInsets.only(top: 1.0.h),
                                            //   child: Text(
                                            //     "Like",
                                            //     style: TextStyle(
                                            //         fontSize: 6.5.sp,
                                            //         color: Constants
                                            //             .bpOnBoardSubtitleStyle,
                                            //         fontFamily: 'Montserrat',
                                            //         fontWeight: FontWeight.w400),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        //commentResult = await 
                                          resultComment = await
                                          Navigator.of(context, rootNavigator: true).push(
                                            MaterialPageRoute(builder: (context)=> CommentScreen(
                                              postId: postIdList[index],
                                              userId: userIdList[index],
                                              name: nameList[index],
                                              profileImage: profileImageList[index],
                                              degree: degreeList[index],
                                              schoolName: schoolList[index],
                                              date: dateList[index],
                                              description: descriptionList[index],
                                              like: likesList[index],
                                              comment: totalCommentsList[index],
                                              isLiked: isLiked[index],
                                              isSaved: isSaved[index],
                                              imageListMap: imageListMap,
                                              index: index,
                                            ))
                                          );

                                          setState(() {});

                                          totalCommentsList[resultComment['index']] = resultComment['count'];
                                          //print('TC###'+totalCommentsList[resultComment['index']].toString());
                                        setState(() {});
                                        // pushNewScreen(context,
                                        //     withNavBar: false,
                                        //     screen: CommentScreen(
                                        //       postId: postIdList[index],
                                        //       userId: userIdList[index],
                                        //       name: nameList[index],
                                        //       profileImage: profileImageList[index],
                                        //       degree: degreeList[index],
                                        //       schoolName: schoolList[index],
                                        //       date: dateList[index],
                                        //       description: descriptionList[index],
                                        //       like: likesList[index],
                                        //       comment: totalCommentsList[index],
                                        //       isLiked: isLiked[index],
                                        //       isSaved: isSaved[index],
                                        //       imageListMap: imageListMap,
                                        //       index: index,
                                        //     ),
                                        //     pageTransitionAnimation:
                                        //         PageTransitionAnimation
                                        //             .cupertino
                                        //             );
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ImageIcon(
                                              AssetImage('assets/icons/commentNew.png'),
                                              size: 21.0,
                                              color: Constants.bpOnBoardSubtitleStyle,
                                            ),
                                            // Icon(
                                            //   Icons.comment_outlined,
                                            //   color: Constants
                                            //       .bpOnBoardSubtitleStyle,
                                            //   size: 30.0,
                                            // ),
                                            SizedBox(
                                              width: 2.0.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 1.0.h),
                                              child: Text(
                                                // resultComment['index'] == index 
                                                // ? "${resultComment['count']} Comments"
                                                // : 
                                                "${totalCommentsList[index]} Comments",
                                                style: TextStyle(
                                                    fontSize: 6.5.sp,
                                                    color: Constants
                                                        .bpOnBoardSubtitleStyle,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            )
                                            // Container(
                                            //   padding:
                                            //       EdgeInsets.only(top: 1.0.h),
                                            //   child: Text(
                                            //     "Comment",
                                            //     style: TextStyle(
                                            //         fontSize: 6.5.sp,
                                            //         color: Constants
                                            //             .bpOnBoardSubtitleStyle,
                                            //         fontFamily: 'Montserrat',
                                            //         fontWeight: FontWeight.w400),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isSaved[index] = !isSaved[index]!;
                                        });
                                        savePostApi(postIdList[index]);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ImageIcon(
                                              isSaved[index]!
                                                  ? AssetImage('assets/icons/saveGreen.png')
                                                  : AssetImage('assets/icons/saveNew.png'),
                                              color: isSaved[index]!
                                                  ? Constants.selectedIcon
                                                  : Constants.bpOnBoardSubtitleStyle,
                                              size: 21.0,
                                            ),
                                            SizedBox(
                                              width: 1.0.w,
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(top: 1.0.h),
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                    fontSize: 6.5.sp,
                                                    color: Constants
                                                        .bpOnBoardSubtitleStyle,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
    CubeChatConnection.instance.login(user).then((cubeUser) {
    }).catchError((error) {
      //print('Came Here!!');
      _processLoginError(error);
    });
  }

  void _processLoginError(exception) {
    log("Login error $exception", TAG);
    setState(() {

    });
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
            nameList.add(map!['data'][i]['name']);
            profileImageList.add(map!['data'][i]['profile_image']);
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
            for (int j = 0; j < map!['data'].length; j++) {
              imageListMap.putIfAbsent(k, () => map!['data'][i]['post_media']);
            }
            k++;
            //print(k);
          }
          //print(imageListMap);
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
        } else if(map!['status'] == false && map!['error_code'] == 'ERR302') {
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
    await storage.FlutterSecureStorage().write(key: 'access_token', value: token);
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
              screen: EducatorProfileViewScreen(id: id,),
              withNavBar: false,
              pageTransitionAnimation:
              PageTransitionAnimation.cupertino);
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

  Future<void> deviceTokenAPi(String token) async{
    var result = DeviceToken();

    try{
      var dio = Dio();
      FormData formData = FormData.fromMap({
        "deviceToken": token,
        "deviceType": 'A'
      });

      var response = await dio.post(Config.deviceTokenUrl, data: formData,
      options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if(response.statusCode == 200){
        result = DeviceToken.fromJson(response.data);
        //print(response.data);
        if(result.status == true){
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else{
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
          }
      }
    }on DioError catch (e, stack) {
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
        //print('PROP:::'+propMap.toString());
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
            
            pushNewScreen(context, screen: PropertyDetailScreen(propertyDetails: propertyDetails, 
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
        }
        else{
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
}
