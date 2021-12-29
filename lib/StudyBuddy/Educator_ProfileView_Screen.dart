import 'dart:convert';

import 'package:being_pupil/Account/My_Course/Get_Educator_Course_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Educator_Post_Model.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:url_launcher/url_launcher.dart';

class EducatorProfileViewScreen extends StatefulWidget {
  final id;
  EducatorProfileViewScreen({Key? key, this.id}) : super(key: key);

  @override
  _EducatorProfileViewScreenState createState() =>
      _EducatorProfileViewScreenState();
}

class _EducatorProfileViewScreenState extends State<EducatorProfileViewScreen> {
  List<bool?> isLiked = [];
  List<bool?> isSaved = [];
  var result = EducatorPost();
  Map<String, dynamic>? map;
  List<dynamic>? mapData;

  String? name = '';
  String? profileImageUrl = '';
  String? degreeName = '';
  String? schoolName = '';
  String? location = '';

  int page = 1;

  bool isLoading = true;
  bool isPostLoading = true;

  ScrollController _scrollController = ScrollController();
  int k = 0;

  List<int?> postIdList = [];
  List<String?> dateList = [];
  List<String?> descriptionList = [];
  List<String?> nameList = [];
  List<String?> profileImageList = [];
  List<String?> degreeList = [];
  List<String?> schoolList = [];
  Map<int, dynamic> imageListMap = {};
  List<int?> likesList = [];
  List<int?> totalCommentsList = [];
  LikePostAPI like = LikePostAPI();
  Map<String, dynamic>? profileMap = {};

  Map<String, dynamic>? saveMap;
  String? authToken;


