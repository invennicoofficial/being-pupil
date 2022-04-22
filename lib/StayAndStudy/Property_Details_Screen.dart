import 'dart:io';
import 'dart:typed_data';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'package:being_pupil/StayAndStudy/Property_Book_Screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Rating_Review_Screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  // String propertyName, propertyDescription, propertyLat, propertyLng;
  // int propertyId, propertyRating, propertyReview;
  // List<String> propertyImages;
  // List<List<dynamic>> propertyAminities, propertyRoom, propertyMeal;
  GetAllProperty propertyDetails;
  int index;
  //List<GetAllProperty> propDataList;
  List<dynamic>? propData;
  PropertyDetailScreen(
      {Key? key, required this.propertyDetails, required this.index, this.propData})
      : super(key: key);

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

  double lat = 0.0, long = 0.0;

  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      'is properly setup. Look at firebase_dynamic_links/README.md for more '
      'details.';

  final String dynamicLink = 'https://beingpupil.com/public/api/property';
  final String link = 'https://bepshare.page.link/property';

 void _launchMapsUrl(double lat, double long) async {
  // final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   throw 'Could not launch $url';
  // }

  var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$long';
      url = "comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
       throw 'Could not launch $url';
    }
}

//compress image
// Future<Uint8List> testCompressFile(File file) async {
//     var result = await FlutterImageCompress.compressAssetImage(
//       file.absolute.path,
//       minWidth: 300,
//       minHeight: 200,
//       quality: 94,
//       rotate: 90,
//     );
//     print(file.lengthSync());
//     print(result!.length);
//     return result;
//   }

