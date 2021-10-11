import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/HomeScreen/Report_Feed.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Save_Post_API_Class.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;


class SavedPostScreen extends StatefulWidget {
  SavedPostScreen({Key key}) : super(key: key);

  @override
  _SavedPostScreenState createState() => _SavedPostScreenState();
}

class _SavedPostScreenState extends State<SavedPostScreen> {
  bool isLiked = false;
  List<bool> isSaved = [];

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

  List<String> postIdList = [];
  List<String> dateList = [];
  List<String> descriptionList = [];
  Map<int, dynamic> imageListMap = {};
  List<int> likesList = [];
  List<int> totalCommentsList = [];

  int userId;
  String authToken;
  Map<String, dynamic> saveMap;
  SavePostAPI save = SavePostAPI();

  @override
  void initState() {
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
    });
    print('ID::::::' + userId.toString());
    getSavedPostApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (map['data'].length > 0) {
            page++;
            getSavedPostApi(page);
            print(page);
          }
        } else {
          page++;
          getSavedPostApi(page);
          print(page);
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
          : SingleChildScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          child: ListView.separated(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: postIdList != null ? postIdList.length : 0,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  //main horizontal padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                    //Container for one post
                    child: Container(
                      // height: 58.0.h,
                      // width: 100.0.w,
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
                            trailing: IconButton(
                                icon: Icon(Icons.report_gmailerrorred_outlined),
                                onPressed: () {
                                  pushNewScreen(context,
                                      withNavBar: false,
                                      screen: ReportFeed(),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino);
                                }),
                            //ImageIcon(AssetImage('assets/icons/report.png'),)
                          ),
                          //Post descriptionText
                          Text(descriptionList[index],
                              style: TextStyle(
                                  fontSize: 9.0.sp,
                                  color: Constants.bpOnBoardSubtitleStyle,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.justify),
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
                                    itemCount: imageListMap[index].length,
                                    itemBuilder: (context, imageIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          imageListMap[index][imageIndex]
                                              ['file'],
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
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
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.only(top: 1.0.h),
                                    //   child: Text(
                                    //     "1 Share",
                                    //     style: TextStyle(
                                    //         fontSize: 6.5.sp,
                                    //         color: Constants
                                    //             .bpOnBoardSubtitleStyle,
                                    //         fontFamily: 'Montserrat',
                                    //         fontWeight: FontWeight.w400),
                                    //   ),
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          //divider
                          Divider(
                            height: 1.0.h,
                            color: Color(0xFF7F7F7F).withOpacity(0.6),
                            thickness: 2.0,
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
                                      isLiked = !isLiked;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        isLiked
                                            ? Icons.thumb_up_sharp
                                            : Icons.thumb_up_outlined,
                                        color: isLiked
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
                                      isSaved[index] = !isSaved[index];
                                    });
                                    //savePostApi(postIdList[index]);
                                    save.savePostApi(int.parse(postIdList[index]), authToken);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        isSaved[index]
                                            ? Icons.bookmark_sharp
                                            : Icons.bookmark_outline_outlined,
                                        color: isSaved[index]
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
        ));
  }

  //Get Svaed Post API
  Future<void> getSavedPostApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getSavePostUrl}$userId?page=$page');
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        map = response.data;
        mapData = map['data'];

        print(map);
        print(mapData);
        if (map['data'].length > 0) {
          if (name == '') {
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
            //for save unsave
            isSaved.add(true);
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

  //unsave post API
  Future<void> savePostApi(String postID) async {
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

        //print(saveMapData);
        // setState(() {
        //   isLoading = false;
        // });
        if (saveMap['status'] == true) {
          print('true');
          map.clear();
          getSavedPostApi(page);
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
