import 'package:being_pupil/ConnectyCube/consts.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:url_launcher/url_launcher.dart';

class LearnerProfileViewScreen extends StatefulWidget {
  final id;
  const LearnerProfileViewScreen({Key? key, this.id}) : super(key: key);

  @override
  _LearnerProfileViewScreenState createState() =>
      _LearnerProfileViewScreenState();
}

class _LearnerProfileViewScreenState extends State<LearnerProfileViewScreen> {
  Map<String, dynamic>? map = {};
  bool isLoading = true;
  String? authToken, registerAs;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    getUserProfile();
  }

  void _launchSocialUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          registerAs == 'L' ? 'Study Buddy' : 'Learner',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          height: 50.0.h,
          width: 100.0.w,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Constants.bgColor),
                  ),
                )
              : map!['data'] == null || map!['data'] == {}
                  ? Center(
                      child: Text(
                        'No Data Found!',
                        style: TextStyle(
                            fontSize: 12.0.sp,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Constants.bgColor),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0.h, horizontal: 4.0.w),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) => Material(
                                child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: greyColor2,
                                    child: Icon(
                                      Icons.person,
                                      size: 110,
                                      color: Colors.black,
                                    )),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: map!['data']['profile_image'],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Text(
                              map!['data']['name'],
                              style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Constants.bgColor),
                            ),
                          ),
                          map!['data']['last_degree'] == null
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: Text(
                                    '${map!['data']['last_degree']} | ${map!['data']['school_name']}',
                                    style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bgColor),
                                  ),
                                ),
                          map!['data']['City'] == null
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ImageIcon(
                                        AssetImage(
                                            'assets/icons/locationPin.png'),
                                        color: Constants.bgColor,
                                        size: 15.0,
                                      ),
                                      SizedBox(
                                        width: 0.5.w,
                                      ),
                                      Text(
                                        map!['data']['City'] != null
                                            ? map!['data']['City']
                                            : '',
                                        style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400,
                                            color: Constants.bgColor),
                                      ),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Visibility(
                                  visible: map!['data']['facebook_link'] == null
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchSocialUrl(
                                          map!['data']['facebook_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/fbSvg.svg')),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.0.w,
                                ),
                                Visibility(
                                  visible:
                                      map!['data']['instagram_link'] == null
                                          ? false
                                          : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchSocialUrl(
                                          map!['data']['instagram_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/instaSvg.svg')),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.0.w,
                                ),
                                Visibility(
                                  visible: map!['data']['linkedin_link'] == null
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchSocialUrl(
                                          map!['data']['linkedin_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/linkedinSvg.svg')),
                                  ),
                                ),
                                SizedBox(
                                  width: 1.0.w,
                                ),
                                Visibility(
                                  visible: map!['data']['other_link'] == null
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      _launchSocialUrl(
                                          map!['data']['other_link']);
                                    },
                                    child: Container(
                                        height: 4.0.h,
                                        width: 8.0.w,
                                        child: SvgPicture.asset(
                                            'assets/icons/otherSvg.svg')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Future<void> getUserProfile() async {
    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.myProfileUrl}/${widget.id}',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        map = response.data;

        if (map!['data'] != null) {
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
        });
      } else {
        throw response.statusCode!;
      }
    } on DioError catch (e, stack) {}
  }
}