//create dynamic link
Future<void> _createDynamicLink(bool short, String id) async {
    setState(() {
      _isCreatingLink = true;
    });
print('create DL::: ${widget.propData![widget.index]['featured_image'][0].toString()}');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bepshare.page.link',
      link: Uri.parse("https://beingpupil.com/public/api/property/get?id=$id}"),
      androidParameters: const AndroidParameters(
        packageName: 'com.beingPupil',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.beingpupil',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: widget.propData![widget.index]['name'].toString(),
        description: widget.propData![widget.index]['location']['address'].toString(),
        imageUrl: Uri.parse(widget.propData![widget.index]['featured_image'][0].toString()),
      )
    );
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
       url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }
    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });

    Share.share(
      'Check out this property on Being Pupil App! $_linkMessage',
       subject: 'Download Being Pupil App!');
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
                child: Stack(
                  children: [
                    CarouselSlider(
                        carouselController: _controller,
                        items: //imgList
                            //widget.propertyDetails.data[widget.index].featuredImage
                            widget.propData![widget.index]['featured_image']
                                .map<Widget>((item) => Container(
                                      child: Center(
                                          child: Image.network(item,
                                              fit: BoxFit.cover, width: 1000)),
                                    ))
                                .toList(),
                        options: CarouselOptions(
                          height: 30.0.h,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.9,
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
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0.h, left: 0.5.w),
                      child: IconButton(
                        onPressed: () => _controller.previousPage(),
                        icon: Icon(Icons.chevron_left, color: Colors.white, size: 50,),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.0.h, right: 4.5.w),
                        child: IconButton(
                          onPressed: () => _controller.nextPage(),
                          icon: Icon(Icons.chevron_right, color: Colors.white, size: 50,),
                        ),
                      ),
                    ),
                  ],
                )),
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
                            itemCount: widget.propData![widget.index]['featured_image'].length,
                            //widget.propDataList[widget.index].data[widget.index].featuredImage.length,
                            // widget
                            //     .propertyDetails
                            //     .data[widget.index]
                            //     .featuredImage.length,
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
                                            image: NetworkImage(widget.propData![widget.index]['featured_image'] != null
                                              ? widget.propData![widget.index]['featured_image'][index]
                                              : '',
                                              //imgList[index]
                                            //widget.propDataList[widget.index].data[widget.index].featuredImage[index]
                                                // widget
                                                //     .propertyDetails
                                                //     .data[widget.index]
                                                //     .featuredImage[index]
                                                    ),
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
                  Text(widget.propData![widget.index]['name'] != null
                    ? widget.propData![widget.index]['name'] : 'Name not added',
                    //widget.propDataList[widget.index].data[widget.index].name,
                    //widget.propertyDetails.data[widget.index].name,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.w700,
                        color: Constants.bgColor),
                  ),
                  GestureDetector(
                    onTap: !_isCreatingLink 
                    ? () {
                      // Share.share(
                      //     'check out Being Pupil App! https://google.com',
                      //     subject: 'Download Being Pupil App!');
                      _createDynamicLink(true, widget.propData![widget.index]['property_id'].toString());
                            
                    }
                    : null,
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
              child: GestureDetector(
                onTap: () {
                  pushNewScreen(context,
                      screen: RatingReviewScreen(
                        propertyId: widget.propData![widget.index]['property_id'],
                        //propertyId: widget.propDataList[widget.index].data[widget.index].propertyId
                        //widget.propertyDetails.data[widget.index].propertyId,
                      ),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ImageIcon(AssetImage('assets/icons/greenStar.png'),
                        size: 18.0, color: Constants.selectedIcon),
                    SizedBox(
                      width: 1.0.w,
                    ),
                    Text(widget.propData![widget.index]['rating'] != null
                      ? '${widget.propData![widget.index]['rating'].toDouble()} Rating | ${widget.propData![widget.index]['review']} Review'
                      : '0 Rating | 0 Review',
                      //'${widget.propertyDetails.data[widget.index].rating} Rating | ${widget.propertyDetails.data[widget.index].review} Review',
                      //'${widget.propDataList[widget.index].data[widget.index].rating} Rating | ${widget.propDataList[widget.index].data[widget.index].review} Review',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Constants.blueTitle),
                    )
                  ],
                ),
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
            // Padding(
            //   padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 1.0.h),
            //   child: Row(
            //     children: [
            //       Text(
            //         'sit amet, consetetur sadipscing elitr, sed',
            //         style: TextStyle(
            //             fontFamily: 'Montserrat',
            //             fontSize: 10.0.sp,
            //             fontWeight: FontWeight.w600,
            //             color: Constants.blueTitle),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 1.0.h),
              child: Container(
                child: ReadMoreText(widget.propData![widget.index]['description'] != null
                  ? '${widget.propData![widget.index]['description']}' : '',
                  //'${widget.propertyDetails.data[widget.index].description}',
                  //'${widget.propDataList[widget.index].data[widget.index].description}',
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  colorClickableText: Constants.blueTitle,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 8.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Constants.bpOnBoardSubtitleStyle),
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
                          itemCount: widget.propData![widget.index]['amenities'].length,
                          //widget.propDataList[widget.index].data[widget.index].amenities.length,
                          // widget.propertyDetails.data[widget.index]
                          //     .amenities.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 4.5),
                          itemBuilder: (context, index) {
                            return ListTile(
                              //visualDensity: VisualDensity(horizontal: -4.0, vertical: 0.0),
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  //ImageIcon(
                                  Image.network(widget.propData![widget.index]['amenities'] != [] || widget.propData![widget.index]['amenities'] != null
                                    ? widget.propData![widget.index]['amenities'][index]['amenities_image'] : '',
                                    //widget.propDataList[widget.index].data[widget.index].amenities[index].amenitiesImage,
                                    // widget.propertyDetails.data[widget.index]
                                    //     .amenities[index].amenitiesImage,
                                    fit: BoxFit.contain,
                                  ),
                                  // size: 22.0,
                                  //color: Constants.bgColor,
                                  //),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(widget.propData![widget.index]['amenities'] != [] || widget.propData![widget.index]['amenities'] != null
                                    ? widget.propData![widget.index]['amenities'][index]['amenities_name'] : 'No name added',
                                    //widget.propDataList[widget.index].data[widget.index].amenities[index].amenitiesName,
                                    // widget.propertyDetails.data[widget.index]
                                    //     .amenities[index].amenitiesName,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 9.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bgColor),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  )),
            ),
            //Show map button
            GestureDetector(
              onTap: () {
              setState(() {
                lat = double.parse(widget.propData![widget.index]['location']['lat']);
                //double.parse(widget.propDataList[widget.index].data[widget.index].location.lat);
                long = double.parse(widget.propData![widget.index]['location']['lng']);
                //double.parse(widget.propDataList[widget.index].data[widget.index].location.lng);
                // lat = double.parse(widget.propertyDetails.data[widget.index].location.lat);
                // long = double.parse(widget.propertyDetails.data[widget.index].location.lng);
              });
              print(lat);
              print(long);
                _launchMapsUrl(lat, long);
              },
              child: Container(
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
            ),
            SizedBox(
              height: 3.0.h,
            ),
            //Book now button
            GestureDetector(
              onTap: () {
                pushNewScreen(context,
                    screen: BookPropertyScreen(
                      propertyDetails: widget.propertyDetails,
                      index: widget.index,
                      propData: widget.propData
                    ),
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
