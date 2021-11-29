import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class CommentScreen extends StatefulWidget {
  String name, profileImage, degree, schoolName, date, description;
  int postId, like, comment, index;
  bool isLiked, isSaved;
  Map<int, dynamic> imageListMap;
  CommentScreen(
      {Key key,
      this.postId,
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
      this.index})
      : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<String> dpImages = [];
  List<String> profileImages = [];
  List<String> name = [];
  List<String> date = [];
  List<String> comments = [];
  List<int> commentId = [];
  List<String> commentUserId = [];
  TextEditingController commentController = TextEditingController();
  CommentAPI comment = CommentAPI();
  //GetCommentList commentList = GetCommentList();
  String authToken;
  int page = 1;
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();
  int k = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String imageUrl;
  Map<String, dynamic> commentMap;
  List<dynamic> commentMapData;
  int userId;
  Map<String, dynamic> delMap;
  Map<String, dynamic> editMap;
  bool isEdit = false;
  FocusNode focusNode = FocusNode();
  int idForEdit;
  LikePostAPI like = LikePostAPI();
  Map<String, dynamic> saveMap;

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
    print(authToken);
    getData();
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
          if (commentMapData.length > 0) {
            page++;
            getCommentListApi(page);
            print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getCommentListApi(page);
          print(page);
        }
      }
    });
  }

  void _onLoading() async {
    //if (mounted) setState(() {});
    if (commentMapData.length == 0) {
      //_refreshController.loadComplete();
      _refreshController.loadNoData();
    } else {
      _refreshController.requestLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.of(context).pop();
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
                      //main horizontal paddingF
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                        //Container for one post
                        child: Container(
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
                                        widget.profileImage,
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
                                            widget.name,
                                            style: TextStyle(
                                                fontSize: 9.0.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            '${widget.degree} | ${widget.schoolName}',
                                            style: TextStyle(
                                                fontSize: 6.5.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            widget.date,
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
                                trailing: IconButton(
                                     icon: Image.asset('assets/icons/issueIcon.png',
                                      height: 20.0,
                                      width: 20.0,),
                                    onPressed: () {
                                      pushNewScreen(context,
                                          withNavBar: false,
                                          screen: ReportFeed(
                                            postId: widget.postId,
                                          ),
                                          pageTransitionAnimation:
                                              PageTransitionAnimation
                                                  .cupertino);
                                    }),
                                //ImageIcon(AssetImage('assets/icons/report.png'),)
                              ),
                              //Post descriptionText
                              Container(
                                width: 88.0.w,
                                child: Text(widget.description,
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
                              widget.imageListMap[widget.index].length == 0
                                  ? Container()
                                  : Container(
                                      height: 25.0.h,
                                      width: 100.0.w,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget
                                            .imageListMap[widget.index].length,
                                        itemBuilder: (context, imageIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              widget.imageListMap[widget.index]
                                                  [imageIndex]['file'],
                                              height: 100,
                                              width: 250,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              //Row for Liked, commented, shared
                              Padding(
                                padding: EdgeInsets.only(top: 1.0.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        ImageIcon(
                                          AssetImage('assets/icons/likeNew.png'),
                                          size: 25.0,
                                          color: Constants.bgColor,
                                        ),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 1.0.h),
                                          child: Text(
                                            "${widget.like} Likes",
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
                                        "${widget.comment} Comments",
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
                                          widget.isLiked = !widget.isLiked;
                                        });
                                        like.likePostApi(widget.postId, authToken);
                                        setState(() {
                                          widget.isLiked == true
                                              ? widget.like++
                                              : widget.like--;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                         ImageIcon(
                                              widget.isLiked
                                                  ? AssetImage('assets/icons/likeThumb.png')
                                                  : AssetImage('assets/icons/likeThumb.png'),
                                              color: widget.isLiked
                                                  ? Constants.selectedIcon
                                                  : Constants.bpOnBoardSubtitleStyle,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ImageIcon(
                                              AssetImage('assets/icons/commentNew.png'),
                                              size: 25.0,
                                              color: Constants.bpOnBoardSubtitleStyle,
                                            ),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 1.0.h),
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
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          widget.isSaved = !widget.isSaved;
                                        });
                                        savePostApi(widget.postId);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ImageIcon(
                                              widget.isSaved
                                                  ? AssetImage('assets/icons/saveGreen.png')
                                                  : AssetImage('assets/icons/saveNew.png'),
                                              color: widget.isSaved
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 28.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            profileImages[index],
                                            height: 4.5.h,
                                            width: 7.5.w,
                                            fit: BoxFit.cover,
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
                                            horizontal: 2.0.w, vertical: 1.0.h),
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
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      name[index],
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
                                                      date[index],
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
                                                        onSelected:
                                                            (value) async {
                                                          if (value == 1) {
                                                            //Edit Comment API
                                                            setState(() {
                                                              isEdit = true;
                                                              idForEdit = commentId[index];
                                                              commentController.text = comments[index];
                                                              focusNode.requestFocus();
                                                            });
                                                          } else {
                                                            //Delete comment APi
                                                            await deleteCommentApi(commentId[index]);
                                                            setState(() {
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
                                                          }
                                                        },
                                                        itemBuilder:
                                                            (context) => [
                                                                  PopupMenuItem(
                                                                    child: Text(
                                                                      "Edit",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Constants.bgColor),
                                                                    ),
                                                                    value: 1,
                                                                  ),
                                                                  PopupMenuItem(
                                                                    child: Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          fontSize: 10.0
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color:
                                                                              Constants.formBorder),
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
                                                      comments[index],
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
                                  color: Constants.formBorder.withOpacity(0.2),
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
                                            horizontal: 2.0.w, vertical: 1.0.h),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            imageUrl,
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
                                          onPressed: () async{
                                            await editCommentApi(idForEdit);
                                            setState(() {
                                              FocusScope.of(context).unfocus();
                                              commentController.text = '';
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
                                          child: Text('Edit',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Constants.formBorder)),
                                        ),
                                      ),
                                      counterText: '',
                                      fillColor: Colors.white,
                                      hintText: "Leave your thoughts here...",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none),
                                  style: new TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 10.0.sp,
                                      color: Constants.formBorder)),
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
                            height: 7.0.h,
                            width: 100.0.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Constants.formBorder.withOpacity(0.2),
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
                                  cursorHeight: 25.0,
                                  decoration: InputDecoration(
                                      //labelText: "Please mention your achivements...",
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0.w, vertical: 1.0.h),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            imageUrl,
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
                                          onPressed: () async{
                                            await comment.addCommentApi(
                                                widget.postId,
                                                commentController.text,
                                                authToken);
                                            setState(() {
                                              focusNode.unfocus();
                                              commentController.text = '';
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
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Constants.formBorder)),
                                        ),
                                      ),
                                      counterText: '',
                                      fillColor: Colors.white,
                                      hintText: "Leave your thoughts here...",
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none),
                                  style: new TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 10.0.sp,
                                      color: Constants.formBorder)),
                            ))
                      ],
                    ),
                  ],
                ),
              ],
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
      commentMapData = commentMap['data'];

      if (response.statusCode == 200) {
        if (commentMap['status'] == true) {
          setState(() {
            isLoading = false;
          });

          if (commentMapData.length > 0) {
            print(commentMap);
            for (int i = 0; i < commentMapData.length; i++) {
              commentId.add(commentMapData[i]['comment_id']);
              commentUserId.add(commentMapData[i]['comment_user_id']);
              profileImages.add(commentMapData[i]['profile_image']);
              name.add(commentMapData[i]['name']);
              date.add(commentMapData[i]['date']);
              comments.add(commentMapData[i]['comment']);
            }
            print(name);
            isLoading = false;

            setState(() {});
          } else {
            isLoading = false;

            setState(() {});
          }
        } else {
          Fluttertoast.showToast(
              msg: commentMap['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        }
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
    //return commentList;
  }

//Delete Comment API
  Future<void> deleteCommentApi(int commentId) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'comment_id': commentId});
      var response = await dio.post(Config.deleteCommentUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        delMap = response.data;

        if (delMap['status'] == true) {
          print('true');
          print(delMap);
          Fluttertoast.showToast(
              msg: delMap['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
          if (delMap['message'] == null) {
            Fluttertoast.showToast(
                msg: delMap['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: delMap['message'],
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

  //Edit Comment API
  Future<void> editCommentApi(int commentId) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'comment_id': commentId, 'comment': commentController.text});
      var response = await dio.post(Config.editCommentUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        editMap = response.data;

        if (editMap['status'] == true) {
          print('true');
          print(editMap);
          isEdit = false;
          setState((){});
          Fluttertoast.showToast(
              msg: editMap['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
          if (editMap['message'] == null) {
            Fluttertoast.showToast(
                msg: editMap['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: editMap['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
        //getEducatorPostApi(page);
        print(editMap);
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
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        saveMap = response.data;
        //saveMapData = map['data']['status'];

        print(saveMap);
        // setState(() {
        //   isLoading = false;
        // });
        if (saveMap['status'] == true) {
          print('true');
          //getEducatorPostApi(page);
          Fluttertoast.showToast(
              msg: saveMap['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
          if (saveMap['message'] == null) {
            Fluttertoast.showToast(
                msg: saveMap['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: saveMap['message'],
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
