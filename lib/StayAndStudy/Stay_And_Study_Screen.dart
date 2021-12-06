import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'package:being_pupil/StayAndStudy/Property_Details_Screen.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class StayAndStudyScreen extends StatefulWidget {
  StayAndStudyScreen({Key key}) : super(key: key);

  @override
  _StayAndStudyScreenState createState() => _StayAndStudyScreenState();
}

class _StayAndStudyScreenState extends State<StayAndStudyScreen> {
  String authToken;
  var result = GetAllProperty();
  int propertyLength = 0;
  int page = 1;
  bool isLoading = false;
  List<int> propertyId = [];
  List<int> propertyRating = [];
  List<String> propertyName = [];
  List<String> propertyImage = [];
  List<String> propertyLocation = [];
  List<String> propertyPrice = [];
  ScrollController _scrollController = ScrollController();
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
    getAllPropertyAPI(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (propertyLength > 0) {
            page++;
            getAllPropertyAPI(page);
            print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getAllPropertyAPI(page);
          print(page);
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
    //if (mounted) setState(() {});
    if (propertyLength == 0) {
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
            : SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropMaterialHeader(),
                footer: ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                ),
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 1.0.h, left: 4.0.w, right: 4.0.w),
                  child: ListView.separated(
                      controller: _scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: propertyLength,
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
                            print('Select $index Property!!!');
                            pushNewScreen(context,
                                withNavBar: false,
                                screen: PropertyDetailScreen(propertyDetails: result,
                                index: index,),
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                //Image and Rating
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20.0.h,
                                      width: 100.0.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              propertyImage[index]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: 4.0.h,
                                        width: 15.0.w,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.0),
                                                topRight:
                                                    Radius.circular(8.0))),
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
                              //Title of property
                              Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 0.5.h),
                                    child: Text(
                                      propertyName[index],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Constants.bgColor),
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: <Widget>[
                                  //Location of Property
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 2.0),
                                        child: ImageIcon(
                                          AssetImage(
                                              'assets/icons/locationPin.png'),
                                          color: Constants.bpOnBoardSubtitleStyle,
                                          size: 13.0,
                                        ),
                                      ),
                                      Container(
                                        //height: 20,
                                        width: 88.0.w,
                                        child: Text(
                                          propertyLocation[index],
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 8.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants
                                                  .bpOnBoardSubtitleStyle),
                                                  overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Rent of Property
                              //     Text(
                              //       '₹${propertyPrice[index]}/mth',
                              //       style: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           fontSize: 11.0.sp,
                              //           fontWeight: FontWeight.w600,
                              //           color: Color(0xFF277344)),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      }),
                ),
              ));
  }

  //GetAll Property List API
  Future<GetAllProperty> getAllPropertyAPI(int page) async {
    //displayProgressDialog(context);

    try {
      var dio = Dio();
      var response = await dio.get(Config.getAllPropertyUrl,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      if (response.statusCode == 200) {
        result = GetAllProperty.fromJson(response.data);
        print(response.data);
        //closeProgressDialog(context);

        if (result.status == true) {
          propertyLength = 0;
          propertyLength = result.data == [] ? 0 : result.data.length;
          print('PROP:::' + propertyLength.toString());
          if (propertyLength > 0) {
            for (int i = 0; i < propertyLength; i++) {
              propertyId.add(result.data[i].propertyId);
              propertyName.add(result.data[i].name);
              propertyLocation.add(result.data[i].location.address);
              propertyImage.add(result.data[i].featuredImage[0].toString());
              propertyPrice
                  .add('${int.parse(result.data[i].room[0].roomAmount)}');
              propertyRating.add(result.data[i].rating);
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
          // Fluttertoast.showToast(
          //   msg: result.message,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Constants.bgColor,
          //   textColor: Colors.white,
          //   fontSize: 10.0.sp,
          // );
        }
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::" +
            e.response.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
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
