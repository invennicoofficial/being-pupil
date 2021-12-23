import 'dart:async';

import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OnBoarding_Screens/OnBoarding_Screen.dart';
import 'package:sizer/sizer.dart';

import 'Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/ConnectyCube/configs.dart' as config;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return LayoutBuilder(builder: (context, constraints) {
      return Sizer(builder: (context, orientation, deviceType) {
        //SizerUtil().init(constraints, orientation);
        return MaterialApp(
            theme: ThemeData(
                primaryColor: Constants.bgColor,
                accentColor: Constants.bgColor.withOpacity(0.5)),
            debugShowCheckedModeBanner: false,
            home: SplashScreen());
    //   });
     });
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? isNew, registerAs;
  bool? isLoggedIn;

  late StreamSubscription<ConnectivityResult> connectivityStateSubscription;
  AppLifecycleState? appState;


  @override
  void initState() {
    // TODO: implement initState
    // //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => OnBoardingScreen())));
    init(config.APP_ID, config.AUTH_KEY, config.AUTH_SECRET,
        onSessionRestore: () async {
          SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
          CubeUser? user = sharedPrefs.getUser();

          return createSession(user);
        });

    connectivityStateSubscription =
        Connectivity().onConnectivityChanged.listen((connectivityType) {
          print('yaaha');
          if (AppLifecycleState.resumed != appState) return;

          if (connectivityType != ConnectivityResult.none) {
            log("chatConnectionState = ${CubeChatConnection.instance.chatConnectionState}");
            bool isChatDisconnected =
                CubeChatConnection.instance.chatConnectionState ==
                    CubeChatConnectionState.Closed ||
                    CubeChatConnection.instance.chatConnectionState ==
                        CubeChatConnectionState.ForceClosed;

            if (isChatDisconnected &&
                CubeChatConnection.instance.currentUser != null) {
              print('yaaha');
              CubeChatConnection.instance.relogin();
            }
          }
        });

    appState = WidgetsBinding.instance!.lifecycleState;
    // WidgetsBinding.instance.addObserver(this);

    getLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    connectivityStateSubscription.cancel();

    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("Current app state: $state");
    appState = state;

    if (AppLifecycleState.paused == state) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        print('yaaha1');
        CubeChatConnection.instance.logout();
      }
    } else if (AppLifecycleState.resumed == state) {
      SharedPrefs.instance.init().then((sharedPrefs) {
        CubeUser? user = sharedPrefs.getUser();
        print('yaaha2');

        if (user != null && !CubeChatConnection.instance.isAuthenticated()) {
          print('yaaha3');
          CubeChatConnection.instance.login(user);
        }
      });
    }
  }

  getLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    registerAs = preferences.getString('RegisterAs');
    isNew = preferences.getString('isNew');
    isLoggedIn = preferences.getBool('isLoggedIn');
    // print('isNew:::' + isNew);
    // print('isLoggedIn:::'+isLoggedIn.toString());
    setState(() {});
    _timer();
  }

  void _navigator() {
    if (registerAs == 'E') {
      if (isLoggedIn == true) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => bottomNavBar(0),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
       } 
      else  {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => OnBoardingScreen(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
      }
    } else {
      if(isLoggedIn == true){
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => bottomNavBar(0),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          }));
      } else{
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => OnBoardingScreen(),
            transitionDuration: Duration(milliseconds: 1000),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
      }
    }
  }

  _timer() async {
    return Timer(Duration(milliseconds: 3000), _navigator);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.bgColor,
        body: Stack(
          children: [
            Container(
              height: 100.0.h,
              width: 100.0.w,
              decoration: BoxDecoration(
                color: Constants.bgColor,
              ),
              child: Image.asset('assets/images/background.png',
                  fit: BoxFit.cover),
            ),
            Center(
              child: Image.asset(
                'assets/images/beingPupil.png',
                height: 15.0.h,
                width: 90.0.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 18.0.h),
              child: Center(
                child: Text(
                  'Student of Life',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
