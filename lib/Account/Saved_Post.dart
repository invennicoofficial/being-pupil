import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Fulll_Screen_Image_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/StudyBuddy/Educator_ProfileView_Screen.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Post_Widget.dart';
import 'package:being_pupil/Widgets/Shimmer_Widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class SavedPostScreen extends StatefulWidget {
  SavedPostScreen({Key? key}) : super(key: key);

  @override
  _SavedPostScreenState createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
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

  List<String?> nameList = [];
  List<int?> userIdList = [];
  List<String?> profileImageList = [];
  List<String?> degreeList = [];
  List<String?> schoolList = [];
  List<int?> postIdList = [];
  List<String?> dateList = [];
  List<String?> descriptionList = [];
  Map<int, dynamic> imageListMap = {};
  List<int?> likesList = [];
  List<int?> totalCommentsList = [];

  int? userId;
  String? authToken;
  Map<String, dynamic>? saveMap;
  SavePostAPI save = SavePostAPI();
  LikePostAPI like = LikePostAPI();
  CommentAPI comment = CommentAPI();

  Map<String, dynamic> resultComment = {};
  List<int> _current = [];
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    //print(authToken);
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getInt('userId');
    });
    //print('ID::::::' + userId.toString());
    getSavedPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map!['data'].length > 0) {
            page++;
            getSavedPostApi(page);
            //print(page);
          }
        } else {
          page++;
          getSavedPostApi(page);
          //print(page);
        }
      }
    });
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
            'Saved Post',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Constants.bgColor),
                ),
              )
            //   : postIdList.length == 0
            // ? Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Image.asset('assets/images/noBooking.png',
            //             height: 250, width: 250, fit: BoxFit.contain),
            //         SizedBox(height: 5.0,),
            //         Text(
            //           'No Saved Post',
            //           style: TextStyle(
            //               fontFamily: 'Montserrat',
            //               fontSize: 16.0.sp,
            //               fontWeight: FontWeight.w600,
            //               color: Constants.bgColor),
            //         ),
            //       ],
            //     ),
            //   )
            : SingleChildScrollView(
                controller: _scrollController,
                //physics: BouncingScrollPhysics(),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: postIdList != null ? postIdList.length : 0,
                  itemBuilder: (context, index) {
                    return PostWidget(
                    isCommentScreen: false,
                    postId: postIdList[index]!,
                    profileTap: () {
                      getUserProfile(userIdList[index]);
                    },
                    profileImage: profileImageList[index]!,
                    profileName: nameList[index]!,
                    profileSchool:
                        '${degreeList[index]} | ${schoolList[index]}',
                    postTime: dateList[index]!.substring(0, 11),
                    reportTap: () async {
                      var result = await pushNewScreen(context,
                          withNavBar: false,
                          screen: ReportFeed(
                            postId: postIdList[index],
                          ),
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                      
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
                                            Image.asset('assets/images/404.gif',
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
                                            PhotoLoadingWidget()
                                      )
                                      );
                                },
                                options: CarouselOptions(
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1.0,
                                    onPageChanged: (cindex, reason) {
                                      setState(() {
                                        _current[index] = cindex;
                                      });
                                    }
                                    )))
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
                                            margin: EdgeInsets.symmetric(vertical: 5.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: (Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black)
                                                    .withOpacity(
                                                        _current[index] == iIndex
                                                            ? 0.9
                                                            : 0.3)),
                                          );
                                        }),
                                  )
                                : SizedBox(),
                          )
                        : Row(),
                    mutualLike:
                        'Samay, Tarun & 324 other people are liked this post.', //likesList[index].toString(),
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
                                          savePostApi(postIdList[index].toString());
                    },
                    isSaved: isSaved[index]!,
                    shareTap: () {},
                  );
                    // Column(
                    //   children: <Widget>[
                    //     //main horizontal padding
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                    //       //Container for one post
                    //       child: Container(
                    //         // height: 58.0.h,
                    //         // width: 100.0.w,
                    //         //color: Colors.grey[300],
                    //         //column for post content
                    //         child: Column(
                    //           children: <Widget>[
                    //             SizedBox(
                    //               height: 1.0.h,
                    //             ),
                    //             //ListTile for educator details
                    //             ListTile(
                    //               contentPadding: EdgeInsets.all(0.0),
                    //               //leading:
                    //               title: GestureDetector(
                    //                 onTap: (){
                    //                       getUserProfile(userIdList[index]);
                    //                     },
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   children: [
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(top: 5.0),
                    //                       child: ClipRRect(
                    //                         borderRadius: BorderRadius.circular(50),
                    //                         child: CachedNetworkImage(
                    //                           imageUrl: profileImageList[index]!,
                    //                           width: 35.0,
                    //                           height: 35.0,
                    //                           fit: BoxFit.cover,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       width: 2.0.w,
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsets.only(top: 1.0.h),
                    //                       child: Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             nameList[index]!,
                    //                             style: TextStyle(
                    //                                 fontSize: 9.0.sp,
                    //                                 color: Constants.bgColor,
                    //                                 fontFamily: 'Montserrat',
                    //                                 fontWeight: FontWeight.w700),
                    //                           ),
                    //                           SizedBox(height: 1.0,),
                    //                           Text(
                    //                             '${degreeList[index]} | ${schoolList[index]}',
                    //                             style: TextStyle(
                    //                                 fontSize: 6.5.sp,
                    //                                 color: Constants.bgColor,
                    //                                 fontFamily: 'Montserrat',
                    //                                 fontWeight: FontWeight.w400),
                    //                           ),
                    //                           SizedBox(height: 1.0,),
                    //                           Text(
                    //                             dateList[index]!.substring(0, 11),
                    //                             style: TextStyle(
                    //                                 fontSize: 6.5.sp,
                    //                                 color: Constants.bgColor,
                    //                                 fontFamily: 'Montserrat',
                    //                                 fontWeight: FontWeight.w400),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               trailing: IconButton(
                    //                   icon: SvgPicture.asset('assets/icons/reportSvg.svg'),
                    //                   // Image.asset('assets/icons/issueIcon.png',
                    //                   // height: 20.0,
                    //                   // width: 20.0,),
                    //                   onPressed: () async{
                    //                    var result = await pushNewScreen(context,
                    //                         withNavBar: false,
                    //                         screen: ReportFeed(
                    //                           postId: postIdList[index],
                    //                         ),
                    //                         pageTransitionAnimation:
                    //                             PageTransitionAnimation
                    //                                 .cupertino);

                    //                       if(result == true){
                    //                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: 
                    //                         (context) => bottomNavBar(0)), (route) => false);
                    //                       }
                    //                   }),
                    //               //ImageIcon(AssetImage('assets/icons/report.png'),)
                    //             ),
                    //             //Post descriptionText
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                    //               child: Container(
                    //                 width: 100.0.w,
                    //                 child: Text(descriptionList[index]!,
                    //                   style: TextStyle(
                    //                     fontSize: 12.0.sp,
                    //                     color: Constants.bpOnBoardSubtitleStyle,
                    //                     fontFamily: 'Montserrat',
                    //                     height: 1.5,
                    //                     fontWeight: FontWeight.w400,),
                    //                   // textAlign: TextAlign.justify
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               height: 1.0.h,
                    //             ),
                    //             // // Container for image or video
                    //             // imageListMap[index].length == 0
                    //             //     ? Container()
                    //             //     : Container(
                    //             //         height: 25.0.h,
                    //             //         width: 100.0.w,
                    //             //         child: ListView.builder(
                    //             //           shrinkWrap: true,
                    //             //           physics: BouncingScrollPhysics(),
                    //             //           scrollDirection: Axis.horizontal,
                    //             //           itemCount: imageListMap[index].length,
                    //             //           itemBuilder: (context, imageIndex) {
                    //             //             return Padding(
                    //             //               padding:
                    //             //                   const EdgeInsets.all(8.0),
                    //             //               child: GestureDetector(
                    //             //                 onTap: () {
                    //             //                   List<String> imgList = [];
                    //             //                   for(int i = 0; i<imageListMap[index].length; i++) {
                    //             //                     imgList.add(imageListMap[index][i]['file']);
                    //             //                   }
                    //             //                   pushNewScreen(context,
                    //             //                       withNavBar: false,
                    //             //                       screen: FullScreenSlider(
                    //             //                           imageList: imgList,
                    //             //                           index: imageIndex,
                    //             //                           name: nameList[index]!
                    //             //                       ),
                    //             //                       pageTransitionAnimation:
                    //             //                       PageTransitionAnimation
                    //             //                           .cupertino);
                    //             //                 },
                    //             //                 child: Image.network(
                    //             //                   imageListMap[index][imageIndex]['file'],
                    //             //                   height: 100,
                    //             //                   width: 250,
                    //             //                   fit: BoxFit.cover,
                    //             //                 ),
                    //             //               ),
                    //             //             );
                    //             //           },
                    //             //         ),
                    //             //       ),
                    //             // Container for image or video
                    //           imageListMap[index].length == 0
                    //               ? Container()
                    //               : Container(
                    //                   height: 25.0.h,
                    //                   width: 100.0.w,
                    //                   child: ListView.builder(
                    //                     shrinkWrap: true,
                    //                     physics: BouncingScrollPhysics(),
                    //                     scrollDirection: Axis.horizontal,
                    //                     //itemExtent: MediaQuery.of(context).size.width / imageListMap[index].length,
                    //                     itemCount: imageListMap[index].length,
                    //                     itemBuilder: (context, imageIndex) {
                    //                       return imageListMap[index].length == 1
                    //                       ? Padding(
                    //                         padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                    //                         child: GestureDetector(
                    //                           onTap: () {
                    //                             List<String> imgList = [];
                    //                             for(int i = 0; i<imageListMap[index].length; i++) {
                    //                               imgList.add(imageListMap[index][i]['file']);
                    //                             }
                    //                             pushNewScreen(context,
                    //                                 withNavBar: false,
                    //                                 screen: FullScreenSlider(
                    //                                   imageList: imgList,
                    //                                   index: imageIndex,
                    //                                   name: nameList[index]!
                    //                                 ),
                    //                                 pageTransitionAnimation:
                    //                                 PageTransitionAnimation
                    //                                     .cupertino);
                    //                           },
                    //                           child: CachedNetworkImage(
                    //                             imageUrl: imageListMap[index][imageIndex]['file'],
                    //                             height: 100,
                    //                             width: 250,
                    //                             fit: BoxFit.contain,
                    //                           ),
                    //                         ),
                    //                       )
                    //                       : Padding(
                    //                         padding: const EdgeInsets.all(8.0),
                    //                         child: GestureDetector(
                    //                           onTap: () {
                    //                             List<String> imgList = [];
                    //                             for(int i = 0; i<imageListMap[index].length; i++) {
                    //                               imgList.add(imageListMap[index][i]['file']);
                    //                             }
                    //                             pushNewScreen(context,
                    //                                 withNavBar: false,
                    //                                 screen: FullScreenSlider(
                    //                                   imageList: imgList,
                    //                                   index: imageIndex,
                    //                                   name: nameList[index]!
                    //                                 ),
                    //                                 pageTransitionAnimation:
                    //                                 PageTransitionAnimation
                    //                                     .cupertino);
                    //                           },
                    //                           child: CachedNetworkImage(
                    //                             imageUrl: imageListMap[index][imageIndex]['file'],
                    //                             height: 100,
                    //                             width: 250,
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ),
                    //                       );
                    //                     },
                    //                   ),
                    //                 ),
                    //             //divider
                    //             Divider(
                    //               height: 1.0.h,
                    //               color: Color(0xFF7F7F7F).withOpacity(0.5),
                    //               thickness: 1.0,
                    //             ),
                    //             //Row for Like comment and Share
                    //             Padding(
                    //               padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //                 children: <Widget>[
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       setState(() {
                    //                         isLiked[index] = !isLiked[index]!;
                    //                       });
                    //                       like.likePostApi(
                    //                           postIdList[index], authToken!);
                    //                       setState(() {
                    //                         isLiked[index] == true
                    //                             ? likesList[index] = likesList[index]! + 1
                    //                             : likesList[index] = likesList[index]! - 1;
                    //                       });
                    //                     },
                    //                     child: Container(
                    //                       child: Row(
                    //                         mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                         children: [
                    //                           ImageIcon(
                    //                             isLiked[index]!
                    //                                 ? AssetImage('assets/icons/likeNew.png')
                    //                                 : AssetImage('assets/icons/likeThumb.png'),
                    //                             color: isLiked[index]!
                    //                                 ? Constants.selectedIcon
                    //                                 : Constants.bpOnBoardSubtitleStyle,
                    //                             size: 25.0,
                    //                           ),
                    //                           SizedBox(
                    //                             width: 2.0.w,
                    //                           ),
                    //                           Container(
                    //                             padding: EdgeInsets.only(top: 1.0.h),
                    //                             child: Text(
                    //                               "${likesList[index]} Likes",
                    //                               style: TextStyle(
                    //                                   fontSize: 6.5.sp,
                    //                                   color: Constants
                    //                                       .bpOnBoardSubtitleStyle,
                    //                                   fontFamily: 'Montserrat',
                    //                                   fontWeight: FontWeight.w400),
                    //                             ),
                    //                           ),
                    //                           // Container(
                    //                           //   padding:
                    //                           //       EdgeInsets.only(top: 1.0.h),
                    //                           //   child: Text(
                    //                           //     "Like",
                    //                           //     style: TextStyle(
                    //                           //         fontSize: 6.5.sp,
                    //                           //         color: Constants
                    //                           //             .bpOnBoardSubtitleStyle,
                    //                           //         fontFamily: 'Montserrat',
                    //                           //         fontWeight: FontWeight.w400),
                    //                           //   ),
                    //                           // ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   GestureDetector(
                    //                     onTap: () async{
                    //                        resultComment = await
                    //                       Navigator.of(context, rootNavigator: true).push(
                    //                         MaterialPageRoute(builder: (context)=> CommentScreen(
                    //                           postId: postIdList[index],
                    //                           name: nameList[index],
                    //                           profileImage: profileImageList[index],
                    //                           degree: degreeList[index],
                    //                           schoolName: schoolList[index],
                    //                           date: dateList[index],
                    //                           description: descriptionList[index],
                    //                           like: likesList[index],
                    //                           comment: totalCommentsList[index],
                    //                           isLiked: isLiked[index],
                    //                           isSaved: isSaved[index],
                    //                           imageListMap: imageListMap,
                    //                           index: index,
                    //                         ))
                    //                       );

                    //                       setState(() {});

                    //                        totalCommentsList[resultComment['index']] = resultComment['count'];
                    //                       //print('TC###'+totalCommentsList[resultComment['index']].toString());
                    //                     setState(() {});
                    //                     },
                    //                     child: Container(
                    //                       child: Row(
                    //                         mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                         children: [
                    //                           ImageIcon(
                    //                             AssetImage('assets/icons/commentNew.png'),
                    //                             size: 21.0,
                    //                             color: Constants.bpOnBoardSubtitleStyle,
                    //                           ),
                    //                           // Icon(
                    //                           //   Icons.comment_outlined,
                    //                           //   color: Constants
                    //                           //       .bpOnBoardSubtitleStyle,
                    //                           //   size: 30.0,
                    //                           // ),
                    //                           SizedBox(
                    //                             width: 2.0.w,
                    //                           ),
                    //                           Container(
                    //                             padding: EdgeInsets.only(top: 1.0.h),
                    //                             child: Text(
                    //                               "${totalCommentsList[index]} Comments",
                    //                               style: TextStyle(
                    //                                   fontSize: 6.5.sp,
                    //                                   color: Constants
                    //                                       .bpOnBoardSubtitleStyle,
                    //                                   fontFamily: 'Montserrat',
                    //                                   fontWeight: FontWeight.w400),
                    //                             ),
                    //                           )
                    //                           // Container(
                    //                           //   padding:
                    //                           //       EdgeInsets.only(top: 1.0.h),
                    //                           //   child: Text(
                    //                           //     "Comment",
                    //                           //     style: TextStyle(
                    //                           //         fontSize: 6.5.sp,
                    //                           //         color: Constants
                    //                           //             .bpOnBoardSubtitleStyle,
                    //                           //         fontFamily: 'Montserrat',
                    //                           //         fontWeight: FontWeight.w400),
                    //                           //   ),
                    //                           // ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   GestureDetector(
                    //                     onTap: () {
                    //                       setState(() {
                    //                         isSaved[index] = !isSaved[index]!;
                    //                       });
                    //                       savePostApi(postIdList[index].toString());
                    //                     },
                    //                     child: Container(
                    //                       child: Row(
                    //                         mainAxisAlignment:
                    //                         MainAxisAlignment.start,
                    //                         children: [
                    //                           ImageIcon(
                    //                             isSaved[index]!
                    //                                 ? AssetImage('assets/icons/saveGreen.png')
                    //                                 : AssetImage('assets/icons/saveNew.png'),
                    //                             color: isSaved[index]!
                    //                                 ? Constants.selectedIcon
                    //                                 : Constants.bpOnBoardSubtitleStyle,
                    //                             size: 21.0,
                    //                           ),
                    //                           SizedBox(
                    //                             width: 1.0.w,
                    //                           ),
                    //                           Container(
                    //                             padding:
                    //                             EdgeInsets.only(top: 1.0.h),
                    //                             child: Text(
                    //                               "Save",
                    //                               style: TextStyle(
                    //                                   fontSize: 6.5.sp,
                    //                                   color: Constants
                    //                                       .bpOnBoardSubtitleStyle,
                    //                                   fontFamily: 'Montserrat',
                    //                                   fontWeight: FontWeight.w400),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      //height: 2.0.h,
                      thickness: 5.0,
                      color: Color(0xFFD3D9E0),
                    );
                  },
                ),
              ));
  }

  //Get Svaed Post API
  Future<void> getSavedPostApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      //var response = await dio.get('${Config.getSavePostUrl}$userId?page=$page');
      var response = await dio.get('${Config.getSavePostUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map!['data'];

        //print(map!['data']);
        ////print(mapData);
        if (map!['data'].length > 0) {
          // imageListMap = {};
          // if (name == '') {
          //   name = map['data'][0]['name'];
          //   profileImageUrl = map['data'][0]['profile_image'];
          //   degreeName = map['data'][0]['last_degree'];
          //   schoolName = map['data'][0]['school_name'];
          // }
          //print("HELLO");

          for (int i = 0; i < map!['data'].length; i++) {
            postIdList.add(map!['data'][i]['post_id']);
            userIdList.add(map!['data'][i]['post_user_id']);
            nameList.add(map!['data'][i]['name']);
            profileImageList.add(map!['data'][i]['profile_image']);
            degreeList.add(map!['data'][i]['last_degree']);
            schoolList.add(map!['data'][i]['school_name']);
            dateList.add(map!['data'][i]['date']);
            descriptionList.add(map!['data'][i]['description']);
            isSaved.add(map!['data'][i]['isSaved']);
            isLiked.add(map!['data'][i]['isLiked']);
            likesList.add(map!['data'][i]['total_likes']);
            totalCommentsList.add(map!['data'][i]['total_comments']);
            //for save unsave
            //isSaved.add(true);
            for (int j = 0; j < map!['data'].length; j++) {
              imageListMap.putIfAbsent(k, () => map!['data'][i]['post_media']);
            }
            k++;
            //print(k);
          }
          //print(nameList);
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
        //print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      //print(e.response);
      //print(stack);
    }
  }

  //unsave post API
  Future<void> savePostApi(String postID) async {
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

        //print(saveMapData);
        // setState(() {
        //   isLoading = false;
        // });
        if (saveMap!['status'] == true) {
          //print('true');
          map!.clear();
          map = {};
          mapData = [];
          postIdList = [];
          dateList = [];
          descriptionList = [];
          //imageListMap.removeWhere((key, value) => key == index);
          likesList = [];
          totalCommentsList = [];
          nameList = [];
          userIdList = [];
          profileImageList = [];
          degreeList = [];
          schoolList = [];
          isSaved = [];
          isLiked = [];
          imageListMap = {};
          k = 0;
          //print('MAP:::' +imageListMap.toString());
          getSavedPostApi(1);
          // print('AFTER:::'+ postIdList.toString());
          // postIdList.removeAt(index);
          // dateList.removeAt(index);
          // descriptionList.removeAt(index);
          // //imageListMap.removeWhere((key, value) => key == index);
          // likesList.removeAt(index);
          // totalCommentsList.removeAt(index);
          // nameList.removeAt(index);
          // profileImageList.removeAt(index);
          // degreeList.removeAt(index);
          // schoolList.removeAt(index);
          // isSaved.removeAt(index);
          // isLiked.removeAt(index);
          // print('BEFORE:::'+ postIdList.toString());
          // print('AAAA:'+map['data'].toString());
          // map['data'].removeAt(index);
          // print(map['data']);
          // print(map['data'].length);
          // k = 0;
          // imageListMap = {};
          // for (int i = 0; i < map['data'].length; i++) {
          //   for (int j = 0; j < map['data'].length; j++) {
          //     imageListMap.putIfAbsent(k, () => map['data'][i]['post_media']);
          //   }
          //   k++;
          //   print(k);
          // }
          setState(() {});
          // getSavedPostApi(1);
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
    }
  }
  
}
