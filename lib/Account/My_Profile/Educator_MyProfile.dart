import 'package:being_pupil/Account/My_Profile/Edit_Profile_Educator.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Fulll_Screen_Image_Screen.dart';
import 'package:being_pupil/HomeScreen/Update_Post_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/MyProfile_Model.dart';
import 'package:being_pupil/Model/Post_Model/Educator_Post_Model.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Edit_Profile_Learner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class EducatorMyProfileScreen extends StatefulWidget {
  EducatorMyProfileScreen({Key? key}) : super(key: key);

  @override
  _EducatorMyProfileScreenState createState() =>
      _EducatorMyProfileScreenState();
}

class _EducatorMyProfileScreenState extends State<EducatorMyProfileScreen> {
  List<bool?> isLiked = [];
  List<bool?> isSaved = [];
  String? registerAs;
  var result = EducatorPost();
  Map<String, dynamic>? map;
  List<dynamic>? mapData;
  Map<String, dynamic>? delMap;
  Map<String, dynamic>? saveMap;
  List<dynamic>? saveMapData;
  String? name = '';
  String? profileImageUrl = '';
  String? degreeName = '';
  String? schoolName = '';

  int page = 1;

  bool isLoading = true;
  bool isPostLoading = true;

  ScrollController _scrollController = ScrollController();
  int k = 0;

  List<int?> postIdList = [];
  List<String?> dateList = [];
  List<String?> descriptionList = [];
  Map<int, dynamic> imageListMap = {};
  List<int?> likesList = [];
  List<int?> totalCommentsList = [];

  String? authToken;
  int? userId;
  MyProfile? profileResult;
  SavePostAPI save = SavePostAPI();
  Map<String, dynamic>? myProfileMap;
  bool isProfileLoading = true;
  LikePostAPI like = LikePostAPI();
  String? socialUrl;

