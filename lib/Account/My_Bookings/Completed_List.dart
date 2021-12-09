import 'package:being_pupil/Account/My_Bookings/Review_Screen.dart';
import 'package:being_pupil/Model/Booking_Model/Get_Booking_Data_Model.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'View_Booking_Details.dart';
import 'View_Review_Screen.dart';

class CompletedList extends StatefulWidget {
  CompletedList({Key key}) : super(key: key);

  @override
  _CompletedListState createState() => _CompletedListState();
}

class _CompletedListState extends State<CompletedList> {
  var result = BookingDetails();
  bool isLoading = true;
  String authToken;
  ScrollController _scrollController = ScrollController();
  int page = 1;

  List<String> bookingImage = [];
  List<String> bookingName = [];
  List<String> bookingId = [];
  List<String> propertyId = [];
  List<String> bookingType = [];
  List<String> bookingPeriod = [];
  List<List<String>> bookingMeal = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getToken();
  }

 void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getCompletedBookingAPI(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (result.data.length > 0) {
            page++;
            getCompletedBookingAPI(page);
            print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getCompletedBookingAPI(page);
          print(page);
        }
      }
    });
  }

  void _onLoading() async {
      _refreshController.loadComplete();
      _refreshController.loadNoData();
   
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.bgColor),
            ),
          )
        : SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              noDataText: 'No More Up Coming Bookings',
              //noMoreIcon: Icon(Icons.refresh_outlined),
            ),
            onLoading: _onLoading,
          child: ListView.separated(
          controller: _scrollController,
          itemCount: bookingId.length == 0 ? 0 : bookingId.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Divider(
              height: 1.0.h,
              color: Constants.formBorder,
              thickness: 1.0,
            ),
          );
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
                top: 2.0.h, bottom: 1.0.h, left: 4.0.w, right: 4.0.w),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    //Image for booking
                    Padding(
                      padding: EdgeInsets.only(right: 4.0.w),
                      child: Container(
                        height: 12.0.h,
                        width: 22.0.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/postImage.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    //Other booking details
                    Container(
                      width: 65.0.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Lorem ipsum dolor sit amet, consetetur',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Constants.bgColor),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Text(
                              'Booking ID : 1234567',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Text(
                              'Double Sharing',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Text(
                              '21 Jan 2021 to 21 Mar 2021',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 9.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                //Foe cancel and view details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: index == 0
                          ? () {
                              pushNewScreen(context,
                                  screen: ReviewScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            }
                          : () {
                              pushNewScreen(context,
                                  screen: ViewReviewScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                      child: Text(
                        index == 0 ? 'Write Review' : 'View Review',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF04964D)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        pushNewScreen(context,
                            screen: ViewBookingScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                      },
                      child: Text(
                        'View Details',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1F7DE9)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }

   //Get Completted Bookings API
  Future<BookingDetails> getCompletedBookingAPI(int page) async{
    try{
      Dio dio = Dio();
      var response = await dio.get('${Config.upComingBookingUrl}?page=$page',
      options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      if(response.statusCode == 200){
        print(response.data);
        result = BookingDetails.fromJson(response.data);

        if(result.data.length > 0){
          for(int i = 0; i < result.data.length; i++){
            bookingId.add(result.data[i].bookingId);
            propertyId.add(result.data[i].propertyId);
            bookingName.add(result.data[i].name);
            bookingImage.add(result.data[i].propertyImage);
            bookingType.add(result.data[i].roomType);
            bookingMeal.add(result.data[i].meal);
            bookingPeriod.add('${result.data[i].checkInDate} to ${result.data[i].checkOutDate}');
          }
          print(bookingId);
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }
      }else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    }on DioError catch(e, stack){
      print(e.response);
      print(stack);
    }
    return result;
  }
}
