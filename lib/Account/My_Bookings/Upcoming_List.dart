import 'package:being_pupil/Account/My_Bookings/Cancel_Booking_Screen.dart';
import 'package:being_pupil/Account/My_Bookings/View_Booking_Details.dart';
import 'package:being_pupil/Model/Booking_Model/Get_Booking_Data_Model.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class UpComingList extends StatefulWidget {
  UpComingList({Key? key}) : super(key: key);

  @override
  _UpComingListState createState() => _UpComingListState();
}

class _UpComingListState extends State<UpComingList> {
  var result = BookingDetails();
  bool isLoading = true;
  String? authToken;
  ScrollController _scrollController = ScrollController();
  int page = 1;

  List<String?> bookingImage = [];
  List<String?> bookingName = [];
  List<String?> bookingId = [];
  List<String?> propertyId = [];
  List<String?> bookingType = [];
  //List<String> bookingPeriod = [];
  List<String?> bookingGuestName = [];
  List<String?> bookingMobileNumber = [];
  List<String?> bookingCheckIn = [];
  List<String?> bookingCheckOut = [];
  List<String?> bookingRoomType = [];
  List<double?> bookingRoomAmount = [];
  List<double?> bookingTaxAmount = [];
  List<double?> bookingMealAmount = [];
  List<double?> bookingTotalAmount = [];
  List<List<String>?> bookingMeal = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getUpComingBookingAPI(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (result.data!.length > 0) {
            page++;
            getUpComingBookingAPI(page);
            //print(page);
          } else {
            _refreshController.loadComplete();
          }
        } else {
          page++;
          getUpComingBookingAPI(page);
          //print(page);
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
        : bookingId.length == 0
            ? Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/noBooking.png',
                          height: 300, width: 300, fit: BoxFit.contain),
                      Text(
                        'No Booking',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Constants.bgColor),
                      ),
                    ],
                  ),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0.w, vertical: 0.0.h),
                        child: Divider(
                          height: 0.0.h,
                          color: Constants.formBorder,
                          thickness: 1.0,
                        ),
                      );
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 2.0.h,
                            bottom: 1.0.h,
                            left: 4.0.w,
                            right: 4.0.w),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                //Image for booking
                                Padding(
                                  padding: EdgeInsets.only(right: 4.0.w),
                                  child: Container(
                                    height: 75.0,
                                    width: 75.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                bookingImage[index]!),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                //Other booking details
                                Container(
                                  width: 63.0.w,
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        bookingName[index]!,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 11.0.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Constants.bgColor),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 1.0.h),
                                        child: Text(
                                          'Booking ID : ${bookingId[index]}',
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
                                          bookingType[index]!,
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
                                          '${bookingCheckIn[index]} to ${bookingCheckOut[index]}',
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      pushNewScreen(context,
                                          screen: CancelBookingScreen(
                                            image: bookingImage[index],
                                            name: bookingName[index],
                                            index: index,
                                            guestName: bookingGuestName[index],
                                            mobileNumber:
                                                bookingMobileNumber[index],
                                            checkIn: bookingCheckIn[index],
                                            checkOut: bookingCheckOut[index],
                                            roomType: bookingRoomType[index],
                                            meal: bookingMeal[index].toString(),
                                            roomAmount:
                                                bookingRoomAmount[index],
                                            mealAmount:
                                                bookingMealAmount[index],
                                            taxAmount: bookingTaxAmount[index],
                                            totalAmount:
                                                bookingTotalAmount[index],
                                            propertyId:
                                                int.parse(propertyId[index]!),
                                            bookingId: bookingId[index],
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation
                                                  .cupertino);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 9.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFFEF1616)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pushNewScreen(context,
                                          screen: ViewBookingScreen(
                                            image: bookingImage[index],
                                            name: bookingName[index],
                                            index: index,
                                            guestName: bookingGuestName[index],
                                            mobileNumber:
                                                bookingMobileNumber[index],
                                            checkIn: bookingCheckIn[index],
                                            checkOut: bookingCheckOut[index],
                                            roomType: bookingRoomType[index],
                                            meal: bookingMeal[index].toString(),
                                            // roomAmount:
                                            //     bookingRoomAmount[index],
                                            // mealAmount:
                                            //     bookingMealAmount[index],
                                            // taxAmount: bookingTaxAmount[index],
                                            // totalAmount:
                                            //     bookingTotalAmount[index],
                                          ),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation
                                                  .cupertino);
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
                            ),
                          ],
                        ),
                      );
                    }),
              );
  }

  //Get UpComing Bookings API
  Future<BookingDetails> getUpComingBookingAPI(int page) async {
    try {
      Dio dio = Dio();
      var response = await dio.get('${Config.upComingBookingUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        //response.data);
        result = BookingDetails.fromJson(response.data);

        if (result.status == true) {
          if (result.data!.length > 0) {
            for (int i = 0; i < result.data!.length; i++) {
              bookingId.add(result.data![i].bookingId);
              propertyId.add(result.data![i].propertyId);
              bookingName.add(result.data![i].name);
              bookingImage.add(result.data![i].propertyImage);
              bookingType.add(result.data![i].roomType);
              bookingMeal.add(result.data![i].meal);
              //bookingPeriod.add('${result.data[i].checkInDate} to ${result.data[i].checkOutDate}');
              bookingGuestName.add(result.data![i].guestName);
              bookingMobileNumber.add(result.data![i].mobileNumber);
              bookingCheckIn.add(result.data![i].checkInDate);
              bookingCheckOut.add(result.data![i].checkOutDate);
              bookingRoomType.add(result.data![i].roomType);
              //! bookingRoomAmount.add(result.data![i].roomAmount);
              //! bookingTaxAmount.add(result.data![i].taxAmount);
              //! bookingMealAmount.add(result.data![i].mealAmount);
              //! bookingTotalAmount.add(result.data![i].totalAmount);
            }
            //print(bookingId);
            isLoading = false;
            setState(() {});
          } else {
            isLoading = false;
            setState(() {});
          }
        } else {
          Fluttertoast.showToast(
            msg: result.message == null ? result.errorMsg : result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      } else {
        //print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode!;
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
    return result;
  }
}
