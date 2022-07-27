import 'package:being_pupil/Account/My_Profile/Edit_Profile_Educator.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Comment_Screen.dart';
import 'package:being_pupil/HomeScreen/Fulll_Screen_Image_Screen.dart';
import 'package:being_pupil/HomeScreen/Update_Post_Screen.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/MyProfile_Model.dart';
import 'package:being_pupil/Model/Post_Model/Educator_Post_Model.dart';
import 'package:being_pupil/Model/Post_Model/Post_Global_API_Class.dart';
import 'package:being_pupil/Widgets/Post_Widget.dart';
import 'package:being_pupil/Widgets/Shimmer_Widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  String? registerAs, qualification, school;
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
  List<String?> durationList = [];
  List<String?> cityList = [];
  List<String?> commentTextList = [];
  List<String?> mutualList = [];
  List<String?> commentProfile = [];

  String? authToken;
  int? userId;
  MyProfile? profileResult;
  SavePostAPI save = SavePostAPI();
  Map<String, dynamic>? myProfileMap;
  bool isProfileLoading = true;
  LikePostAPI like = LikePostAPI();
  String? socialUrl;
  Map<String, dynamic> resultComment = {};
  List<int> _current = [];
  final CarouselController _controller = CarouselController();
  bool _isCreatingLink = false;
  var dLink = CreateDynamicLink();

  @override
  void initState() {
    getToken();

    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      userId = preferences.getInt('userId');
      qualification = preferences.getString('qualification');
      school = preferences.getString('schoolName');
    });

    getMyProfileApi();
    getMyPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map!['data'].length > 0) {
            page++;
            getMyPostApi(page);
          }
        } else {
          page++;
          getMyPostApi(page);
        }
      }
    });
  }

  void _launchSocialUrl(String url) async {
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
          onPressed: () {
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
              children: <Widget>[
                Container(
                  width: 100.0.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2.0.h, horizontal: 4.0.w),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: myProfileMap!['data']['profile_image'],
                            width: 90.0,
                            height: 90.0,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Text(
                            '$qualification | $school ',
                            style: TextStyle(
                                fontSize: 8.0.sp,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                color: Constants.bgColor),
                          ),
                        ),
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
                                    _launchSocialUrl(
                                        myProfileMap!['data']['facebook_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset(
                                          'assets/icons/fbSvg.svg')),
                                ),
                              ),
                              SizedBox(
                                width: myProfileMap!['data']['facebook_link'] ==
                                        null
                                    ? 0.0
                                    : 2.0.w,
                              ),
                              Visibility(
                                visible: myProfileMap!['data']
                                            ['instagram_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    _launchSocialUrl(myProfileMap!['data']
                                        ['instagram_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset(
                                          'assets/icons/instaSvg.svg')),
                                ),
                              ),
                              SizedBox(
                                width: myProfileMap!['data']
                                            ['instagram_link'] ==
                                        null
                                    ? 0.0
                                    : 2.0.w,
                              ),
                              Visibility(
                                visible: myProfileMap!['data']
                                            ['linkedin_link'] ==
                                        null
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    _launchSocialUrl(
                                        myProfileMap!['data']['linkedin_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset(
                                          'assets/icons/linkedinSvg.svg')),
                                ),
                              ),
                              SizedBox(
                                width: myProfileMap!['data']['linkedin_link'] ==
                                        null
                                    ? 0.0
                                    : 2.0.w,
                              ),
                              Visibility(
                                visible:
                                    myProfileMap!['data']['other_link'] == null
                                        ? false
                                        : true,
                                child: GestureDetector(
                                  onTap: () {
                                    _launchSocialUrl(
                                        myProfileMap!['data']['other_link']);
                                  },
                                  child: Container(
                                      height: 4.0.h,
                                      width: 8.0.w,
                                      child: SvgPicture.asset(
                                          'assets/icons/otherSvg.svg')),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                Divider(
                  height: 1.0.h,
                  color: Constants.bgColor.withOpacity(0.5),
                ),
                postIdList.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50.0,
                            ),
                            Image.asset('assets/images/noBooking.png',
                                height: 200, width: 200, fit: BoxFit.contain),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              'Post Not Created',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.bgColor),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          controller: _scrollController,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                postIdList != null ? postIdList.length : 0,
                            itemBuilder: (context, index) {
                              final tagName = mutualList[index];
                              final split = tagName.toString().split(',');
                              final Map<int, String> values = {
                                for (int i = 0; i < split.length; i++)
                                  i: split[i]
                              };
                              return PostWidget(
                                iscomment: commentTextList[index] != null
                                    ? true
                                    : false,
                                mutualFriend: mutualList[index],
                                isCommentScreen: false,
                                postId: postIdList[index]!,
                                profileTap: () {},
                                profileImage: profileImageUrl!,
                                profileName: name!,
                                profileSchool: cityList[index]!,
                                postTime: durationList[index]!,
                                isMyProfile: true,
                                reportTap: PopupMenuButton(
                                    color: Color(0xFFF0F2F4),
                                    icon: Icon(
                                      Icons.more_horiz_outlined,
                                      color: Color(0xFF828282),
                                    ),
                                    elevation: 2.0,
                                    padding: EdgeInsets.only(left: 8.0.w),
                                    onSelected: (dynamic value) {
                                      if (value == 2) {
                                        _showDialog(
                                            postIdList[index].toString(),
                                            index);
                                      } else {
                                        pushNewScreen(context,
                                            screen: imageListMap.length == 0 ||
                                                    imageListMap.length == null
                                                ? UpdatePostScreen(
                                                    description:
                                                        descriptionList[index]
                                                            .toString(),
                                                    postId: postIdList[index],
                                                  )
                                                : UpdatePostScreen(
                                                    description:
                                                        descriptionList[index]
                                                            .toString(),
                                                    images: imageListMap,
                                                    index: index,
                                                    postId: postIdList[index],
                                                  ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w400,
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
                                                  fontWeight: FontWeight.w400,
                                                  color: Constants.bgColor),
                                            ),
                                            value: 2,
                                          )
                                        ]),
                                description: descriptionList[index]!,
                                imageListView: imageListMap[index].length != 0
                                    ? Container(
                                        height: 25.0.h,
                                        width: 100.0.w,
                                        child: CarouselSlider.builder(
                                            carouselController: _controller,
                                            itemCount:
                                                imageListMap[index].length,
                                            itemBuilder:
                                                (context, imageIndex, rindex) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    List<String> imgList = [];
                                                    for (int i = 0;
                                                        i <
                                                            imageListMap[index]
                                                                .length;
                                                        i++) {
                                                      imgList.add(
                                                          imageListMap[index][i]
                                                              ['file']);
                                                    }
                                                    pushNewScreen(context,
                                                        withNavBar: false,
                                                        screen:
                                                            FullScreenSlider(
                                                                imageList:
                                                                    imgList,
                                                                index:
                                                                    imageIndex,
                                                                name: name!),
                                                        pageTransitionAnimation:
                                                            PageTransitionAnimation
                                                                .cupertino);
                                                  },
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          imageListMap[index]
                                                                  [imageIndex]
                                                              ['file'],
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              'assets/images/404.gif',
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              width: 100.0.w),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                            width: 100.0.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                            ),
                                                          ),
                                                      placeholder: (context,
                                                              url) =>
                                                          PhotoLoadingWidget()));
                                            },
                                            options: CarouselOptions(
                                                autoPlay: false,
                                                enableInfiniteScroll: false,
                                                viewportFraction: 1.0,
                                                onPageChanged:
                                                    (cindex, reason) {
                                                  setState(() {
                                                    _current[index] = cindex;
                                                  });
                                                })))
                                    : Container(),
                                indicator: imageListMap[index].length != 0
                                    ? Center(
                                        child: imageListMap[index].length != 1
                                            ? SizedBox(
                                                height: 18,
                                                child: ListView.builder(
                                                    itemCount:
                                                        imageListMap[index]
                                                            .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, iIndex) {
                                                      return Container(
                                                        width: 15.0,
                                                        height: 15.0,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0),
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: (Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)
                                                                .withOpacity(
                                                                    _current[index] ==
                                                                            iIndex
                                                                        ? 0.9
                                                                        : 0.3)),
                                                      );
                                                    }),
                                              )
                                            : SizedBox(),
                                      )
                                    : SizedBox(),
                                mutualLike: likesList[index]! - values.length,
                                likeTap: () {
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
                                isLiked: isLiked[index]!,
                                totalLike: likesList[index].toString(),
                                totalComments:
                                    totalCommentsList[index].toString(),
                                commentTap: () async {
                                  resultComment = await pushNewScreen(context,
                                      withNavBar: false,
                                      screen: CommentScreen(
                                        postId: postIdList[index],
                                        name: name,
                                        profileImage: profileImageUrl,
                                        degree: degreeName,
                                        schoolName: schoolName,
                                        date: dateList[index],
                                        description: descriptionList[index],
                                        like: likesList[index],
                                        comment: totalCommentsList[index],
                                        isLiked: isLiked[index],
                                        isSaved: isSaved[index],
                                        imageListMap: imageListMap,
                                        index: index,
                                        mutual: mutualList[index],
                                        otherCount:
                                            likesList[index]! - values.length,
                                      ),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);

                                  setState(() {});

                                  totalCommentsList[resultComment['index']] =
                                      resultComment['count'];
                                  likesList[resultComment['index']] =
                                      resultComment['likeCount'];
                                  isSaved[resultComment['index']] =
                                      resultComment['isSaved'];
                                  isLiked[resultComment['index']] =
                                      resultComment['isLiked'];
                                },
                                isSaved: isSaved[index]!,
                                saveTap: () {
                                  setState(() {
                                    isSaved[index] = !isSaved[index]!;
                                  });
                                  save.savePostApi(
                                      postIdList[index], authToken!);
                                },
                                shareTap: () async {
                                  await dLink.createDynamicLink(
                                    true,
                                    postIdList[index].toString(),
                                    index,
                                    name!,
                                    descriptionList[index]!,
                                    imageListMap[index].isEmpty
                                        ? ''
                                        : imageListMap[index][0]['file']
                                            .toString(),
                                  );
                                },
                                commentText: commentTextList[index] != null
                                    ? commentTextList[index]
                                    : '',
                                commentImage: commentProfile[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
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

  void _showDialog(id, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Delete Post',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Constants.bgColor),
              ),
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

  Future<void> getMyProfileApi() async {
    try {
      Dio dio = Dio();

      var response = await dio.get(Config.myProfileUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        myProfileMap = response.data;

        setState(() {
          isProfileLoading = false;
        });
      } else {
        setState(() {
          isProfileLoading = true;
        });
      }
    } on DioError catch (e, stack) {}
  }

  Future<void> getMyPostApi(int page) async {
    try {
      Dio dio = Dio();

      var response = await dio.get(
          '${Config.getEducatorPostUrl}/$userId?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map!['data'];

        if (map!['data'].length > 0) {
          if (name == '') {
            name = map!['data'][0]['name'];
            profileImageUrl = map!['data'][0]['profile_image'];
            degreeName = map!['data'][0]['last_degree'];
            schoolName = map!['data'][0]['school_name'];
          }

          for (int i = 0; i < map!['data'].length; i++) {
            _current.add(0);
            postIdList.add(map!['data'][i]['post_id']);
            dateList.add(map!['data'][i]['date']);
            descriptionList.add(map!['data'][i]['description']);
            cityList.add(map!['data'][i]['city']);
            durationList.add(map!['data'][i]['duration']);
            commentTextList.add(map!['data'][i]['comment']);
            mutualList.add(map!['data'][i]['mutual']);
            likesList.add(map!['data'][i]['total_likes']);
            totalCommentsList.add(map!['data'][i]['total_comments']);
            commentProfile.add(map!['data'][i]['commenter_profile']);
            isLiked.add(map!['data'][i]['isLiked']);
            isSaved.add(map!['data'][i]['isSaved']);
            for (int j = 0; j < map!['data'].length; j++) {
              imageListMap.putIfAbsent(k, () => map!['data'][i]['post_media']);
            }
            k++;
          }

          isLoading = false;
          isPostLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          isPostLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
          isPostLoading = false;
        });

        if (map!['status'] == true) {}
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {
      if (e.response != null) {
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

  Future<void> deletePostApi(String postID, int index) async {
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
        delMap = response.data;

        if (delMap!['status'] == true) {
          isProfileLoading = false;

          map = {};
          mapData = [];
          postIdList = [];
          dateList = [];
          descriptionList = [];
          imageListMap[index] = [];
          likesList = [];
          totalCommentsList = [];
          _current = [];
          cityList = [];
          durationList = [];
          commentTextList = [];
          mutualList = [];
          commentProfile = [];

          getMyPostApi(1);

          Fluttertoast.showToast(
              msg: delMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
          setState(() {});
        } else {
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
      } else {}
    } on DioError catch (e, stack) {
      if (e.response != null) {
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

  Future<void> savePostApi(int postID) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.savePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        saveMap = response.data;

        if (saveMap!['status'] == true) {
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
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
      } else {}
    } on DioError catch (e, stack) {
      if (e.response != null) {
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
}
