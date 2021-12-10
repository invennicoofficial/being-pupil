import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_Property_Review_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class RatingReviewScreen extends StatefulWidget {
  int propertyId;
  RatingReviewScreen({Key key, this.propertyId}) : super(key: key);

  @override
  _RatingReviewScreenState createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  List<String> rating = ['5', '4', '3', '2', '1'];
  List<int> faRating = [85, 60, 40, 30, 10];
  List<Color> ratingColor = [
    Color(0xFF277344),
    Color(0xFF277344),
    Color(0xFFCADA3A),
    Color(0xFFF77A19),
    Color(0xFFEF1616)
  ];
  bool isLoading = true;
  var result = PropertyReview();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPropertyReviewAPI();
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
            'Review & Rating',
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
            : Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 4.0.w, top: 3.0.h, right: 0.0.w, bottom: 3.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 18.0.h,
                          width: 30.0.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0.w, vertical: 2.0.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Constants.selectedIcon,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${result.data.rating.avgRating} / 5',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Constants.bgColor),
                              ),
                              SizedBox(
                                height: 3.0.h,
                              ),
                              Text(
                                '${result.data.totalRating} Rating',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor),
                              ),
                              SizedBox(
                                height: 0.5.h,
                              ),
                              Text(
                                '${result.data.totalReview} Review',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              ListTile(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // children: <Widget>[
                                dense: true,
                                visualDensity: VisualDensity(
                                    horizontal: 0.0, vertical: -4.0),
                                contentPadding:
                                    EdgeInsets.only(left: 2.0.w, right: 0.0.w),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      rating[0],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.bgColor),
                                    ),
                                    Image.asset(
                                      'assets/icons/starfull.png',
                                      height: 2.0.h,
                                      width: 4.0.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                trailing: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Text(
                                    result.data.rating.the5.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                  ),
                                ),
                                title: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Container(
                                    height: 1.0.h,
                                    child: FAProgressBar(
                                      currentValue: result.data.rating.the5,
                                      maxValue: 100,
                                      direction: Axis.horizontal,
                                      backgroundColor: Color(0xFFD3D9E0),
                                      progressColor: ratingColor[0],
                                    ),
                                  ),
                                ),
                                //],
                              ),
                              ListTile(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // children: <Widget>[
                                dense: true,
                                visualDensity: VisualDensity(
                                    horizontal: 0.0, vertical: -4.0),
                                contentPadding:
                                    EdgeInsets.only(left: 2.0.w, right: 0.0.w),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      rating[1],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.bgColor),
                                    ),
                                    Image.asset(
                                      'assets/icons/starfull.png',
                                      height: 2.0.h,
                                      width: 4.0.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                trailing: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Text(
                                    result.data.rating.the4.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                  ),
                                ),
                                title: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Container(
                                    height: 1.0.h,
                                    child: FAProgressBar(
                                      currentValue: result.data.rating.the4,
                                      maxValue: 100,
                                      direction: Axis.horizontal,
                                      backgroundColor: Color(0xFFD3D9E0),
                                      progressColor: ratingColor[1],
                                    ),
                                  ),
                                ),
                                //],
                              ),
                              ListTile(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // children: <Widget>[
                                dense: true,
                                visualDensity: VisualDensity(
                                    horizontal: 0.0, vertical: -4.0),
                                contentPadding:
                                    EdgeInsets.only(left: 2.0.w, right: 0.0.w),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      rating[2],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.bgColor),
                                    ),
                                    Image.asset(
                                      'assets/icons/starfull.png',
                                      height: 2.0.h,
                                      width: 4.0.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                trailing: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Text(
                                    result.data.rating.the3.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                  ),
                                ),
                                title: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Container(
                                    height: 1.0.h,
                                    child: FAProgressBar(
                                      currentValue: result.data.rating.the3,
                                      maxValue: 100,
                                      direction: Axis.horizontal,
                                      backgroundColor: Color(0xFFD3D9E0),
                                      progressColor: ratingColor[2],
                                    ),
                                  ),
                                ),
                                //],
                              ),
                              ListTile(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // children: <Widget>[
                                dense: true,
                                visualDensity: VisualDensity(
                                    horizontal: 0.0, vertical: -4.0),
                                contentPadding:
                                    EdgeInsets.only(left: 2.0.w, right: 0.0.w),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      rating[3],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.bgColor),
                                    ),
                                    Image.asset(
                                      'assets/icons/starfull.png',
                                      height: 2.0.h,
                                      width: 4.0.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                trailing: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Text(
                                    result.data.rating.the2.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                  ),
                                ),
                                title: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Container(
                                    height: 1.0.h,
                                    child: FAProgressBar(
                                      currentValue: result.data.rating.the2,
                                      maxValue: 100,
                                      direction: Axis.horizontal,
                                      backgroundColor: Color(0xFFD3D9E0),
                                      progressColor: ratingColor[3],
                                    ),
                                  ),
                                ),
                                //],
                              ),
                              ListTile(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                // children: <Widget>[
                                dense: true,
                                visualDensity: VisualDensity(
                                    horizontal: 0.0, vertical: -4.0),
                                contentPadding:
                                    EdgeInsets.only(left: 2.0.w, right: 0.0.w),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      rating[4],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.bgColor),
                                    ),
                                    Image.asset(
                                      'assets/icons/starfull.png',
                                      height: 2.0.h,
                                      width: 4.0.w,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                                trailing: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Text(
                                    result.data.rating.the1.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Constants.bgColor),
                                  ),
                                ),
                                title: Transform(
                                  transform: Matrix4.translationValues(
                                      -5.0.w, 0.0, 0.0),
                                  child: Container(
                                    height: 1.0.h,
                                    child: FAProgressBar(
                                      currentValue: result.data.rating.the1,
                                      maxValue: 100,
                                      direction: Axis.horizontal,
                                      backgroundColor: Color(0xFFD3D9E0),
                                      progressColor: ratingColor[4],
                                    ),
                                  ),
                                ),
                                //],
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: ListView.builder(
                        //       itemCount: 5,
                        //       shrinkWrap: true,
                        //       physics: NeverScrollableScrollPhysics(),
                        //       itemBuilder: (context, index) {
                        //         return ListTile(
                        //           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //           // children: <Widget>[
                        //           dense: true,
                        //           visualDensity:
                        //               VisualDensity(horizontal: 0.0, vertical: -4.0),
                        //           contentPadding:
                        //               EdgeInsets.only(left: 2.0.w, right: 0.0.w),
                        //           leading: Row(
                        //             mainAxisSize: MainAxisSize.min,
                        //             children: <Widget>[
                        //               Text(
                        //                 rating[index],
                        //                 style: TextStyle(
                        //                     fontFamily: 'Montserrat',
                        //                     fontSize: 10.0.sp,
                        //                     fontWeight: FontWeight.w600,
                        //                     color: Constants.bgColor),
                        //               ),
                        //               Image.asset(
                        //                 'assets/icons/starfull.png',
                        //                 height: 2.0.h,
                        //                 width: 4.0.w,
                        //                 fit: BoxFit.contain,
                        //               ),
                        //             ],
                        //           ),
                        //           trailing: Transform(
                        //             transform:
                        //                 Matrix4.translationValues(-5.0.w, 0.0, 0.0),
                        //             child: Text(
                        //               faRating[index].toString(),
                        //               style: TextStyle(
                        //                   fontFamily: 'Montserrat',
                        //                   fontSize: 10.0.sp,
                        //                   fontWeight: FontWeight.w600,
                        //                   color: Constants.bgColor),
                        //             ),
                        //           ),
                        //           title: Transform(
                        //             transform:
                        //                 Matrix4.translationValues(-5.0.w, 0.0, 0.0),
                        //             child: Container(
                        //               height: 1.0.h,
                        //               child: FAProgressBar(
                        //                 currentValue: faRating[index],
                        //                 maxValue: 100,
                        //                 direction: Axis.horizontal,
                        //                 backgroundColor: Color(0xFFD3D9E0),
                        //                 progressColor: ratingColor[index],
                        //               ),
                        //             ),
                        //           ),
                        //           //],
                        //         );
                        //       }),
                        // ),
                      ],
                    ),
                  ),
                  // Divider
                  Divider(
                    height: 1.0.h,
                    thickness: 1.5,
                    color: Constants.formBorder,
                  ),
                  //Reviews
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 4.0.w, top: 3.0.h, right: 4.0.w, bottom: 1.0.h),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0.h),
                              child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                      text: 'Review ',
                                      style: TextStyle(
                                          fontSize: 11.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500)),
                                  TextSpan(
                                      text: '(${result.data.review.length})',
                                      style: TextStyle(
                                          fontSize: 11.0.sp,
                                          color:
                                              Constants.bpOnBoardSubtitleStyle,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500)),
                                ]),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              height: 100.0.h,
                              width: double.infinity,
                              child: ListView.separated(
                                itemCount: result.data.review.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                          contentPadding: EdgeInsets.all(0.0),
                                          //leading:
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  result.data.review[index]
                                                      .profileImage,
                                                  width: 9.0.w,
                                                  height: 4.5.h,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.0.w,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Marilyn Brewer",
                                                    style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color:
                                                            Constants.bgColor,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Text(
                                                    result.data.review[index]
                                                        .date,
                                                    style: TextStyle(
                                                        fontSize: 6.5.sp,
                                                        color: Constants
                                                            .bpOnBoardSubtitleStyle,
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing:
                                              Text.rich(TextSpan(children: [
                                            TextSpan(
                                                text: 'Rated ',
                                                style: TextStyle(
                                                    fontSize: 7.0.sp,
                                                    color: Constants.bgColor,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            TextSpan(
                                                text:
                                                    '${result.data.review[index].rating}/5',
                                                style: TextStyle(
                                                    fontSize: 7.0.sp,
                                                    color:
                                                        Constants.selectedIcon,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ]))),
                                      Container(
                                        child: ReadMoreText(
                                          result.data.review[index].descreption,
                                          trimLines: 3,
                                          colorClickableText:
                                              Constants.blueTitle,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Read More',
                                          trimExpandedText: 'See Less',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 9.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants
                                                  .bpOnBoardSubtitleStyle),
                                          //textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, inex) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 1.0.h),
                                    child: Divider(
                                      height: 1.0.h,
                                      thickness: 1.5,
                                      color: Constants.formBorder,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }

  //Get Property Review API
  Future<PropertyReview> getPropertyReviewAPI() async {
    try {
      var dio = Dio();
      var response = await dio
          .get('${Config.getReviewUrl}?property_id=${widget.propertyId}');

      if (response.statusCode == 200) {
        print(response.data);
        result = PropertyReview.fromJson(response.data);

        if (result.status == true) {
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }
}