  @override
  void initState() {
    print(widget.id);
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getUserProfile(widget.id);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if(page > 1) {
          if(map!['data'].length > 0) {
            page++;
            getEducatorPostApi(page);
            print(page);
          }
        } else {
          page++;
          getEducatorPostApi(page);
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
        title: Text(
          'Study Buddy',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(
          valueColor:
          new AlwaysStoppedAnimation<Color>(Constants.bgColor),
        ),
      ) : Column(
        //shrinkWrap: true,
        //physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            // height: 80.0.h,
            width: 100.0.w,
            //color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
              child: Column(
                children: <Widget>[
                  //Profile DP
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:Image.network(
                      profileImageUrl!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  //Name of Educator
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Text(
                      name!,
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
                      '$degreeName | $schoolName',
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
                          location!,
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
                        profileMap!['data'] == null || profileMap!['data'] == {} ? Container() : profileMap!['data']['instagram_link'] == null ? Container() : GestureDetector(
                          onTap: () {
                            print('Instagram!!!');
                            _launchSocialUrl(profileMap!['data']['instagram_link']);
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/google.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        profileMap!['data'] == null || profileMap!['data'] == {} ? Container() : profileMap!['data']['facebook_link'] == null ? Container() : GestureDetector(
                          onTap: () {
                            print('Facebook!!!');
                            _launchSocialUrl(profileMap!['data']['facebook_link']);
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/facebook.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        profileMap!['data'] == null || profileMap!['data'] == {} ? Container() : profileMap!['data']['linkedin_link'] == null ? Container() : GestureDetector(
                          onTap: () {
                            print('LinkedIn!!!');
                            _launchSocialUrl(profileMap!['data']['linkedin_link']);
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/linkedin.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                      ],
                    ),
                  ),
                  //Buttons
                  Padding(
                    padding: EdgeInsets.only(top: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            print('MESSAGE!!!');
                          },
                          child: Container(
                            height: 4.5.h,
                            width: 35.0.w,
                            decoration: BoxDecoration(
                                color: Constants.bgColor,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Center(
                              child: Text(
                                'MESSAGE',
                                style: TextStyle(
                                    fontSize: 10.0.sp,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print('COURSES!!!');
                            pushNewScreen(context, screen: GetEducatorCourseScreen(userId: widget.id,),
                            withNavBar: false, pageTransitionAnimation: PageTransitionAnimation.cupertino);
                          },
                          child: Container(
                            height: 4.5.h,
                            width: 35.0.w,
                            decoration: BoxDecoration(
                                color: Constants.bgColor,
                                borderRadius: BorderRadius.circular(25.0)),
                            child: Center(
                              child: Text(
                                'COURSES',
                                style: TextStyle(
                                    fontSize: 10.0.sp,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //Other Details
                  profileMap!['data'] == null || profileMap!['data'] == {} ? Container() : Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Column>[
                        Column(
                          children: <Widget>[
                            Text(
                              profileMap!['data']['total_experience'].toString(),
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
                              profileMap!['data']['total_post'].toString(),
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
                              profileMap!['data']['total_connections'].toString(),
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
                  shrinkWrap: true,
                  itemCount: postIdList != null ? postIdList.length : 0,
                  // controller: _scrollController,
                  itemBuilder: (context, index) {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        //main horizontal padding
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            SizedBox(
                              height: 1.0.h,
                            ),
                            //ListTile for educator details
                            ListTile(
                              contentPadding: EdgeInsets.all(0.0),
                              //leading:
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      profileImageUrl!,
                                      width: 8.5.w,
                                      height: 5.0.h,
                                      fit: BoxFit.cover,
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
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '$degreeName | $schoolName',
                                          style: TextStyle(
                                              fontSize: 6.5.sp,
                                              color: Constants.bgColor,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          dateList[index]!,
                                          style: TextStyle(
                                              fontSize: 6.5.sp,
                                              color: Constants.bgColor,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  pushNewScreen(context,
                                      withNavBar: false,
                                      screen: ReportFeed(
                                        postId: postIdList[index],
                                      ),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                                },
                                child: Container(
                                    height: 4.0.h,
                                    width: 6.0.w,
                                    //color: Colors.grey,
                                    child: Icon(
                                        Icons.report_gmailerrorred_outlined)),
                              ),
                            ),
                            //Post descriptionText
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                width: 88.0.w,
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
                            imageListMap[index].length == 0 ? Container() :
                            Container(
                              height: 25.0.h,
                              width: 15.0.w,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: imageListMap[index].length,
                                itemBuilder: (context, imageIndex) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(imageListMap[index][imageIndex]['file'],
                                  height: 100,
                                  width: 250,
                                  fit: BoxFit.cover,),
                                );
                              },),
                            ),

                            //divider
                            Divider(
                              height: 1.0.h,
                              color: Constants.bpOnBoardSubtitleStyle
                                  .withOpacity(0.5),
                              thickness: 1.0,
                            ),
                            //Row for Like comment and Share
                            Padding(
                              padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h),
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
                                            ? likesList[index]! + 1
                                            : likesList[index]! - 1;
                                      });
                                    },
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
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                          width: 1.0.w,
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
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pushNewScreen(context,
                                          withNavBar: false,
                                          screen: CommentScreen(
                                            postId: postIdList[index],
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
                                          ),
                                          pageTransitionAnimation:
                                          PageTransitionAnimation
                                              .cupertino);
                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          ImageIcon(
                                            AssetImage('assets/icons/commentNew.png'),
                                            size: 25.0,
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
                                            size: 25.0,
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
          ),
        ],
      ),
    );
  }

//Get Educator's all Post
  Future<void> getEducatorPostApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getEducatorPostUrl}/${widget.id}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map!['data'];

        print(map);
        print(mapData);
        if(map!['data'].length > 0) {
          for (int i = 0; i < map!['data'].length; i++) {
            nameList.add(map!['data'][i]['name']);
            profileImageList.add(map!['data'][i]['profile_image']);
            degreeList.add(map!['data'][i]['last_degree']);
            schoolList.add(map!['data'][i]['school_name']);
            postIdList.add(map!['data'][i]['post_id']);
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


    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        profileMap = response.data;

        print(profileMap!['data']);
        //print(mapData);
        if (profileMap!['data'] != null) {
          name = profileMap!['data']['name'];
          profileImageUrl = profileMap!['data']['profile_image'];
          degreeName = profileMap!['data']['last_degree'];
          schoolName = profileMap!['data']['school_name'];
          location = profileMap!['data']['city'];
          getEducatorPostApi(page);
          setState(() {
            isLoading = false;
          });
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

// Save post API
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

        print(saveMap);
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

  displayProgressDialog(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new ProgressDialog();
          }));
    });
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
