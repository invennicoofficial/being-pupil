import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Login/Login_Screen.dart';
import 'package:being_pupil/Registration/Basic_Registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  bool isOnboard = false;

  @override
  void initState() {
    // //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 1.5.w),
      height: isActive ? 1.0.h : 1.0.h,
      width: isActive ? 2.0.w : 2.0.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    var _textH1 = TextStyle(
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w600,
        fontSize: 16.0.sp,
        color: Constants.bpOnBoardTitleStyle);

    var _textH2 = TextStyle(
        height: 0.2.h,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w400,
        fontSize: 12.0.sp,
        color: Constants.bpOnBoardSubtitleStyle);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
                          onTap: () {
                            //_currentPage = _numPages - 1;
                          },
                          child: _currentPage != 0
                              ? GestureDetector(
                                  onTap: _currentPage == 2 
                                  ? () {
                                    _pageController.jumpToPage(1);
                                  }
                                  : () {
                                    _pageController.jumpToPage(0);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Icon(Icons.arrow_back_ios,
                                        color: Constants.bgColor.withOpacity(0.8)),
                                  ),
                                )
                              : Container()),
                              actions: [
                                 _currentPage != 2
                          ? Container(
                            padding: EdgeInsets.only(top: 10.0),
                            //color: Colors.grey,
                              alignment: Alignment.topRight,
                              child: FlatButton(
                                onPressed: () => _pageController.jumpToPage(2),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bpSkipStyle,
                                    fontSize: 11.0.sp,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                              ],
      ),
      
      // PreferredSize(
      //   preferredSize: Size.fromHeight(13.0.h),
      //   child: Container(
      //     color: Colors.grey,
      //     child: SafeArea(
      //       child: Column(
      //         children: <Widget>[
      //           Padding(
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 3.0.h),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 GestureDetector(
      //                     onTap: () {
      //                       //_currentPage = _numPages - 1;
      //                     },
      //                     child: _currentPage != 0
      //                         ? GestureDetector(
      //                             onTap: _currentPage == 2 
      //                             ? () {
      //                               _pageController.jumpToPage(1);
      //                             }
      //                             : () {
      //                               _pageController.jumpToPage(0);
      //                             },
      //                             child: Icon(Icons.arrow_back_ios,
      //                                 color: Constants.bgColor),
      //                           )
      //                         : Container()),
      //                 _currentPage != 2
      //                     ? Container(
      //                         alignment: Alignment.topRight,
      //                         child: FlatButton(
      //                           onPressed: () => _pageController.jumpToPage(2),
      //                           child: Text(
      //                             'Skip',
      //                             style: TextStyle(
      //                               fontFamily: 'Montserrat',
      //                               fontWeight: FontWeight.w400,
      //                               color: Constants.bpSkipStyle,
      //                               fontSize: 11.0.sp,
      //                             ),
      //                           ),
      //                         ),
      //                       )
      //                     : Container(),
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: Container(
        //padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 3.0.h),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: <Widget>[
                    // Screen 1
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.w, vertical: 0.0.h),
                          child: Image(
                            image: AssetImage('assets/images/onBoard11.png'),
                            height: 30.0.h,
                            width: 80.0.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Lorem ipsum dolor sit amet,',
                                  style: _textH1,
                                ),
                                SizedBox(height: 2.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.5.w, vertical: 1.0.h),
                                  child: Container(
                                    //color: Colors.grey,
                                    height: 15.0.h,
                                    width: 82.0.w,
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore',
                                      textAlign: TextAlign.center,
                                      style: _textH2,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Screen 2
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 3.0.w, right: 3.0.w, bottom: 3.5.h),
                          child: Image(
                            image: AssetImage('assets/images/onBoard.png'),
                            height: 30.0.h,
                            width: 80.0.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 0.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Lorem ipsum dolor sit amet,',
                                  style: _textH1,
                                ),
                                SizedBox(height: 2.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.5.w, vertical: 1.0.h),
                                  child: Container(
                                    height: 15.0.h,
                                    width: 82.0.w,
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore',
                                      textAlign: TextAlign.center,
                                      style: _textH2,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Screen 3
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.0.w, vertical: 0),
                          child: Image(
                            image: AssetImage('assets/images/onBoard33.png'),
                            height: 30.0.h,
                            width: 80.0.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4.0.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Lorem ipsum dolor sit amet,',
                                  style: _textH1,
                                ),
                               // SizedBox(height: 2.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1.5.w, vertical: 1.0.h),
                                  child: Container(
                                    height: 15.0.h,
                                    width: 82.0.w,
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore',
                                      textAlign: TextAlign.center,
                                      style: _textH2,
                                      softWrap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Padding(
                  padding: EdgeInsets.only(top: 60.0.h),
                  child: _currentPage != 2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: LoginScreen()));
                          },
                          child: Container(
                            height: 8.0.h,
                            width: 80.0.w,
                            decoration: BoxDecoration(
                                color: Constants.bgColor,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                              child: Text('GET STARTED',
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0.sp,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