  @override
  void initState() {
    getToken();

    super.initState();
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
    print(registerAs);
    print('ID::::::' + userId.toString());
    getMyProfileApi();
    getMyPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map!['data'].length > 0) {
            page++;
            getMyPostApi(page);
            print(page);
          }
        } else {
          page++;
          getMyPostApi(page);
          print(page);
        }
      }
    });
  }

  void _launchSocialUrl(String url) async {
    //final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
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
          onPressed: //null,
              () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              registerAs == 'E'
                  ? pushNewScreen(context,
                      screen: EditEducatorProfile(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino)
                  : pushNewScreen(context,
                      screen: EditLearnerProfile(),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
            },
            child: Container(
              //color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 2.0.w),
              child: Center(
                child: Text(
                  'Edit',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6)),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'My Profile',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: isProfileLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constants.bgColor),
              ),
            )
          : Column(
              //shrinkWrap: true,
              //physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  //height: 41.0.h,
                  width: 100.0.w,
                  //color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 4.0.w),
                    child: Column(
                      children: <Widget>[
                        //Profile DP
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            myProfileMap!['data']['profile_image'],
                            width: 90.0,
                            height: 90.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        //Name of Educator
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            myProfileMap!['data']['name'],
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Constants.bgColor),
                          ),
                        ),
                        //Degree
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            '${myProfileMap!['data']['last_degree']} | ${myProfileMap!['data']['school_name']}',
                            style: TextStyle(
                                fontSize: 8.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                color: Constants.bgColor),
                          ),
                        ),
                        //Location
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
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
                                myProfileMap!['data']['city'],
                                style: TextStyle(
                                    fontSize: 8.0.sp,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor),
                              ),
                            ],
                          ),
                        ),
                        //Social Handle
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: myProfileMap!['data']
                                            ['facebook_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    print('Facebook!!!');
                                    _launchSocialUrl(
                                        myProfileMap!['data']['facebook_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/fbSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/facebook.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),
                               SizedBox(
                                width: myProfileMap!['data']['facebook_link'] == null ? 0.0 :  2.0.w,
                              ),
                              Visibility(
                                visible: myProfileMap!['data']
                                            ['instagram_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    print('Instagram!!!');
                                    _launchSocialUrl(myProfileMap!['data']
                                        ['instagram_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/instaSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/instagram.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),
                               SizedBox(
                                width: myProfileMap!['data']['instagram_link'] == null ? 0.0 :  2.0.w,
                              ),

                              Visibility(
                                visible: myProfileMap!['data']
                                            ['linkedin_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    print('LinkedIn!!!');
                                    _launchSocialUrl(
                                        myProfileMap!['data']['linkedin_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/linkedinSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/linkedin.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),        
                              SizedBox(
                                width: myProfileMap!['data']['linkedin_link'] == null ? 0.0 :  2.0.w,
                              ),
                              Visibility(
                                visible:
                                    myProfileMap!['data']['other_link'] == null
                                        ? false
                                        : true,
                                child: GestureDetector(
                                  onTap: () {
                                    print('Other!!!');
                                    _launchSocialUrl(
                                        myProfileMap!['data']['other_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset('assets/icons/otherSvg.svg')
                                      // Image.asset(
                                      //   'assets/icons/other_link.png',
                                      //   fit: BoxFit.contain,
                                      // )
                                      ),
                                ),
                              ),                  
                            ],
                          ),
                        ),
                        //Other Details
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Column>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '${myProfileMap!['data']['total_experience']} Yrs',
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Text(
                                    'Experience',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    myProfileMap!['data']['total_post']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    myProfileMap!['data']['total_connections']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat'),
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Text(
                                    'Connections',
                                    style: TextStyle(
                                        fontSize: 8.0.sp,
                                        color: Constants.bgColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Profile Divider
                Divider(
                  height: 1.0.h,
                  color: Constants.bgColor.withOpacity(0.5),
                ),
                //Educator Post
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0.h, horizontal: 2.0.w),
                      shrinkWrap: true,
                      itemCount: postIdList != null ? postIdList.length : 0,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            //main horizontal padding
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                              //Container for one post
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  //ListTile for educator details
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0.0),
                                    //leading:
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.network(
                                              profileImageUrl!,
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
                                                name!,
                                                style: TextStyle(
                                                    fontSize: 9.0.sp,
                                                    color: Constants.bgColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(height: 1.0,),
                                              Text(
                                                '$degreeName | $schoolName',
                                                style: TextStyle(
                                                    fontSize: 6.5.sp,
                                                    color: Constants.bgColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(height: 1.0,),
                                              Text(
                                                dateList[index]!.substring(0, 11),
                                                style: TextStyle(
                                                    fontSize: 6.5.sp,
                                                    color: Constants.bgColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    //   trailing: GestureDetector(
                                    //     onTap: () {
                                    //       pushNewScreen(context,
                                    //           withNavBar: false,
                                    //           screen: ReportFeed(),
                                    //           pageTransitionAnimation:
                                    //               PageTransitionAnimation.cupertino);
                                    //     },
                                    //     child: Container(
                                    //   height: 2.5.h,
                                    //   width: 4.0.w,
                                    //   child: ImageIcon(
                                    //     AssetImage('assets/icons/menu.png'),
                                    //     size: 15,
                                    //   ),
                                    // ),
                                    //   ),
                                    trailing: PopupMenuButton(
                                        color: Color(0xFFF0F2F4),
                                        elevation: 2.0,
                                        padding: EdgeInsets.only(left: 8.0.w),
                                        onSelected: (dynamic value) {
                                          if (value == 2) {
                                            // isProfileLoading = true;
                                            _showDialog(
                                                postIdList[index].toString(),
                                                index);
                                          } else {
                                            pushNewScreen(context,
                                                screen: imageListMap.length ==
                                                            0 ||
                                                        imageListMap.length ==
                                                            null
                                                    ? UpdatePostScreen(
                                                        description:
                                                            descriptionList[
                                                                    index]
                                                                .toString(),
                                                        postId:
                                                            postIdList[index],
                                                        // images: imageListMap.length == 0 ? 0 : imageListMap,
                                                        // index: index,
                                                      )
                                                    : UpdatePostScreen(
                                                        description:
                                                            descriptionList[
                                                                    index]
                                                                .toString(),
                                                        images: imageListMap,
                                                        index: index,
                                                        postId:
                                                            postIdList[index],
                                                      ),
                                                withNavBar: false,
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino);
                                          }
                                          //  Fluttertoast.showToast(
                                          //    msg: value == 1
                                          //    ? 'Edit Post'
                                          //    : 'Delete Post',
                                          //    backgroundColor: Constants.bgColor,
                                          //    gravity: ToastGravity.BOTTOM,
                                          //    fontSize: 10.0.sp,
                                          //    toastLength: Toast.LENGTH_SHORT,
                                          //    textColor: Colors.white
                                          //  );
                                        },
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants.bgColor),
                                                ),
                                                value: 1,
                                              ),
                                              PopupMenuItem(
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Constants.bgColor),
                                                ),
                                                value: 2,
                                              )
                                            ]),
                                  ),
                                  //Post descriptionText
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 2.0),
                                    child: Container(
                                      width: 100.0.w,
                                      child: Text(
                                        descriptionList[index]!,
                                        style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                        ),
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
                                                      name: name!
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
                                                      name: name!
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
                                  //           ImageIcon(
                                  //             AssetImage(
                                  //                 'assets/icons/likeNew.png'),
                                  //             size: 25.0,
                                  //             color: Constants.bgColor,
                                  //           ),
                                  //           SizedBox(
                                  //             width: 1.0.w,
                                  //           ),
                                  //           Container(
                                  //             padding:
                                  //                 EdgeInsets.only(top: 1.0.h),
                                  //             child: Text(
                                  //               "${likesList[index]} Likes",
                                  //               style: TextStyle(
                                  //                   fontSize: 6.5.sp,
                                  //                   color: Constants
                                  //                       .bpOnBoardSubtitleStyle,
                                  //                   fontFamily: 'Montserrat',
                                  //                   fontWeight:
                                  //                       FontWeight.w400),
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
                                  //
                                  //divider
                                  Divider(
                                    height: 1.0.h,
                                    color: Constants.bpOnBoardSubtitleStyle
                                        .withOpacity(0.5),
                                    thickness: 1.0,
                                  ),
                                  //Row for Like comment and Share
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.5.h, bottom: 0.5.h),
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
                                                  ? likesList[index] =
                                                      likesList[index]! + 1
                                                  : likesList[index] =
                                                      likesList[index]! - 1;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ImageIcon(
                                                isLiked[index]!
                                                    ? AssetImage(
                                                        'assets/icons/likeNew.png')
                                                    : AssetImage(
                                                        'assets/icons/likeThumb.png'),
                                                color: isLiked[index]!
                                                    ? Constants.selectedIcon
                                                    : Constants
                                                        .bpOnBoardSubtitleStyle,
                                                size: 25.0,
                                              ),
                                              SizedBox(
                                                width: 2.0.w,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 1.0.h),
                                                child: Text(
                                                  "${likesList[index]} Likes",
                                                  style: TextStyle(
                                                      fontSize: 6.5.sp,
                                                      color: Constants
                                                          .bpOnBoardSubtitleStyle,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            pushNewScreen(context,
                                                withNavBar: false,
                                                screen: CommentScreen(
                                                  postId: postIdList[index],
                                                  name: name,
                                                  profileImage: profileImageUrl,
                                                  degree: degreeName,
                                                  schoolName: schoolName,
                                                  date: dateList[index],
                                                  description:
                                                      descriptionList[index],
                                                  like: likesList[index],
                                                  comment:
                                                      totalCommentsList[index],
                                                  isLiked: isLiked[index],
                                                  isSaved: isSaved[index],
                                                  imageListMap: imageListMap,
                                                  index: index,
                                                ),
                                                pageTransitionAnimation:
                                                    PageTransitionAnimation
                                                        .cupertino);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ImageIcon(
                                                AssetImage(
                                                    'assets/icons/commentNew.png'),
                                                size: 21.0,
                                                color: Constants
                                                    .bpOnBoardSubtitleStyle,
                                              ),
                                              SizedBox(
                                                width: 2.0.w,
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 1.0.h),
                                                child: Text(
                                                  "${totalCommentsList[index]} Comments",
                                                  style: TextStyle(
                                                      fontSize: 6.5.sp,
                                                      color: Constants
                                                          .bpOnBoardSubtitleStyle,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSaved[index] = !isSaved[index]!;
                                              //savePostApi(postIdList[index]);
                                            });
                                            save.savePostApi(
                                                postIdList[index], authToken!);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ImageIcon(
                                                isSaved[index]!
                                                    ? AssetImage(
                                                        'assets/icons/saveGreen.png')
                                                    : AssetImage(
                                                        'assets/icons/saveNew.png'),
                                                color: isSaved[index]!
                                                    ? Constants.selectedIcon
                                                    : Constants
                                                        .bpOnBoardSubtitleStyle,
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
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                ),
              ],
            ),
    );
  }

  //Alert Dialog for Delete Post
  void _showDialog(id, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Delete Post',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Constants.bgColor),),
              // IconButton(
              //   icon: Icon(Icons.close),
              //   iconSize: 20.0,
              //   color: Constants.bpOnBoardSubtitleStyle,
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // )
            ],
          ),
          actionsPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          content: Text("Are you sure you want to delete this post.",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 11.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Constants.bgColor),
                  textAlign: TextAlign.center),
          actions: [
            // usually buttons at the bottom of the dialog

            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  height: 40.0,
                  width: 30.0.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Constants.bgColor, width: 1.0)),
                  child: Center(child: Text('NO'))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                deletePostApi(id, index);
              },
              child: Container(
                  height: 40.0,
                  width: 30.0.w,
                  decoration: BoxDecoration(
                      color: Constants.bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Constants.bgColor, width: 1.0)),
                  child: Center(
                      child: Text(
                    'YES',
                    style: TextStyle(color: Colors.white),
                  ))),
            ),
          ],
        );
      },
    );
  }

  //Get Profile Details
  Future<void> getMyProfileApi() async {
    try {
      Dio dio = Dio();

      var response = await dio.get(Config.myProfileUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        myProfileMap = response.data;

        print('PROFILE:::' + myProfileMap.toString());
        setState(() {
          isProfileLoading = false;
        });
      } else {
        setState(() {
          isProfileLoading = true;
        });
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }

  //Get Educator's all Post
  Future<void> getMyPostApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      // var response =
      //     await dio.get('${Config.getEducatorPostUrl}$userId?page=$page');
      //var response = await dio.get(Config.myProfileUrl,options: Options(headers: {"Authorization": 'Bearer $authToken'}));
      var response = await dio.get(
          '${Config.getEducatorPostUrl}/$userId?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //profileResult = MyProfile.fromJson(response.data);

        //print(profileResult.data.name);
        map = response.data;
        mapData = map!['data'];

        print(map);
        print('DATA:::' + mapData.toString());
        if (map!['data'].length > 0) {
          if (name == '') {
            name = map!['data'][0]['name'];
            profileImageUrl = map!['data'][0]['profile_image'];
            degreeName = map!['data'][0]['last_degree'];
            schoolName = map!['data'][0]['school_name'];
          }
          print("HELLO");

          for (int i = 0; i < map!['data'].length; i++) {
            postIdList.add(map!['data'][i]['post_id']);
            dateList.add(map!['data'][i]['date']);
            descriptionList.add(map!['data'][i]['description']);
            likesList.add(map!['data'][i]['total_likes']);
            totalCommentsList.add(map!['data'][i]['total_comments']);
            isLiked.add(map!['data'][i]['isLiked']);
            isSaved.add(map!['data'][i]['isSaved']);
            for (int j = 0; j < map!['data'].length; j++) {
              imageListMap.putIfAbsent(k, () => map!['data'][i]['post_media']);
            }
            k++;
            print(k);
          }
          print(imageListMap);
          isLoading = false;
          isPostLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          isPostLoading = false;
          setState(() {});
        }
        //print(result.data);
        //return result;
        setState(() {
          isLoading = false;
          isPostLoading = false;
        });

        if (map!['status'] == true) {
          // map = Map<String, dynamic>();
          // mapData = [];
          print('B MAPPPPPPP:::' + map.toString());
        }
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

  Future<void> deletePostApi(String postID, int index) async {
    //var delResult = PostDelete();

    setState(() {
      isLoading = true;
    });

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.postDeleteUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        delMap = response.data;

        // getMyPostApi(page);

        if (delMap!['status'] == true) {
          isProfileLoading = false;
          print('true');
          map = {};
          mapData = [];
          postIdList = [];
          dateList = [];
          descriptionList = [];
          imageListMap[index] = [];
          likesList = [];
          totalCommentsList = [];
          print('A MAPPPPPPP:::' + map.toString());
          getMyPostApi(1);
          //print('B MAPPPPPPP:::' + map.toString());
          //getData();
          Fluttertoast.showToast(
              msg: delMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
          setState(() {});
        } else {
          print('false');
          if (delMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: delMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: delMap!['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
        //getEducatorPostApi(page);
        print(delMap);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }

  Future<void> savePostApi(int postID) async {
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

        print(saveMapData);
        // setState(() {
        //   isLoading = false;
        // });
        if (saveMap!['status'] == true) {
          print('true');
          //getEducatorPostApi(page);
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
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
        print(saveMap);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }
}
