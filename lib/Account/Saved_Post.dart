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
  List<String?> durationList = [];
  List<String?> cityList = [];
  List<String?> commentTextList = [];
  List<String?> mutualList = [];
  List<String?> commentProfile = [];

  int? userId;
  String? authToken;
  Map<String, dynamic>? saveMap;
  SavePostAPI save = SavePostAPI();
  LikePostAPI like = LikePostAPI();
  CommentAPI comment = CommentAPI();

  Map<String, dynamic> resultComment = {};
  List<int> _current = [];
  final CarouselController _controller = CarouselController();
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
      userId = preferences.getInt('userId');
    });

    getSavedPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map!['data'].length > 0) {
            page++;
            getSavedPostApi(page);
          }
        } else {
          page++;
          getSavedPostApi(page);
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
            onPressed: () {
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
            : SingleChildScrollView(
                controller: _scrollController,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: postIdList != null ? postIdList.length : 0,
                  itemBuilder: (context, index) {
                    final tagName = mutualList[index];
                    final split = tagName.toString().split(',');
                    final Map<int, String> values = {
                      for (int i = 0; i < split.length; i++) i: split[i]
                    };
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
                      reportTap: IconButton(
                        icon: Icon(
                          Icons.more_horiz_outlined,
                          color: Color(0xFF828282),
                        ),
                        onPressed: () async {
                          var result = await pushNewScreen(context,
                              withNavBar: false,
                              screen: ReportFeed(
                                postId: postIdList[index],
                              ),
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                      ),
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                        'assets/images/404.gif',
                                                        fit: BoxFit.fitHeight,
                                                        width: 100.0.w),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
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
                                          itemCount: imageListMap[index].length,
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
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black)
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
                          : Row(),
                      mutualLike: likesList[index]! - values.length,
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
                                          mutual: mutualList[index],
                                          otherCount:
                                              likesList[index]! - values.length,
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
                      shareTap: () async {
                        await dLink.createDynamicLink(
                          true,
                          postIdList[index].toString(),
                          index,
                          nameList[index]!,
                          descriptionList[index]!,
                          imageListMap[index].isEmpty
                              ? ''
                              : imageListMap[index][0]['file'].toString(),
                        );
                      },
                      iscomment: commentTextList[index] != null ? true : false,
                      commentText: commentTextList[index] != null
                          ? commentTextList[index]!
                          : '',
                      commentImage: commentProfile[index],
                      isMyProfile: false,
                      mutualFriend: mutualList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 5.0,
                      color: Color(0xFFD3D9E0),
                    );
                  },
                ),
              ));
  }

  Future<void> getSavedPostApi(int page) async {
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getSavePostUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map!['data'];

        if (map!['data'].length > 0) {
          for (int i = 0; i < map!['data'].length; i++) {
            _current.add(0);
            postIdList.add(map!['data'][i]['post_id']);
            userIdList.add(map!['data'][i]['post_user_id']);
            nameList.add(map!['data'][i]['name']);
            profileImageList.add(map!['data'][i]['profile_image']);
            degreeList.add(map!['data'][i]['last_degree']);
            schoolList.add(map!['data'][i]['school_name']);
            dateList.add(map!['data'][i]['date']);
            descriptionList.add(map!['data'][i]['description']);
            cityList.add(map!['data'][i]['city']);
            durationList.add(map!['data'][i]['duration']);
            commentTextList.add(map!['data'][i]['comment']);
            mutualList.add(map!['data'][i]['mutual']);
            commentProfile.add(map!['data'][i]['commenter_profile']);
            isSaved.add(map!['data'][i]['isSaved']);
            isLiked.add(map!['data'][i]['isLiked']);
            likesList.add(map!['data'][i]['total_likes']);
            totalCommentsList.add(map!['data'][i]['total_comments']);

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
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {}
  }

  Future<void> savePostApi(String postID) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.savePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        saveMap = response.data;

        if (saveMap!['status'] == true) {
          map!.clear();
          map = {};
          mapData = [];
          postIdList = [];
          dateList = [];
          descriptionList = [];
          cityList = [];
          durationList = [];
          commentTextList = [];
          mutualList = [];
          commentProfile = [];
          _current = [];

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

          getSavedPostApi(1);

          setState(() {});

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
    } on DioError catch (e, stack) {}
  }

  Future<void> getUserProfile(id) async {
    Map<String, dynamic>? map = {};
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/$id',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;

        if (map!['data'] != null || map['data'] != []) {
          setState(() {});

          pushNewScreen(context,
              screen: EducatorProfileViewScreen(
                id: id,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
        } else {
          isLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {}
  }
}
