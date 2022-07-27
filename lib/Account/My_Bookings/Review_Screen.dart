import 'package:being_pupil/Account/My_Bookings/Review_Done_Screen.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class ReviewScreen extends StatefulWidget {
  String? image, bookingId;
  int? propertyId;
  double? rating;
  ReviewScreen({Key? key, this.image, this.propertyId, this.bookingId})
      : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double starRating = 1.0;
  TextEditingController _headLineController = TextEditingController();
  TextEditingController _descriptioController = TextEditingController();
  Map<String, dynamic>? map;
  List<dynamic>? mapData;
  String? authToken;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
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
        title: Text(
          'Review',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 2.0.h),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Review your experience',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                      color: Constants.bgColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Container(
                  height: 25.0.h,
                  width: 100.0.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.image!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Center(
                  child: Text(
                    'Rate your experience',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w500,
                        color: Constants.bgColor),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 0.5.h),
                  child: RatingBar(
                    initialRating: starRating,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Image.asset('assets/icons/greenStar.png'),
                      half: Container(),
                      empty: Image.asset('assets/icons/star.png'),
                    ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      setState(() {
                        starRating = rating;
                      });
                    },
                  )),
              Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: Center(
                  child: Text(
                    'Rate on a scale of 1-5 (1 being lowest)',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 9.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bpOnBoardSubtitleStyle),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Divider(
                  height: 1.0.h,
                  thickness: 1.0,
                  color: Constants.formBorder,
                ),
              ),
              TextInputWidget(
                  textEditingController: _headLineController,
                  lable: 'Add a headline'),
              Padding(
                padding: EdgeInsets.only(top: 3.0.h),
                child: Divider(
                  height: 1.0.h,
                  thickness: 1.0,
                  color: Constants.formBorder,
                ),
              ),
              MultilineTextInput(
                  textEditingController: _descriptioController,
                  hint:
                      'Tell us about your overall experience at the hotel including the amities, services, and all food etc.'),
              Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: GestureDetector(
                    onTap: () {
                      submitBookingReview();
                    },
                    child: ButtonWidget(
                      btnName: 'SUBMIT',
                      isActive: true,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submitBookingReview() async {
    displayProgressDialog(context);
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'property_id': widget.propertyId,
        'booking_id': widget.bookingId,
        'rating': starRating,
        'headline': _headLineController.text,
        'descreption': _descriptioController.text
      });

      var response = await dio.post(Config.addReviewUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;

        closeProgressDialog(context);

        if (map!['status'] == true && map!['data']['isReviewed'] == true) {
          pushNewScreen(context,
              screen: ReviewDoneScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
        } else {
          Fluttertoast.showToast(
            msg: map!['message'] == null ? map!['error_msg'] : map!['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      } else {
        closeProgressDialog(context);

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
