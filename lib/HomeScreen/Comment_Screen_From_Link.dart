import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Home_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/StudyBuddy/Educator_ProfileView_Screen.dart';
import 'package:being_pupil/StudyBuddy/Learner_ProfileView_Screen.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Post_Widget.dart';
import 'package:being_pupil/Widgets/Shimmer_Widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

import 'Fulll_Screen_Image_Screen.dart';

class CommentScreenFromLink extends StatefulWidget {
  String? name, profileImage, degree, schoolName, date, description, mutual;
  int? postId, like, comment, index, userId, otherCount;
  bool? isLiked, isSaved;
  List<String>? imageListMap;
  CommentScreenFromLink(
      {Key? key,
      this.postId,
      this.userId,
      this.name,
      this.profileImage,
      this.degree,
      this.schoolName,
      this.date,
      this.description,
      this.like,
      this.comment,
      this.isLiked,
      this.isSaved,
      this.imageListMap,
      this.index,
      this.mutual,
      this.otherCount})
      : super(key: key);

  @override
  _CommentScreenFromLinkState createState() => _CommentScreenFromLinkState();
}

class _CommentScreenFromLinkState extends State<CommentScreenFromLink> {
  List<String> dpImages = [];
  List<String?> profileImages = [];
  List<String?> name = [];
  List<String?> date = [];
  List<String?> comments = [];
  List<int?> commentId = [];
  List<String?> commentUserId = [];
  TextEditingController commentController = TextEditingController();
  CommentAPI comment = CommentAPI();
  //GetCommentList commentList = GetCommentList();
  String? authToken;
  int page = 1;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  int k = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? imageUrl;
  Map<String, dynamic>? commentMap;
  List<dynamic>? commentMapData;
  int? userId;
  Map<String, dynamic>? delMap;
  Map<String, dynamic>? editMap;
  bool isEdit = false;
  FocusNode focusNode = FocusNode();
  int? idForEdit;
  LikePostAPI like = LikePostAPI();
  Map<String, dynamic>? saveMap;
  int? commentCount, likeCount;
  Map<String, dynamic>? resultMap;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool _isCreatingLink = false;
  var dLink = CreateDynamicLink();

