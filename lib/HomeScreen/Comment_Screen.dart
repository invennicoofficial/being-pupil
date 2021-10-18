import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
  List<String> names = [];
  List<String> comments = [];
  TextEditingController commentController = TextEditingController();
  CommentAPI comment = CommentAPI();
  String authToken;
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
    names = ['Marilyn Brewer', 'Marilyn Brewer'];
    comments = [
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod',
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod'
    ];
    getToken();
    super.initState();
  }
  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
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
      body: Stack(
        children: <Widget>[
          // ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       return
          ListView(
            physics: BouncingScrollPhysics(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            icon: Icon(Icons.report_gmailerrorred_outlined),
                            onPressed: () {
                              pushNewScreen(context,
                                  withNavBar: false,
                                  screen: ReportFeed(
                                    postId: widget.postId,
                                  ),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
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
                                itemCount:
                                    widget.imageListMap[widget.index].length,
                                itemBuilder: (context, imageIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      widget.imageListMap[widget.index]
                                          [imageIndex]['file'],
                                      height: 100,
                                      width: 250,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              ),
                            ),
                      //Row for Liked, commented, shared
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    "${widget.like} Likes",
                                    style: TextStyle(
                                        fontSize: 6.5.sp,
                                        color: Constants.bpOnBoardSubtitleStyle,
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
                                    color: Constants.bpOnBoardSubtitleStyle,
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
                        color:
                            Constants.bpOnBoardSubtitleStyle.withOpacity(0.5),
                        thickness: 1.0,
                      ),
                      //Row for Like comment and Share
                      Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.isLiked = !widget.isLiked;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    widget.isLiked
                                        ? Icons.thumb_up_sharp
                                        : Icons.thumb_up_outlined,
                                    color: widget.isLiked
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
                                      "Like",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.comment_outlined,
                                  color: Constants.bpOnBoardSubtitleStyle,
                                  size: 30.0,
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
                                        color: Constants.bpOnBoardSubtitleStyle,
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
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    widget.isSaved
                                        ? Icons.bookmark_sharp
                                        : Icons.bookmark_outline_outlined,
                                    color: widget.isSaved
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
                                      "Save",
                                      style: TextStyle(
                                          fontSize: 6.5.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
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
              Padding(
                padding: EdgeInsets.only(
                  top: 3.0.h,
                  right: 4.0.w,
                  left: 4.0.w,
                ),
                child:
                    //Column(
                    //children: <Widget>[
                    Row(
                  children: [
                    Text(
                      'Reactions',
                      style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Constants.bgColor,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.0.h, right: 4.0.w, left: 4.0.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 7.0.h,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: dpImages.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(right: 3.0.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(65),
                                  child: Image.asset(
                                    // index == 8
                                    // ? 'assets/icons/menu.png'
                                    // :
                                    dpImages[index],
                                    height: 4.5.h,
                                    width: 7.5.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),

              //comment list
              Padding(
                padding: EdgeInsets.only(top: 2.0.h, right: 4.0.w, left: 4.0.w),
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
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.0.h, top: 1.0.h),
                      child: ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 28.0),
                                child: ClipRRect(
                                  child: Image.asset(
                                    dpImages[index],
                                    height: 4.5.h,
                                    width: 7.5.w,
                                    fit: BoxFit.contain,
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
                                      color:
                                          Constants.formBorder.withOpacity(0.6),
                                      width: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              names[index],
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Constants.bgColor),
                                            ),
                                            Text(
                                              '28 Jun 2021',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 7.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Constants.bgColor),
                                            ),
                                          ],
                                        ),
                                        // Image.asset(
                                        //   'assets/icons/menu.png',
                                        //   height: 2.0.h,
                                        //   width: 2.0.w,
                                        //   fit: BoxFit.contain,
                                        // )
                                        PopupMenuButton(
                                            color: Color(0xFFF0F2F4),
                                            elevation: 2.0,
                                            padding:
                                                EdgeInsets.only(left: 8.0.w),
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Constants.bpSkipStyle,
                                            ),
                                            onSelected: (value) {
                                              Fluttertoast.showToast(
                                                  msg: value == 1
                                                      ? 'Edit Post'
                                                      : 'Delete Post',
                                                  backgroundColor:
                                                      Constants.bgColor,
                                                  gravity: ToastGravity.BOTTOM,
                                                  fontSize: 10.0.sp,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  textColor: Colors.white);
                                            },
                                            itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    child: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 10.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Constants
                                                              .bgColor),
                                                    ),
                                                    value: 1,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 10.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Constants
                                                              .formBorder),
                                                    ),
                                                    value: 2,
                                                  )
                                                ]),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0.5.h),
                                      child: Text(
                                        comments[index],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Constants
                                                .bpOnBoardSubtitleStyle),
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
          //}),

          //add comments
          Column(
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
                                      horizontal: 0.0.w, vertical: 1.0.h),
                                  child: Image.asset(
                                    'assets/images/dp2.png',
                                    height: 4.5.h,
                                    width: 7.5.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.0.w),
                                  child: TextButton(
                                    onPressed: (){
                                      comment.addCommentApi(widget.postId, commentController.text, authToken);
                                      setState(() {
                                        FocusScope.of(context).unfocus();
                                        commentController.text = '';
                                      });
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
}
