import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/StayAndStudy/Property_Book_Screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({Key key}) : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
  ];
  final CarouselController _controller = CarouselController();
  List<String> ameList = [
    'Free Wi-Fi',
    'CCTV',
    'Lift',
    'Parking',
    'Limited Power Backup',
    'Washing Machine',
    'Fire Extinguisher',
  ];
  List<String> ameIcon = [
    'assets/icons/wifi.png',
    'assets/icons/cctv.png',
    'assets/icons/lift.png',
    'assets/icons/parking.png',
    'assets/icons/power.png',
    'assets/icons/washer.png',
    'assets/icons/fire.png',
  ];

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
          'Stay & Study',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //Images of Property
            Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: CarouselSlider(
                    carouselController: _controller,
                    items: imgList
                        .map((item) => Container(
                              child: Center(
                                  child: Image.network(item,
                                      fit: BoxFit.cover, width: 1000)),
                            ))
                        .toList(),
                    options: CarouselOptions(
                      height: 30.0.h,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.85,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      //autoPlay: true,
                      // autoPlayInterval: Duration(seconds: 3),
                      // autoPlayAnimationDuration: Duration(milliseconds: 800),
                      // autoPlayCurve: Curves.fastOutSlowIn,
                      //pauseAutoPlayOnTouch: Duration(seconds: 10),
                      enlargeCenterPage: true,
                      //onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ))),
            //small images of Property
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 5.0.h,
                      child: Center(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: imgList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 1.0.w),
                                child: GestureDetector(
                                  onTap: () {
                                    _controller.animateToPage(index,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                    width: 10.0.w,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(imgList[index]),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Title and Share button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Lorem ipsum dolor sit amet',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w700,
                        color: Constants.bgColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(
                          'check out Being Pupil App! https://google.com',
                          subject: 'Download Being Pupil App!');
                    },
                    child: Container(
                      height: 4.0.h,
                      width: 8.0.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Constants.formBorder),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Icon(
                        Icons.share,
                        color: Constants.bgColor,
                        size: 22.0,
                      ), //Image.asset('assets/icons/share.png', color: Constants.bgColor),
                    ),
                  )
                ],
              ),
            ),
            //Review and rating for Property
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ImageIcon(AssetImage('assets/icons/greenStar.png'),
                      size: 18.0, color: Constants.selectedIcon),
                  SizedBox(
                    width: 1.0.w,
                  ),
                  Text(
                    '4.5 Rating | 5 Review',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.blueTitle),
                  )
                ],
              ),
            ),
            //About Property
            Padding(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 3.0.h),
              child: Row(
                children: [
                  Text(
                    'About Property',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Constants.bgColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 1.0.h),
              child: Row(
                children: [
                  Text(
                    'sit amet, consetetur sadipscing elitr, sed',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Constants.blueTitle),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 1.0.h),
              child: Container(
                child: ReadMoreText(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna erat, Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,',
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 8.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Constants.bpOnBoardSubtitleStyle),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            //Amenites of property
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0.h),
              child: Container(
                  padding: EdgeInsets.only(
                      left: 4.0.w, right: 4.0.w, bottom: 3.0.h, top: 3.0.h),
                  color: Color(0xFFD3D9E0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Amenities',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12.0.sp,
                                fontWeight: FontWeight.w600,
                                color: Constants.bgColor),
                          ),
                        ],
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0.0),
                          itemCount: ameList.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 4.5),
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ImageIcon(
                                AssetImage(ameIcon[index]),
                                size: 22.0,
                                color: Constants.bgColor,
                              ),
                              title: Text(
                                ameList[index],
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 9.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor),
                              ),
                            );
                          }),
                    ],
                  )),
            ),
            //Show map button
            Container(
              height: 7.0.h,
              width: 90.0.w,
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                //color: Constants.bpOnBoardTitleStyle,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  //color: Constants.bgColor,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  'Show on Map',
                  style: TextStyle(
                      color: Constants.bgColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 11.0.sp),
                ),
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
            //Book now button
            GestureDetector(
              onTap: () {
                pushNewScreen(context,
                    screen: BookPropertyScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino);
              },
              child: Container(
                height: 7.0.h,
                width: 90.0.w,
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  color: Constants.bpOnBoardTitleStyle,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Constants.bgColor,
                    width: 0.15,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Book now'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 11.0.sp),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
          ],
        ),
      ),
    );
  }
}
