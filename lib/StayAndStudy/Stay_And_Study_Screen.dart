import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'package:being_pupil/StayAndStudy/Property_Details_Screen.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:being_pupil/Widgets/Shimmer_Widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class StayAndStudyScreen extends StatefulWidget {
  StayAndStudyScreen({Key? key}) : super(key: key);

  @override
  _StayAndStudyScreenState createState() => _StayAndStudyScreenState();
}

class _StayAndStudyScreenState extends State<StayAndStudyScreen> {
  String? authToken;
  var result = GetAllProperty();
  int propertyLength = 0;
  int page = 1;
  bool isLoading = true;
  List<int?> propertyId = [];
  List<double?> propertyRating = [];
  List<String?> propertyName = [];
  List<String?> propertyImage = [];
  List<String?> propertyLocation = [];
  List<String> propertyPrice = [];
  List<List<String>> allImage = [];
  List<dynamic> propDataList = [];
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Map<String, dynamic>? map;
  List<dynamic>? mapData;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getAllPropertyAPI(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (result.data!.length > 0) {
            page++;
            getAllPropertyAPI(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getAllPropertyAPI(page);
        }
      }
    });
  }

  void _onRefresh() async {
    setState(() {
      isLoading = true;
      page = 1;
      propertyId = [];
      propertyName = [];
      propertyImage = [];
      propertyLocation = [];
      propertyPrice = [];
      propertyRating = [];
    });
    getAllPropertyAPI(page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (propertyLength == 0) {
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
          title: Text(
            'Stay & Study',
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
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                child: ListView.separated(
                    controller: _scrollController,
                    itemCount: propertyId.length,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 1.0.h),
                        child: Divider(
                          height: 1.0,
                          color: Constants.formBorder,
                          thickness: 0.8,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          pushNewScreen(context,
                              withNavBar: false,
                              screen: PropertyDetailScreen(
                                propertyDetails: result,
                                index: index,
                                propData: propDataList,
                              ),
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 2.0.h, bottom: 0.5.h),
                              child: Stack(
                                children: <Widget>[
                                  CachedNetworkImage(
                                      imageUrl: propertyImage[index]!,
                                      errorWidget: (context, url, error) =>
                                          Text("error"),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            height: 18.0.h,
                                            width: 100.0.w,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          PropertyLoadingWidget()),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 3.5.h,
                                      width: 18.0.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/icons/greenStar.png',
                                            height: 2.5.h,
                                            width: 5.0.w,
                                            fit: BoxFit.fill,
                                          ),
                                          Text(
                                            propertyRating[index].toString(),
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Constants.bgColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.5.h),
                                  child: Container(
                                    width: 85.0.w,
                                    child: Text(
                                      propertyName[index]!,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.bgColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0),
                                  child: ImageIcon(
                                    AssetImage('assets/icons/locationPin.png'),
                                    color: Constants.bpOnBoardSubtitleStyle,
                                    size: 13.0,
                                  ),
                                ),
                                Container(
                                  width: 85.0.w,
                                  child: Text(
                                    propertyLocation[index]!,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 9.0.sp,
                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Constants.bpOnBoardSubtitleStyle),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ));
  }

  Future<GetAllProperty> getAllPropertyAPI(int page) async {
    try {
      var dio = Dio();
      var response = await dio.get('${Config.getAllPropertyUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        map = response.data;
        mapData = map!['data'];

        if (map!['status'] == true) {
          if (page > 0) {
            for (int i = 0; i < mapData!.length; i++) {
              propertyId.add(mapData![i]['property_id']);
              propertyName.add(mapData![i]['name']);
              propertyLocation.add(mapData![i]['location'] == null
                  ? ''
                  : mapData![i]['location']['address']);
              propertyImage.add(mapData![i]['featured_image'][0]);

              propertyRating.add(mapData![i]['rating'].toDouble());

              propDataList.add(mapData![i]);
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
        }
      }
    } on DioError catch (e, stack) {
      closeProgressDialog(context);
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
      } else {}
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
