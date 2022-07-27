import 'dart:async';

import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/StayAndStudy/Property_Details_Screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/Config.dart';
import 'Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'OnBoarding_Screens/OnBoarding_Screen.dart';
import 'package:sizer/sizer.dart';

import 'Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/ConnectyCube/configs.dart' as config;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   apiKey: 'AIzaSyCOc_EWntBuVdxSnXNMdeHNTNVCaOvopZE',
    //   appId: '1:105158486640:ios:3fa0f8720b7ecc004be2b5',
    //   messagingSenderId: '105158486640',
    //   projectId: 'being-pupil-aca7f',
    //   authDomain: 'beingpupil.com',
    //   iosClientId:
    //       '448618578101-4km55qmv55tguvnivgjdiegb3r0jquv5.apps.googleusercontent.com',
    // ),
  );
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

  
  //String? authToken;
  
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

  // getToken() async {
  //   authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
  // }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.bgColor,
        body: 
        // Stack(
        //   children: [
            Container(
              height: 100.0.h,
              width: 100.0.w,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
              child: Image.asset(
                'assets/images/beingPupil.png',
                height: 15.0.h,
                width: 90.0.w,
              ),
            ),
            ),
            // Center(
            //   child: Image.asset(
            //     'assets/images/beingPupil.png',
            //     height: 15.0.h,
            //     width: 90.0.w,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: 18.0.h),
            //   child: Center(
            //     child: Text(
            //       'Student of Life',
            //       style: TextStyle(
            //           fontSize: 16.0,
            //           color: Colors.white,
            //           fontFamily: 'Montserrat',
            //           fontWeight: FontWeight.w400),
            //     ),
            //   ),
            // )
        //   ],
        // ),
      ),
    );
  }
}
