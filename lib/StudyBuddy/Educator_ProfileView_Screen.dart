import 'dart:convert';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Educator_Post_Model.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sizer/sizer.dart';

class EducatorProfileViewScreen extends StatefulWidget {
  EducatorProfileViewScreen({Key key}) : super(key: key);

  @override
  _EducatorProfileViewScreenState createState() =>
      _EducatorProfileViewScreenState();
}

class _EducatorProfileViewScreenState extends State<EducatorProfileViewScreen> {
  bool isLiked = false;
  bool isSaved = true;
  var result = EducatorPost();
  Map<String, dynamic> map;
  List<dynamic> mapData;

  String name = '';
  String profileImageUrl = '';
  String degreeName = '';
  String schoolName = '';

  int page = 1;

  bool isLoading = true;
  bool isPostLoading = true;

  ScrollController _scrollController = ScrollController();
  int k = 0;

  List<int> postIdList = [];
  List<String> dateList = [];
  List<String> descriptionList = [];
  Map<int, dynamic> imageListMap = {};
  List<int> likesList = [];
  List<int> totalCommentsList = [];


  @override
  void initState() {
    getEducatorPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if(page > 1) {
          if(map['data'].length > 0) {
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
    super.initState();
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
            height: 47.0.h,
            width: 100.0.w,
            //color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
              child: Column(
                children: <Widget>[
                  //Profile DP
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/edProfile.png',
                      width: 32.5.w,
                      height: 15.0.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  //Name of Educator
                  Padding(
                    padding: EdgeInsets.only(top: 1.0.h),
                    child: Text(
                      'Natasha Young',
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
                      'B.tech | M.S University',
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
                          'Talwandi, Kota',
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
                        GestureDetector(
                          onTap: () {
                            print('Apple!!!');
                          },
                          child: Container(
                              height: 4.0.h,
                              width: 8.0.w,
                              child: Image.asset(
                                'assets/icons/apple.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(
                          width: 1.0.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            print('Google!!!');
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
                        GestureDetector(
                          onTap: () {
                            print('Facebook!!!');
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
                        GestureDetector(
                          onTap: () {
                            print('LinkedIn!!!');
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Column>[
                        Column(
                          children: <Widget>[
                            Text(
                              '10 Yrs',
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
                              '50',
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
                              '200',
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
                                      profileImageUrl,
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
                                          name,
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
                                          dateList[index],
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
                                      screen: ReportFeed(),
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
                            Container(
                              width: 88.0.w,
                              child: Text(descriptionList[index],
                                  style: TextStyle(
                                      fontSize: 9.0.sp,
                                      color: Constants.bpOnBoardSubtitleStyle,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.justify),
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
                            Padding(
                              padding: EdgeInsets.only(top: 1.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up_alt_rounded,
                                        color: Constants.bgColor,
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
                                ],
                              ),
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
                              padding: EdgeInsets.only(top: 1.0.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          isLiked
                                              ? Icons.thumb_up_sharp
                                              : Icons.thumb_up_outlined,
                                          color: isLiked
                                              ? Constants.selectedIcon
                                              : Constants
                                                  .bpOnBoardSubtitleStyle,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.only(top: 1.0.h),
                                          child: Text(
                                            "Like",
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
                                          screen: CommentScreen(),
                                          pageTransitionAnimation:
                                              PageTransitionAnimation
                                                  .cupertino);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.comment_outlined,
                                          color: Constants
                                              .bpOnBoardSubtitleStyle,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.only(top: 1.0.h),
                                          child: Text(
                                            "Comment",
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
                                      setState(() {
                                        isSaved = !isSaved;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          isSaved
                                              ? Icons.bookmark_sharp
                                              : Icons
                                                  .bookmark_outline_outlined,
                                          color: isSaved
                                              ? Constants.selectedIcon
                                              : Constants
                                                  .bpOnBoardSubtitleStyle,
                                          size: 30.0,
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

      var response = await dio.get('${Config.getEducatorPostUrl}13?page=$page');
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map['data'];

        print(map);
        print(mapData);
        if(map['data'].length > 0) {
          if(name == '') {
            name = map['data'][0]['name'];
            profileImageUrl = map['data'][0]['profile_image'];
            degreeName = map['data'][0]['last_degree'];
            schoolName = map['data'][0]['school_name'];
          }
          print("HELLO");

          for (int i = 0; i < map['data'].length; i++) {
            postIdList.add(map['data'][i]['post_id']);
            dateList.add(map['data'][i]['date']);
            descriptionList.add(map['data'][i]['description']);
            likesList.add(map['data'][i]['total_likes']);
            totalCommentsList.add(map['data'][i]['total_comments']);
            for (int j = 0; j < map['data'].length; j++) {
              imageListMap.putIfAbsent(k, () => map['data'][i]['post_media']);

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
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }

  displayProgressDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
