import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CourseDetailScrenn extends StatefulWidget {
  const CourseDetailScrenn({Key key}) : super(key: key);

  @override
  _CourseDetailScrennState createState() => _CourseDetailScrennState();
}

class _CourseDetailScrennState extends State<CourseDetailScrenn> {
  String registerAs;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    print(registerAs);
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
        actions: <Widget>[
          registerAs == 'E'
              ? Padding(
                  padding: EdgeInsets.only(right: 0.0.w),
                  child: Center(
                      child: FlatButton(
                    onPressed: () {
                      print('EDIT!!!');
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                  )),
                )
              : Container(),
        ],
        title: Text(
          'Course',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 4.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Course name come',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w700,
                      color: Constants.bgColor),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/cal.png',
                      height: 4.0.h,
                      width: 5.5.w,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: 2.0.w,
                    ),
                    Text('21 Jan 2021 to 21 Mar 2021',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bgColor)),
                  ],
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Container(
                  child: Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Constants.bgColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Container(
                          height: 7.0.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constants.formBorder),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 7.0.h,
                                width: 20.0.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/postImage.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              SizedBox(
                                width: 2.0.w,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    height: 5.0.h,
                                    //width: 70.0.w,
                                    child: Center(
                                      child: Text(
                                        'www.youtube.com/watch?v=5VYb3B1ETlk',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Constants.bgColor),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