  @override
  void initState() {
    dpImages = [
      'assets/images/educatorDP.png',
      'assets/images/dp2.png',
      'assets/images/educatorDP.png',
      'assets/images/dp2.png',
      'assets/images/educatorDP.png',
      'assets/images/dp2.png',
      'assets/images/educatorDP.png',
      'assets/images/dp2.png',
      'assets/images/educatorDP.png',
      'assets/images/dp2.png',
    ];
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    //print(authToken);
    getData();
    setState(() {
      commentCount = widget.comment;
      likeCount = widget.like;
      resultMap = {
        "count": widget.comment,
        "isSaved": widget.isSaved,
        "likeCount": widget.like,
        "index": widget.index,
        "isLiked": widget.isLiked
      };
    });
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getInt('userId');
      imageUrl = preferences.getString('imageUrl');
    });
    getCommentListApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (commentMapData!.length > 0) {
            page++;
            getCommentListApi(page);
            //print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getCommentListApi(page);
          //print(page);
        }
      }
    });
  }

  void _onLoading() async {
    //if (mounted) setState(() {});
    if (commentMapData!.length == 0) {
      //_refreshController.loadComplete();
      _refreshController.loadNoData();
    } else {
      _refreshController.requestLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Constants.bgColor,
          leading: IconButton(
            icon: Icon(
              Icons.west_rounded,
              color: Colors.white,
              size: 35.0,
            ),
            onPressed: () {
              Navigator.pop(context, resultMap);
              //print('CCC###'+resultMap.toString());
            },
            padding: EdgeInsets.zero,
          ),
          title: Text(
            'Comments',
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
            : Stack(
                children: <Widget>[
                  // ListView.builder(
                  //     shrinkWrap: true,
                  //     itemCount: 5,
                  //     itemBuilder: (context, index) {
                  //       return
                  SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: ClassicFooter(
                      loadStyle: LoadStyle.ShowWhenLoading,
                      noDataText: 'No More Comments',
                      //noMoreIcon: Icon(Icons.refresh_outlined),
                    ),
                    onLoading: _onLoading,
                    child: ListView(
                      controller: _scrollController,
                      //physics: BouncingScrollPhysics(),
                      //mainAxisSize: MainAxisSize.min,
                      shrinkWrap: true,
                      children: <Widget>[
                        PostWidget(
                          isMyProfile: false,
                          iscomment: false,
                          mutualFriend: widget.mutual,
                          isCommentScreen: true,
                          postId: widget.postId!,
                          profileTap: () {
                            getUserProfile(widget.userId!);
                          },
                          profileImage: widget.profileImage!,
                          profileName: widget.name!,
                          profileSchool: widget.degree!,
                              //'${widget.degree} | ${widget.schoolName}',
                          postTime: widget.date!,//widget.date!.substring(0, 11),
                          reportTap: IconButton(
                      icon: Icon(
                        Icons.more_horiz_outlined,
                        color: Color(0xFF828282),
                      ),
                      onPressed: () async {
                            var result = await pushNewScreen(context,
                                withNavBar: false,
                                screen: ReportFeed(
                                  postId: widget.postId!,
                                ),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                            if (result == true) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => bottomNavBar(0)),
                                  (route) => false);
                            }
                          },
                    ),
                          
                          description: widget.description!,
                          imageListView: widget
                                      .imageListMap![widget.index!].length !=
                                  0
                              ? Container(
                                  height: 25.0.h,
                                  width: 100.0.w,
                                  child: CarouselSlider.builder(
                                      carouselController: _controller,
                                      itemCount: widget
                                          .imageListMap!.length,
                                      itemBuilder:
                                          (context, imageIndex, rindex) {
                                        return GestureDetector(
                                            onTap: () {
                                              // List<String> imgList = [];
                                              // for (int i = 0;
                                              //     i <
                                              //         widget
                                              //             .imageListMap![
                                              //                 widget.index!]
                                              //             .length;
                                              //     i++) {
                                              //   imgList.add(widget
                                              //           .imageListMap![
                                              //       widget.index!][i]['file']);
                                              // }
                                              pushNewScreen(context,
                                                  withNavBar: false,
                                                  screen: FullScreenSlider(
                                                      imageList: widget.imageListMap!,
                                                      index: imageIndex,
                                                      name: widget.name!),
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino);
                                            },
                                            child: CachedNetworkImage(
                                                imageUrl: widget.imageListMap![
                                                        imageIndex],
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'assets/images/404.gif',
                                                        fit: BoxFit.fitHeight,
                                                        width: 100.0.w),
                                                imageBuilder: (context,
                                                        imageProvider) =>
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
                                              _current = cindex;
                                            });
                                          })))
                              : Container(),
                          indicator: widget
                                      .imageListMap!.length !=
                                  0
                              ? Center(
                                  child: widget.imageListMap!
                                              .length !=
                                          1
                                      ? SizedBox(
                                          height: 18,
                                          child: ListView.builder(
                                              itemCount: widget
                                                  .imageListMap!
                                                  .length,
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
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black)
                                                          .withOpacity(
                                                              _current == iIndex
                                                                  ? 0.9
                                                                  : 0.3)),
                                                );
                                              }),
                                        )
                                      : SizedBox(),
                                )
                              : Row(),
                          mutualLike: widget.otherCount!, //likesList[index].toString(),
                          likeTap: () async {
                            setState(() {
                              widget.isLiked = !widget.isLiked!;
                            });
                            await like.likePostApi(widget.postId, authToken!);
                            setState(() {
                              likeCount = like.likeCount;
                              widget.isLiked == true
                                  ? widget.like = widget.like! + 1
                                  : widget.like = widget.like! - 1;
                              resultMap = {
                                "count": commentCount,
                                "isSaved": widget.isSaved,
                                "likeCount": likeCount,
                                "index": widget.index,
                                "isLiked": widget.isLiked
                              };
                            });
                          },
                          isLiked: widget.isLiked!,
                          totalLike: likeCount.toString(),
                          totalComments: commentCount.toString(),
                          commentTap: () {},
                          saveTap: () {
                            setState(() {
                              widget.isSaved = !widget.isSaved!;
                            });
                            savePostApi(widget.postId);
                            resultMap = {
                              "count": commentCount,
                              "isSaved": widget.isSaved,
                              "isLiked": widget.isLiked,
                              "likeCount": widget.like,
                              "index": widget.index
                            };
                          },
                          isSaved: widget.isSaved!,
                          shareTap: () async {
                            await dLink.createDynamicLink(
                              true,
                              widget.postId.toString(),
                              widget.index!,
                              widget.name!,
                              widget.description!,
                              widget.imageListMap!.isEmpty
                                  ? ''
                                  : widget.imageListMap![0]
                                      .toString(),
                            );
                          },
                          commentText: '',
                        ),

                        //main horizontal paddingF
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                        //   //Container for one post
                        //   child: Container(
                        //     width: 100.0.w,
                        //     //color: Colors.grey[300],
                        //     //column for post content
                        //     child: Column(
                        //       children: <Widget>[
                        //         SizedBox(
                        //           height: 1.0.h,
                        //         ),
                        //         //ListTile for educator details
                        //         ListTile(
                        //           contentPadding: EdgeInsets.all(0.0),
                        //           //leading:
                        //           title: GestureDetector(
                        //              onTap: (){
                        //                   getUserProfile(widget.userId!);
                        //                 },
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(top: 5.0),
                        //                   child: ClipRRect(
                        //                     borderRadius: BorderRadius.circular(50),
                        //                     child:CachedNetworkImage(
                        //                         imageUrl: widget.profileImage!,
                        //                       width: 35.0,
                        //                       height: 35.0,
                        //                       fit: BoxFit.cover,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   width: 2.0.w,
                        //                 ),
                        //                 Padding(
                        //                   padding: EdgeInsets.only(top: 1.0.h),
                        //                   child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Text(
                        //                         widget.name!,
                        //                         style: TextStyle(
                        //                             fontSize: 9.0.sp,
                        //                             color: Constants.bgColor,
                        //                             fontFamily: 'Montserrat',
                        //                             fontWeight: FontWeight.w700),
                        //                       ),
                        //                       SizedBox(height: 1.0,),
                        //                       Text(
                        //                         '${widget.degree} | ${widget.schoolName}',
                        //                         style: TextStyle(
                        //                             fontSize: 6.5.sp,
                        //                             color: Constants.bgColor,
                        //                             fontFamily: 'Montserrat',
                        //                             fontWeight: FontWeight.w400),
                        //                       ),
                        //                       SizedBox(height: 1.0,),
                        //                       Text(
                        //                         widget.date!,
                        //                         style: TextStyle(
                        //                             fontSize: 6.5.sp,
                        //                             color: Constants.bgColor,
                        //                             fontFamily: 'Montserrat',
                        //                             fontWeight: FontWeight.w400),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           trailing: IconButton(
                        //                icon: SvgPicture.asset('assets/icons/reportSvg.svg'),
                        //               //  Image.asset('assets/icons/issueIcon.png',
                        //               //   height: 18.0,
                        //               //   width: 18.0,),
                        //               onPressed: () async{
                        //                 var result = await pushNewScreen(context,
                        //                     withNavBar: false,
                        //                     screen: ReportFeed(
                        //                       postId: widget.postId,
                        //                     ),
                        //                     pageTransitionAnimation:
                        //                         PageTransitionAnimation
                        //                             .cupertino);

                        //                   if(result == true){
                        //                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
                        //                     (context) => bottomNavBar(0)), (route) => false);
                        //                 }
                        //               }),
                        //           //ImageIcon(AssetImage('assets/icons/report.png'),)
                        //         ),
                        //         //Post descriptionText
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                        //           child: Container(
                        //             width: 100.0.w,
                        //             child: Text(widget.description!,
                        //               style: TextStyle(
                        //                 fontSize: 9.0.sp,
                        //                 color: Constants.bpOnBoardSubtitleStyle,
                        //                 fontFamily: 'Montserrat',
                        //                 height: 1.5,
                        //                 fontWeight: FontWeight.w400,),
                        //               // textAlign: TextAlign.justify
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 1.0.h,
                        //         ),
                        //         // Container for image or video
                        //         widget.imageListMap![widget.index!].length == 0
                        //             ? Container()
                        //             : Container(
                        //                 height: 25.0.h,
                        //                 width: 100.0.w,
                        //                 child: ListView.builder(
                        //                   shrinkWrap: true,
                        //                   physics: BouncingScrollPhysics(),
                        //                   scrollDirection: Axis.horizontal,
                        //                   itemCount: widget
                        //                       .imageListMap![widget.index!].length,
                        //                   itemBuilder: (context, imageIndex) {
                        //                     return GestureDetector(
                        //                       onTap: () {
                        //                         List<String> imgList = [];
                        //                         for(int i = 0; i<widget
                        //                             .imageListMap![widget.index!].length; i++) {
                        //                           imgList.add(widget
                        //                               .imageListMap![widget.index!][i]['file']);
                        //                         }
                        //                         pushNewScreen(context,
                        //                             withNavBar: false,
                        //                             screen: FullScreenSlider(
                        //                                 imageList: imgList,
                        //                                 index: imageIndex,
                        //                                 name: widget.name!
                        //                             ),
                        //                             pageTransitionAnimation:
                        //                             PageTransitionAnimation
                        //                                 .cupertino);
                        //                       },
                        //                       child:CachedNetworkImage(
                        //                         imageUrl: widget.imageListMap![widget.index!][imageIndex]['file'],
                        //                         height: 100,
                        //                         width: 250,
                        //                         fit: BoxFit.contain,
                        //                       ),
                        //                     );
                        //                   },
                        //                 ),
                        //               ),
                        //         //divider
                        //         Divider(
                        //           height: 1.0.h,
                        //           color: Constants.bpOnBoardSubtitleStyle
                        //               .withOpacity(0.5),
                        //           thickness: 1.0,
                        //         ),
                        //         //Row for Like comment and Share
                        //         Padding(
                        //           padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: <Widget>[
                        //               GestureDetector(
                        //                 onTap: () async{
                        //                   setState(() {
                        //                     widget.isLiked = !widget.isLiked!;
                        //                   });
                        //                   await like.likePostApi(widget.postId, authToken!);
                        //                   setState(() {
                        //                     likeCount = like.likeCount;
                        //                     widget.isLiked == true
                        //                         ? widget.like = widget.like! + 1
                        //                         : widget.like = widget.like! - 1;
                        //                      resultMap = {"count": commentCount,
                        //                      "isSaved": widget.isSaved, "likeCount": likeCount,
                        //                      "index": widget.index, "isLiked": widget.isLiked};
                        //                   });
                        //                 },
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.start,
                        //                   children: [
                        //                    ImageIcon(
                        //                         widget.isLiked!
                        //                             ? AssetImage('assets/icons/likeNew.png')
                        //                             : AssetImage('assets/icons/likeThumb.png'),
                        //                         color: widget.isLiked!
                        //                             ? Constants.selectedIcon
                        //                             : Constants.bpOnBoardSubtitleStyle,
                        //                         size: 25.0,
                        //                       ),
                        //                     SizedBox(
                        //                       width: 2.0.w,
                        //                     ),
                        //                     Container(
                        //                       padding: EdgeInsets.only(top: 1.0.h),
                        //                       child: Text(
                        //                       //   likeCount == 0 || likeCount == null
                        //                       // ? "${widget.like} Likes"
                        //                       // : "$likeCount Likes",
                        //                         "${widget.like} Likes",
                        //                         style: TextStyle(
                        //                             fontSize: 6.5.sp,
                        //                             color: Constants
                        //                                 .bpOnBoardSubtitleStyle,
                        //                             fontFamily: 'Montserrat',
                        //                             fontWeight: FontWeight.w400),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //               Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.start,
                        //                 children: [
                        //                   ImageIcon(
                        //                         AssetImage('assets/icons/commentNew.png'),
                        //                         size: 21.0,
                        //                         color: Constants.bpOnBoardSubtitleStyle,
                        //                       ),
                        //                   SizedBox(
                        //                     width: 2.0.w,
                        //                   ),
                        //                   Container(
                        //                     padding: EdgeInsets.only(top: 1.0.h),
                        //                     child: Text(commentCount == 0 || commentCount == null
                        //                       ? "${widget.comment} Comments"
                        //                       : "$commentCount Comments",
                        //                       style: TextStyle(
                        //                           fontSize: 6.5.sp,
                        //                           color: Constants
                        //                               .bpOnBoardSubtitleStyle,
                        //                           fontFamily: 'Montserrat',
                        //                           fontWeight: FontWeight.w400),
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   setState(() {
                        //                     widget.isSaved = !widget.isSaved!;
                        //                   });
                        //                   savePostApi(widget.postId);
                        //                   resultMap = {"count": commentCount, "isSaved": widget.isSaved, "isLiked": widget.isLiked,
                        //                    "likeCount": widget.like, "index": widget.index};
                        //                 },
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.start,
                        //                   children: [
                        //                     ImageIcon(
                        //                         widget.isSaved!
                        //                             ? AssetImage('assets/icons/saveGreen.png')
                        //                             : AssetImage('assets/icons/saveNew.png'),
                        //                         color: widget.isSaved!
                        //                             ? Constants.selectedIcon
                        //                             : Constants.bpOnBoardSubtitleStyle,
                        //                         size: 21.0,
                        //                       ),
                        //                     SizedBox(
                        //                       width: 1.0.w,
                        //                     ),
                        //                     Container(
                        //                       padding:
                        //                           EdgeInsets.only(top: 1.0.h),
                        //                       child: Text(
                        //                         "Save",
                        //                         style: TextStyle(
                        //                             fontSize: 6.5.sp,
                        //                             color: Constants
                        //                                 .bpOnBoardSubtitleStyle,
                        //                             fontFamily: 'Montserrat',
                        //                             fontWeight: FontWeight.w400),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //Reaction dp
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     top: 3.0.h,
                        //     right: 4.0.w,
                        //     left: 4.0.w,
                        //   ),
                        //   child:
                        //       //Column(
                        //       //children: <Widget>[
                        //       Row(
                        //     children: [
                        //       Text(
                        //         'Reactions',
                        //         style: TextStyle(
                        //             fontSize: 12.0.sp,
                        //             color: Constants.bgColor,
                        //             fontFamily: 'Montserrat',
                        //             fontWeight: FontWeight.w500),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //       top: 0.0.h, right: 4.0.w, left: 4.0.w),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: Container(
                        //           height: 7.0.h,
                        //           child: ListView.builder(
                        //               physics: BouncingScrollPhysics(),
                        //               scrollDirection: Axis.horizontal,
                        //               itemCount: dpImages.length,
                        //               shrinkWrap: true,
                        //               itemBuilder: (context, index) {
                        //                 return Padding(
                        //                   padding: EdgeInsets.only(right: 3.0.w),
                        //                   child: ClipRRect(
                        //                     borderRadius:
                        //                         BorderRadius.circular(65),
                        //                     child: Image.asset(
                        //                       // index == 8
                        //                       // ? 'assets/icons/menu.png'
                        //                       // :
                        //                       dpImages[index],
                        //                       height: 4.5.h,
                        //                       width: 7.5.w,
                        //                       fit: BoxFit.contain,
                        //                     ),
                        //                   ),
                        //                 );
                        //               }),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        //comment list
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2.0.h, right: 4.0.w, left: 4.0.w),
                          child: Row(
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: Constants.bgColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            //scrollDirection: Axis.horizontal,
                            itemCount:
                                commentId.length == 0 ? 0 : commentId.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: 2.0.h, top: 1.0.h),
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 3.0.w),
                                  title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 28.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              getUserProfile(
                                                  commentUserId[index]);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl: profileImages[index]!,
                                                height: 35.0,
                                                width: 35.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.0.w,
                                        ),
                                        Container(
                                          //height: 7.0.h,
                                          width: 82.0.w,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0.w,
                                              vertical: 1.0.h),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Constants.formBorder
                                                    .withOpacity(0.6),
                                                width: 0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        name[index]!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 10.0.sp,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Constants
                                                                .bgColor),
                                                      ),
                                                      Text(
                                                        date[index]!
                                                            .substring(0, 9),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 7.0.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Constants
                                                                .bgColor),
                                                      ),
                                                    ],
                                                  ),
                                                  // Image.asset(
                                                  //   'assets/icons/menu.png',
                                                  //   height: 2.0.h,
                                                  //   width: 2.0.w,
                                                  //   fit: BoxFit.contain,
                                                  // )
                                                  userId.toString() ==
                                                          commentUserId[index]
                                                      ? PopupMenuButton(
                                                          color:
                                                              Color(0xFFF0F2F4),
                                                          elevation: 2.0,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.0.w),
                                                          icon: Icon(
                                                            Icons.more_vert,
                                                            color: Constants
                                                                .bpSkipStyle,
                                                            size: 20.0,
                                                          ),
                                                          onSelected: (dynamic
                                                              value) async {
                                                            if (value == 1) {
                                                              //Edit Comment API
                                                              setState(() {
                                                                isEdit = true;
                                                                idForEdit =
                                                                    commentId[
                                                                        index];
                                                                commentController
                                                                        .text =
                                                                    comments[
                                                                        index]!;
                                                                focusNode
                                                                    .requestFocus();
                                                              });
                                                            } else {
                                                              //Delete comment APi
                                                              await deleteCommentApi(
                                                                  commentId[
                                                                      index]);
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                                page = 1;
                                                                commentId = [];
                                                                commentUserId =
                                                                    [];
                                                                profileImages =
                                                                    [];
                                                                name = [];
                                                                date = [];
                                                                comments = [];
                                                              });
                                                              getCommentListApi(
                                                                  page);
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (context) => [
                                                                    PopupMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Edit",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                10.0.sp,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Constants.bgColor),
                                                                      ),
                                                                      value: 1,
                                                                    ),
                                                                    PopupMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Delete",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Montserrat',
                                                                            fontSize:
                                                                                10.0.sp,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Constants.bgColor),
                                                                      ),
                                                                      value: 2,
                                                                    )
                                                                  ])
                                                      : Container(),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0.5.h),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      //color: Colors.grey,
                                                      width: 77.0.w,
                                                      child: Text(
                                                        comments[index]!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 10.0.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Constants
                                                                .bpOnBoardSubtitleStyle),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            }),
                        //   ],
                        // ),
                        //),
                        SizedBox(
                          height: 5.0.h,
                        )
                      ],
                    ),
                  ),
                  //}),

                  //add comments
                  isEdit
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 4.0.h,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    //height: 7.0.h,
                                    width: 100.0.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Constants.formBorder
                                              .withOpacity(0.2),
                                          width: 3.0,
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.w,
                                      ),
                                      child: TextFormField(
                                          controller: commentController,
                                          focusNode: focusNode,
                                          keyboardType: TextInputType.multiline,
                                          maxLength: 140,
                                          cursorColor: Constants.bgColor,
                                          cursorHeight: 25.0,
                                          decoration: InputDecoration(
                                              //labelText: "Please mention your achivements...",
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.0.w,
                                                    vertical: 1.0.h),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl!,
                                                    width: 3.0.w,
                                                    height: 1.0.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.0.w),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await editCommentApi(
                                                        idForEdit);
                                                    setState(() {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      commentController.text =
                                                          '';
                                                      isLoading = true;
                                                      page = 1;
                                                      commentId = [];
                                                      commentUserId = [];
                                                      profileImages = [];
                                                      name = [];
                                                      date = [];
                                                      comments = [];
                                                    });
                                                    getCommentListApi(page);
                                                  },
                                                  child: Text('Post',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 12.0.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Constants
                                                              .bgColor)),
                                                ),
                                              ),
                                              counterText: '',
                                              fillColor: Colors.white,
                                              hintText:
                                                  "Leave your thoughts here...",
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none),
                                          style: new TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 10.0.sp,
                                              color: Constants.bgColor)),
                                    ))
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 4.0.h,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    //height: 7.0.h,
                                    width: 100.0.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Constants.formBorder
                                              .withOpacity(0.2),
                                          width: 3.0,
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.w,
                                      ),
                                      child: TextFormField(
                                          controller: commentController,
                                          keyboardType: TextInputType.multiline,
                                          maxLength: 140,
                                          cursorColor: Constants.bgColor,
                                          //cursorHeight: 25.0,
                                          decoration: InputDecoration(
                                              //labelText: "Please mention your achivements...",
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.0.w,
                                                    vertical: 1.0.h),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl!,
                                                    width: 3.0.w,
                                                    height: 1.0.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.0.w),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    await comment.addCommentApi(
                                                        widget.postId,
                                                        commentController.text,
                                                        authToken!);
                                                    setState(() {
                                                      commentCount =
                                                          comment.commentCount;
                                                      resultMap = {
                                                        "count": commentCount,
                                                        "index": widget.index,
                                                        "isLiked":
                                                            widget.isLiked,
                                                        "isSaved":
                                                            widget.isSaved,
                                                        "likeCount": widget.like
                                                      };
                                                      focusNode.unfocus();
                                                      commentController.text =
                                                          '';
                                                      isLoading = true;
                                                      page = 1;
                                                      commentId = [];
                                                      commentUserId = [];
                                                      profileImages = [];
                                                      name = [];
                                                      date = [];
                                                      comments = [];
                                                    });
                                                    getCommentListApi(page);
                                                  },
                                                  child: Text('Post',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 12.0.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Constants
                                                              .bgColor)),
                                                ),
                                              ),
                                              counterText: '',
                                              fillColor: Colors.white,
                                              hintText:
                                                  "Leave your thoughts here...",
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none),
                                          style: new TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 10.0.sp,
                                              color: Constants.bgColor)),
                                    ))
                              ],
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }

  //Get Comment LIst API
  Future<void> getCommentListApi(int page) async {
    try {
      Dio dio = Dio();
      var response = await dio
          .get('${Config.getCommentListUrl}${widget.postId}?page=$page');
      //commentList = GetCommentList.fromJson(response.data);
      commentMap = response.data;
      commentMapData = commentMap!['data'];

      if (response.statusCode == 200) {
        if (commentMap!['status'] == true) {
          setState(() {
            isLoading = false;
          });

          if (commentMapData!.length > 0) {
            //print(commentMap);
            for (int i = 0; i < commentMapData!.length; i++) {
              commentId.add(commentMapData![i]['comment_id']);
              commentUserId.add(commentMapData![i]['comment_user_id']);
              profileImages.add(commentMapData![i]['profile_image']);
              name.add(commentMapData![i]['name']);
              date.add(commentMapData![i]['date']);
              comments.add(commentMapData![i]['comment']);
            }
            //print(name);
            isLoading = false;

            setState(() {});
          } else {
            isLoading = false;

            setState(() {});
          }
        } else {
          Fluttertoast.showToast(
              msg: commentMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        }
      } else {
        //print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
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
    //return commentList;
  }

//Delete Comment API
  Future<void> deleteCommentApi(int? commentId) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'comment_id': commentId});
      var response = await dio.post(Config.deleteCommentUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        delMap = response.data;

        if (delMap!['status'] == true) {
          //print('true');
          //print(delMap);
          Fluttertoast.showToast(
              msg: delMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          //print('false');
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
        //print(delMap);
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

  //Edit Comment API
  Future<void> editCommentApi(int? commentId) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap(
          {'comment_id': commentId, 'comment': commentController.text});
      var response = await dio.post(Config.editCommentUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        editMap = response.data;

        if (editMap!['status'] == true) {
          //print('true');
          //print(editMap);
          isEdit = false;
          setState(() {});
          Fluttertoast.showToast(
              msg: editMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          //print('false');
          if (editMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: editMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: editMap!['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
        //getEducatorPostApi(page);
        //print(editMap);
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
      // print(stack);
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
        //print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      //print(e.response);
      //print(stack);
    }
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    Navigator.pop(context, resultMap);
    //print('CCC###'+resultMap.toString());
    // then
    return true; // return true if the route to be popped
  }
}
