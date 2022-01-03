import 'package:being_pupil/Account/My_Course/Course_Details.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Get_Educator_Course_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class GetEducatorCourseScreen extends StatefulWidget {
  final userId;
  GetEducatorCourseScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _GetEducatorCourseScreenState createState() =>
      _GetEducatorCourseScreenState();
}

class _GetEducatorCourseScreenState extends State<GetEducatorCourseScreen> {
  String? authToken;
  int courseLength = 0;
  var result = GetEducatorCourse();
  ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  int page = 1;
  List<String> startDateList = [];
  List<String> endDateList = [];
  List<int?> idList = [];
  List<String?> nameList = [];
  List<String?> descriptionList = [];
  List<List<dynamic>?> linksList = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getEducatorCourseAPI(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (courseLength > 0) {
            page++;
            getEducatorCourseAPI(page);
            print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getEducatorCourseAPI(page);
          print(page);
        }
      }
    });
  }

  void _onLoading() async {
    //if (mounted) setState(() {});
    if (courseLength == 0) {
      //_refreshController.loadComplete();
      _refreshController.loadNoData();
    } else {
      _refreshController.requestLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('Educator Courses',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constants.bgColor),
              ),
            )
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: false,
              enablePullUp: true,
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              onLoading: _onLoading,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: nameList.length,
                  //physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.h, horizontal: 1.0.w),
                      child: ListTile(
                        onTap: () {
                          pushNewScreen(context,
                              screen: CourseDetailScreen(
                                courseId: idList[index],
                                courseName: nameList[index],
                                courseStartDate: startDateList[index],
                                courseEndDate: endDateList[index],
                                courseDescription: descriptionList[index],
                                courseLinks: linksList[index] as List<String>?,
                              ),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 10.0.h,
                              width: 18.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/postImage.png'),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: 5.0.w,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 65.0.w,
                                  child: Text(
                                    nameList[index]!,
                                    //result.data[index].courseName,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 11.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Text('${startDateList[index]} to ${endDateList[index]}',
                                    //'${result.data[index].startDate} to ${result.data[index].endDate}',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bgColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  //Get My  Course API

  Future<GetEducatorCourse> getEducatorCourseAPI(int page) async {
    //displayProgressDialog(context);

    try {
      var dio = Dio();
      var response = await dio.get(
          '${Config.getEducatorCourseUrl}${widget.userId}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        result = GetEducatorCourse.fromJson(response.data);
        print(response.data);
        courseLength = 0;
        courseLength = result.data == [] ? 0 : result.data!.length;

        setState(() {});
        //closeProgressDialog(context);
        if (courseLength > 0) {
          for (int i = 0; i < courseLength; i++) {
            idList.add(result.data![i].courseId);
            nameList.add(result.data![i].courseName);
            startDateList.add(result.data![i].startDate!);
            endDateList.add(result.data![i].endDate!);
            descriptionList.add(result.data![i].courseDescription);
            linksList.add(result.data![i].courseLink);
          }
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }
      } else {
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(
          msg: result.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      // closeProgressDialog(context);
      //closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::" +
            e.response!.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        print(e.message);
      }
    }
    return result;
  }

  displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog();
        }));
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
