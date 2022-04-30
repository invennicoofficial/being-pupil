import 'package:being_pupil/Account/My_Course/Get_Educator_Course_Screen.dart';
import 'package:being_pupil/ConnectyCube/chat_dialog_screen.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Fulll_Screen_Image_Screen.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Learner/Connection_API.dart';
import 'package:being_pupil/Learner/Connection_List_Learner.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Educator_Post_Model.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/Subscription/Subscription_Plan_Screen.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  int? userId;
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
  ConnectionAPI connect = ConnectionAPI();
  Map<String, dynamic>? unfollowMap;
  //SimpleAccountMenu menu = SimpleAccountMenu();
  bool isSelected = false;
  Map<String, dynamic> resultComment = {};
  int? isSubscribed;

  @override
  void initState() {
    //print(widget.id);
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    //print(authToken);
    getData();
    getUserProfile(widget.id);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map!['data'].length > 0) {
            page++;
            getEducatorPostApi(page);
            //print(page);
          }
        } else {
          page++;
          getEducatorPostApi(page);
          //print(page);
        }
      }
    });
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isSubscribed = preferences.getInt('isSubscribed');
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constants.bgColor),
              ),
            )
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  isSelected = false;
                });
              },
              child: Column(
                //shrinkWrap: true,
                //physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    // height: 80.0.h,
                    width: 100.0.w,
                    //color: Colors.grey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0.h, horizontal: 4.0.w),
                      child: Column(
                        children: <Widget>[
                          //Profile DP
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              profileImageUrl!,
                              width: 130,
                              height: 130,
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
                                Visibility(
                                  visible: profileMap!['data']
                                              ['facebook_link'] ==
                                          null
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      //print('Facebook!!!');
                                      _launchSocialUrl(
                                          profileMap!['data']['facebook_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/fbSvg.svg')
                                        // Image.asset(
                                        //   'assets/icons/facebook.png',
                                        //   fit: BoxFit.contain,
                                        // )
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: profileMap!['data']['facebook_link'] ==
                                          null
                                      ? 0.0
                                      : 2.0.w,
                                ),
                                Visibility(
                                  visible: profileMap!['data']
                                              ['instagram_link'] ==
                                          null
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      //print('Instagram!!!');
                                      _launchSocialUrl(profileMap!['data']
                                          ['instagram_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/instaSvg.svg')
                                        // Image.asset(
                                        //   'assets/icons/instagram.png',
                                        //   fit: BoxFit.contain,
                                        // )
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: profileMap!['data']
                                              ['instagram_link'] ==
                                          null
                                      ? 0.0
                                      : 2.0.w,
                                ),
                                Visibility(
                                  visible: profileMap!['data']
                                              ['linkedin_link'] ==
                                          null
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      //print('LinkedIn!!!');
                                      _launchSocialUrl(
                                          profileMap!['data']['linkedin_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/linkedinSvg.svg')
                                        // Image.asset(
                                        //   'assets/icons/linkedin.png',
                                        //   fit: BoxFit.contain,
                                        // )
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: profileMap!['data']['linkedin_link'] ==
                                          null
                                      ? 0.0
                                      : 2.0.w,
                                ),
                                Visibility(
                                  visible:
                                      profileMap!['data']['other_link'] == null
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      //print('Other!!!');
                                      _launchSocialUrl(
                                          profileMap!['data']['other_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/otherSvg.svg')
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
                          //Buttons
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                profileMap!['data']['is_connected'] == 0
                                    ? GestureDetector(
                                        onTap: () async {
                                          isSubscribed == 1
                                              ? await connect.connectionApi(
                                                  profileMap!['data']
                                                      ['user_id'],
                                                  authToken!)
                                              : pushNewScreen(context,
                                                  screen:
                                                      SubscriptionPlanScreen(),
                                                  withNavBar: false,
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino);
                                          ;
                                        },
                                        child: Container(
                                          height: 4.5.h,
                                          width: 35.0.w,
                                          decoration: BoxDecoration(
                                              color: Constants.bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          child: Center(
                                            child: Text(
                                              //  connect.status == true
                                              // ? 'Request Sent' :
                                              'CONNECT',
                                              style: TextStyle(
                                                  fontSize: 10.0.sp,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 4.5.h,
                                        width: 35.0.w,
                                        decoration: BoxDecoration(
                                            color: Constants.bgColor,
                                            borderRadius:
                                                BorderRadius.circular(25.0)),
                                        child: GestureDetector(
                                          onTap: () async {
                                            displayProgressDialog(context);
                                            SharedPrefs sharedPrefs =
                                                await SharedPrefs.instance
                                                    .init();
                                            CubeUser? user =
                                                sharedPrefs.getUser();
                                            //print(profileMap!['data']['email']);
                                            getUserByEmail(profileMap!['data']
                                                    ['email'])
                                                .then((cubeUser) {
                                              CubeDialog newDialog = CubeDialog(
                                                  CubeDialogType.PRIVATE,
                                                  occupantsIds: [
                                                    cubeUser!.id!
                                                  ]);
                                              createDialog(newDialog)
                                                  .then((createdDialog) {
                                                closeProgressDialog(context);
                                                pushNewScreen(context,
                                                    screen: ChatDialogScreen(
                                                        user,
                                                        createdDialog,
                                                        profileImageUrl),
                                                    withNavBar: false,
                                                    pageTransitionAnimation:
                                                        PageTransitionAnimation
                                                            .cupertino);
                                              }).catchError((error) {
                                                // displayProgressDialog(context);
                                              });
                                            }).catchError((error) {
                                              // displayProgressDialog(context);
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20.0.w,
                                                height: 3.5.h,
                                                child: Center(
                                                  child: Text(
                                                    'CHAT',
                                                    style: TextStyle(
                                                        fontSize: 10.0.sp,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              //             SimpleAccountMenu(
                                              //           text: [
                                              //             Text('Unfollow',
                                              //                   style: TextStyle(
                                              //                       fontSize: 11.0.sp,
                                              //                       fontFamily: 'Montserrat',
                                              //                       fontWeight: FontWeight.w400,
                                              //                       color: Constants.bgColor),
                                              //                 ),
                                              //       ],
                                              //     iconColor: Colors.white,
                                              //     onChange: (index) {
                                              //     //print(index);
                                              //     unfollowUser(userId!);
                                              //    },
                                              //),
                                              IconButton(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2.0),
                                                  onPressed: () {
                                                    //unfollowUser(userId!);
                                                    setState(() {
                                                      isSelected = !isSelected;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    isSelected
                                                        ? Icons
                                                            .expand_less_outlined
                                                        : Icons
                                                            .expand_more_outlined,
                                                    color: Colors.white,
                                                    size: 25.0,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                GestureDetector(
                                  onTap: () {
                                    //print('COURSES!!!');
                                    pushNewScreen(context,
                                        screen: GetEducatorCourseScreen(
                                          userId: widget.id,
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino);
                                  },
                                  child: Container(
                                    height: 4.5.h,
                                    width: 35.0.w,
                                    decoration: BoxDecoration(
                                        color: Constants.bgColor,
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
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
                          profileMap!['data'] == null ||
                                  profileMap!['data'] == {}
                              ? Container()
                              : Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 2.0.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isSelected
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0, bottom: 10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isSelected = false;
                                                  });
                                                  unfollowUser(userId!);
                                                },
                                                child: Card(
                                                  child: Container(
                                                    height: 4.0.h,
                                                    width: 30.0.w,
                                                    child: Center(
                                                      child: Text(
                                                        'Unfollow',
                                                        style: TextStyle(
                                                            fontSize: 11.0.sp,
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Constants
                                                                .bgColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                profileMap!['data']
                                                        ['total_experience']
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
                                                profileMap!['data']
                                                        ['total_post']
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
                                                profileMap!['data']
                                                        ['total_connections']
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
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0.h, horizontal: 5.0.w),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
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
                                              padding:
                                                  EdgeInsets.only(top: 1.0.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name!,
                                                    style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color:
                                                            Constants.bgColor,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(height: 1.0),
                                                  Text(
                                                    '$degreeName | $schoolName',
                                                    style: TextStyle(
                                                        fontSize: 6.5.sp,
                                                        color:
                                                            Constants.bgColor,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(height: 1.0),
                                                  Text(
                                                    dateList[index]!
                                                        .substring(0, 11),
                                                    style: TextStyle(
                                                        fontSize: 6.5.sp,
                                                        color:
                                                            Constants.bgColor,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                            icon: SvgPicture.asset(
                                                'assets/icons/reportSvg.svg'),
                                            //  Image.asset('assets/icons/issueIcon.png',
                                            //   height: 18.0,
                                            //   width: 18.0,),
                                            onPressed: () {
                                              pushNewScreen(context,
                                                  withNavBar: false,
                                                  screen: ReportFeed(
                                                    postId: postIdList[index],
                                                  ),
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino);
                                            })),
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
                                            color: Constants
                                                .bpOnBoardSubtitleStyle,
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
                                              itemCount:
                                                  imageListMap[index].length,
                                              itemBuilder:
                                                  (context, imageIndex) {
                                                return imageListMap[index]
                                                            .length ==
                                                        1
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    15.0.w),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            List<String>
                                                                imgList = [];
                                                            for (int i = 0;
                                                                i <
                                                                    imageListMap[
                                                                            index]
                                                                        .length;
                                                                i++) {
                                                              imgList.add(
                                                                  imageListMap[
                                                                          index]
                                                                      [
                                                                      i]['file']);
                                                            }
                                                            pushNewScreen(
                                                                context,
                                                                withNavBar:
                                                                    false,
                                                                screen: FullScreenSlider(
                                                                    imageList:
                                                                        imgList,
                                                                    index:
                                                                        imageIndex,
                                                                    name: nameList[
                                                                        index]!),
                                                                pageTransitionAnimation:
                                                                    PageTransitionAnimation
                                                                        .cupertino);
                                                          },
                                                          child: Image.network(
                                                            imageListMap[index]
                                                                    [imageIndex]
                                                                ['file'],
                                                            height: 100,
                                                            width: 250,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            List<String>
                                                                imgList = [];
                                                            for (int i = 0;
                                                                i <
                                                                    imageListMap[
                                                                            index]
                                                                        .length;
                                                                i++) {
                                                              imgList.add(
                                                                  imageListMap[
                                                                          index]
                                                                      [
                                                                      i]['file']);
                                                            }
                                                            pushNewScreen(
                                                                context,
                                                                withNavBar:
                                                                    false,
                                                                screen: FullScreenSlider(
                                                                    imageList:
                                                                        imgList,
                                                                    index:
                                                                        imageIndex,
                                                                    name: nameList[
                                                                        index]!),
                                                                pageTransitionAnimation:
                                                                    PageTransitionAnimation
                                                                        .cupertino);
                                                          },
                                                          child: Image.network(
                                                            imageListMap[index]
                                                                    [imageIndex]
                                                                ['file'],
                                                            height: 100,
                                                            width: 250,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      );
                                              },
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
                                      padding: EdgeInsets.only(
                                          top: 0.5.h, bottom: 0.5.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isLiked[index] =
                                                    !isLiked[index]!;
                                              });
                                              like.likePostApi(
                                                  postIdList[index],
                                                  authToken!);
                                              setState(() {
                                                isLiked[index] == true
                                                    ? likesList[index] = likesList[index]! + 1
                                                    : likesList[index] = likesList[index]! - 1;
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
                                                  width: 1.0.w,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: 1.0.h),
                                                  child: Text(
                                                    "${likesList[index]} Likes",
                                                    style: TextStyle(
                                                        fontSize: 6.5.sp,
                                                        color: Constants
                                                            .bpOnBoardSubtitleStyle,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              resultComment = await Navigator
                                                      .of(context,
                                                          rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentScreen(
                                                            postId: postIdList[
                                                                index],
                                                            name:
                                                                nameList[index],
                                                            profileImage:
                                                                profileImageList[
                                                                    index],
                                                            degree: degreeList[
                                                                index],
                                                            schoolName:
                                                                schoolList[
                                                                    index],
                                                            date:
                                                                dateList[index],
                                                            description:
                                                                descriptionList[
                                                                    index],
                                                            like: likesList[
                                                                index],
                                                            comment:
                                                                totalCommentsList[
                                                                    index],
                                                            isLiked:
                                                                isLiked[index],
                                                            isSaved:
                                                                isSaved[index],
                                                            imageListMap:
                                                                imageListMap,
                                                            index: index,
                                                          )));

                                              setState(() {});

                                          totalCommentsList[resultComment['index']] = resultComment['count'];
                                          likesList[resultComment['index']] = resultComment['likeCount']; 
                                          isSaved[resultComment['index']] = resultComment['isSaved'];
                                          isLiked[resultComment['index']] = resultComment['isLiked'];
                                              //print('TC###' +
                                                  // totalCommentsList[
                                                  //         resultComment[
                                                  //             'index']]
                                                  //     .toString());
                                              setState(() {});

                                              // pushNewScreen(context,
                                              //     withNavBar: false,
                                              //     screen: CommentScreen(
                                              //       postId: postIdList[index],
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
                                              //     PageTransitionAnimation
                                              //         .cupertino);
                                            },
                                            child: Container(
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
                                                    padding: EdgeInsets.only(
                                                        top: 1.0.h),
                                                    child: Text(
                                                      //  resultComment['index'] == index
                                                      // ? "${resultComment['count']} Comments"
                                                      // :
                                                      "${totalCommentsList[index]} Comments",
                                                      style: TextStyle(
                                                          fontSize: 6.5.sp,
                                                          color: Constants
                                                              .bpOnBoardSubtitleStyle,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w400),
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
                                                isSaved[index] =
                                                    !isSaved[index]!;
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
                                                    padding: EdgeInsets.only(
                                                        top: 1.0.h),
                                                    child: Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          fontSize: 6.5.sp,
                                                          color: Constants
                                                              .bpOnBoardSubtitleStyle,
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w400),
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
            ),
    );
  }

//Get Educator's all Post
  Future<void> getEducatorPostApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get(
          '${Config.getEducatorPostUrl}/${widget.id}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      //print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map!['data'];

        //print(map);
        //print(mapData);
        if (map!['data'].length > 0) {
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

  Future<void> getUserProfile(id) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      //print(response.statusCode);

      if (response.statusCode == 200) {
        profileMap = response.data;

        //print(profileMap!['data']);
        ////print(mapData);
        if (profileMap!['data'] != null) {
          userId = int.parse(profileMap!['data']['user_id'].toString());
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
        ////print(result.data);
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

  //Unfollow user API
  Future<void> unfollowUser(int userId) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'disconnect_user_id': userId});

      var response = await dio.post(Config.unfollowUserUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        unfollowMap = response.data;
        //print(unfollowMap);

        if (unfollowMap!['status'] == true) {
          profileMap!['data']['is_connected'] = 0;
          setState(() {});
          Fluttertoast.showToast(
              msg: unfollowMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          Fluttertoast.showToast(
              msg: unfollowMap!['message'] == null
                  ? unfollowMap!['err_msg']
                  : unfollowMap!['message'],
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

  displayProgressDialog(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new ProgressDialog1();
          }));
    });
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
