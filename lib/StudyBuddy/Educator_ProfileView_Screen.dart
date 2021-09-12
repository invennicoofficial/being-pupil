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
  List<String> postFileList = List<String>();
  Map<String, dynamic> postMap = Map<String, dynamic>();

  @override
  void initState() {
    getEducatorPostApi();
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
      body: Column(
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
                      width: 20.5.w,
                      height: 12.0.h,
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.w),
                shrinkWrap: true,
                itemCount: mapData.length,
                itemBuilder: (context, index) {
                  for(int i = 0; i < mapData[0]['post_media'].length; i++)
                  {
                    postFileList.add(mapData[0]['post_media'][i]['file']);
                  }
                  print(postFileList);
                  return Column(
                    children: <Widget>[
                      //main horizontal padding
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        //Container for one post
                        child: Container(
                          height: 57.5.h,
                          width: 100.0.w,
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
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        mapData[index]['profile_image'],
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
                                            mapData[index]['name'],
                                            style: TextStyle(
                                                fontSize: 9.0.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            '${mapData[index]['last_degree']} | ${mapData[index]['school_name']}',
                                            style: TextStyle(
                                                fontSize: 6.5.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            mapData[index]['date'],
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
                                child: Text(mapData[index]['description'],
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

                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 400,
                                  aspectRatio: 16 / 9,
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  enableInfiniteScroll: true,
                                  reverse: false,
                                  enlargeCenterPage: true,
                                  //onPageChanged: callbackFunction,
                                  scrollDirection: Axis.horizontal,
                                ),
                                items: mapData[index]['post_media'].map((i){
                                  return Builder(builder: (BuildContext context){
                                    return InkWell(
                                      onTap: (){
                                        print(mapData[index]['post_media'][i]['id']);
                                      },
                                      child: Container(
                                        height: 2.0.h,
                                        width: 2.0.w,
                                      )
                                    );
                                  });
                                }),
                              ),
                              // Container(
                              //   height: 30.0.h,
                              //   width: 100.0.w,
                              //   padding: EdgeInsets.zero,
                              //   decoration: BoxDecoration(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(10.0)),
                              //       image: DecorationImage(
                              //           image: AssetImage(
                              //             'assets/images/postImage.jpg',
                              //           ),
                              //           fit: BoxFit.cover)),
                              //   // child:
                              //   //     CarouselSlider.builder(
                              //   //       itemCount: 15,
                              //   //       itemBuilder: (BuildContext context, int itemIndex) {
                              //   //         return Container(
                              //   //           child: Text(itemIndex.toString()),

                              //   //       );
                              //   //       }
                              //   // PhotoViewGallery.builder(
                              //   //   //scrollPhysics: BouncingScrollPhysics(),
                              //   //   itemCount:
                              //   //       mapData[index]['post_media'].length,
                              //   //   builder: (context, pIndex) {
                              //   //     return PhotoViewGalleryPageOptions(
                              //   //         imageProvider: NetworkImage(
                              //   //             mapData[index]['post_media'][pIndex]
                              //   //                 ['file']),
                              //   //         initialScale:
                              //   //             PhotoViewComputedScale.contained *
                              //   //                 0.8,
                              //   //         heroAttributes: PhotoViewHeroAttributes(
                              //   //             tag: mapData[index]['post_media']
                              //   //                 [pIndex]['id']));
                              //   //   },
                              //   //   loadingBuilder: (context, event) => Center(
                              //   //     child: Container(
                              //   //       width: 20.0,
                              //   //       height: 20.0,
                              //   //       child: CircularProgressIndicator(
                              //   //         value: event == null
                              //   //             ? 0
                              //   //             : event.cumulativeBytesLoaded /
                              //   //                 event.expectedTotalBytes,
                              //   //       ),
                              //   //     ),
                              //   //   ),
                              //   //   // backgroundDecoration: widget.backgroundDecoration,
                              //   //   // pageController: widget.pageController,
                              //   //   // onPageChanged: onPageChanged,
                              //   // ),
                              // ),
                              //Row for Liked, commented, shared
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
                                            "${mapData[index]['total_likes']} Likes",
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
                                        "${mapData[index]['total_comments']} Comments",
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
          ),
        ],
      ),
    );
  }

//Get Educator's all Post
  Future<void> getEducatorPostApi() async {
    displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get(Config.getEducatorPostUrl);
      print(response.statusCode);

      if (response.statusCode == 200) {
        closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map['data'];

        print(map);
        print(mapData);
        print(mapData[0]['name']);
        //print(result.data);
        //return result;
        if(mapData != null){
          postMap = {};
          for(int i = 0; i < mapData.length; i++){
            for(int j = 0; j <= mapData[i]['post_media'].length; j++){
              postMap.putIfAbsent(i.toString(), () => mapData[i]['post_media'][j]['file']);
            }
          }
          print(postMap);
        }
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      closeProgressDialog(context);
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
