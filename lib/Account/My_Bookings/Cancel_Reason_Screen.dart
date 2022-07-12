import 'package:being_pupil/Account/My_Bookings/Cancel_Done_Screen.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Booking_Model/Get_Booking_Data_Model.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Booking_Model/Cancel_Booking_Reason_List_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class ReasonForCancelBooking extends StatefulWidget {
  final int propertyId;
  final String? bookingId;
  BookingDetails? propertyDetails;
  int? index;
  String? meal,
      image,
      guestName,
      mobileNumber,
      checkIn,
      checkOut,
      roomType,
      name;
  //dynamic roomAmount, mealAmount, taxAmount, totalAmount;
  ReasonForCancelBooking(
      {Key? key,
      required this.propertyId,
      required this.bookingId,
      this.meal,
      this.image,
      this.index,
      this.guestName,
      this.mobileNumber,
      this.checkOut,
      this.checkIn,
      this.roomType,
      this.name,
      // this.roomAmount,
      // this.mealAmount,
      // this.taxAmount,
      // this.totalAmount
      })
      : super(key: key);
  @override
  _ReasonForCancelBookingState createState() => _ReasonForCancelBookingState();
}

class _ReasonForCancelBookingState extends State<ReasonForCancelBooking> {
  bool isOther = false;
  TextEditingController _detailController = TextEditingController();
  // Map<String, dynamic> reportMap = Map<String, dynamic>();
  // List<dynamic> reportMapData = List<dynamic>();
  int? selectedIssue;
  String? authToken;
  int? issueId;
  var result = CancelBookoingReason();
  bool isLoading = true;

  @override
  void initState() {
    getToken();
    //getReportIssueList();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getCancelReasonList();
  }

  Widget detailedBox() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.0.h, left: 3.0.w, right: 3.0.w),
              child: Text(
                'Detailed Description',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0.sp,
                    color: Constants.bgColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Theme(
          data: new ThemeData(
            primaryColor: Constants.bpSkipStyle,
            primaryColorDark: Constants.bpSkipStyle,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 1.0.h),
            child: Container(
              height: 13.0.h,
              width: 90.0.w,
              child: TextFormField(
                controller: _detailController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                //maxLength: 100,
                decoration: InputDecoration(
                    //labelText: "Please mention your achivements...",
                    //counterText: '',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Constants.formBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Constants.formBorder,
                        //width: 2.0,
                      ),
                    ),
                    hintText: "Add Detailed Description"),
                //keyboardType: TextInputType.emailAddress,
                style:
                    new TextStyle(fontFamily: "Montserrat", fontSize: 10.0.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton:
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          'Reason for cancellation',
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
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      itemCount: result.data!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 4.0.w),
                            onTap: () {
                              setState(() {
                                selectedIssue = index;
                                issueId = index + 1;
                                //reportMapData[index]['name'] == 'Others'
                                result.data![index].name == 'Other'
                                    ? isOther = true
                                    : isOther = false;
                              });
                              //print(isOther ? 'Other' : 'NotOther');
                              //print('ISSUE_ID::: $issueId');
                            },
                            tileColor: selectedIssue == index
                                ? Constants.bgColor.withOpacity(0.7)
                                : null,
                            title: Text(
                              result.data![index].name!,
                              //index == 7 ? 'Other' : 'Report issue $index',
                              // '${reportMapData[index]['name']}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: selectedIssue == index
                                      ? Colors.white
                                      : Constants.bgColor),
                            ));
                      }),
                  isOther ? detailedBox() : Container(),
                  SizedBox(
                    height: 15.0.h,
                  ),
                  InkWell(
                    onTap: () {
                      if (selectedIssue == null) {
                        Fluttertoast.showToast(
                          msg: "Select Reason for Cancellation",
                          fontSize: 10.0.sp,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else if (isOther == true &&
                          _detailController.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Description is required",
                          fontSize: 10.0.sp,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_SHORT,
                        );
                      } else {
                        submitCancelRason();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.0.h),
                      child: Container(
                        height: 7.0.h,
                        width: 90.0.w,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Constants.bgColor,
                            ),
                            color: Constants.bgColor,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 11.0.sp,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  //get Report issue list API
  Future<CancelBookoingReason> getCancelReasonList() async {
    //displayProgressDialog(context);
    try {
      Dio dio = Dio();
      var response = await dio.get(Config.getCancelReasonList);
      //print(response.statusCode);

      if (response.statusCode == 200) {
        result = CancelBookoingReason.fromJson(response.data);
        //print(response.data);
        //closeProgressDialog(context);
        isLoading = false;
        setState(() {});
      } else {
        //print('NOT OK');
        isLoading = false;
        setState(() {});
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
    }
    return result;
  }

  //submit Cancel Rason API
  submitCancelRason() async {
    //print(result.data![selectedIssue!].cancelId);
    displayProgressDialog(context);
    //var result = ReportIssue();
    Map<String, dynamic>? map = Map<String, dynamic>();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'property_id': widget.propertyId,
        'cancel_id': result.data![selectedIssue!].cancelId,
        'booking_id': widget.bookingId,
        'description': isOther ? _detailController.text : null
      });

      var response = await dio.post(Config.submitCancelReason,
          data: formData,
          options: Options(headers: {
            "Authorization": 'Bearer $authToken',
          }));

      if (response.statusCode == 200) {
        closeProgressDialog(context);
        // result = reportIssueFromJson(response.data.toString());
        // //print(result);
        map = response.data;
        //mapData = map['data'];
        if (map!['status'] == true) {
          Fluttertoast.showToast(
            msg: map['message'], //map['data']['status'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          pushNewScreen(context,
              screen: CancelDoneScreen(
                image: widget.image,
                name: widget.name,
                index: widget.index,
                guestName: widget.guestName,
                mobileNumber: widget.mobileNumber,
                checkIn: widget.checkIn,
                checkOut: widget.checkOut,
                roomType: widget.roomType,
                meal: widget.meal,
                // roomAmount: widget.roomType,
                // mealAmount: widget.mealAmount,
                // taxAmount: widget.taxAmount,
                // totalAmount: widget.totalAmount,
                propertyId: widget.propertyId,
                bookingId: widget.bookingId,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);

          //print(map);
          //Go back to HomeScreen
          //Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: map['message'] == null ? map['error_msg'] : map['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          //print(map);
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: result.message == null ? result.errorMsg : result.message,
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Constants.bgColor,
        //   textColor: Colors.white,
        //   fontSize: 10.0.sp,
        // );
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
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        //print(e.message);
      }
    }
  }

  displayProgressDialog(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new ProgressDialog();
          }));
    });
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
