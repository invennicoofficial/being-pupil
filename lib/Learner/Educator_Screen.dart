import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EducatorScreen extends StatefulWidget {
  EducatorScreen({Key key}) : super(key: key);

  @override
  _EducatorScreenState createState() => _EducatorScreenState();
}

class _EducatorScreenState extends State<EducatorScreen> {
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
          onPressed: //null,
              () {
                //  Navigator.of(context).push
                //                     //pushAndRemoveUntil
                //                     (MaterialPageRoute(
                //                         builder: (context) => bottomNavBar(0)));
             Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null)
        ],
        title: Text(
          'Learners',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                child: Padding(
                  padding: EdgeInsets.only(left: 2.0.w),
                  child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/images/dp2.png',
                              width: 8.5.w,
                              height: 5.0.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rebecca Wells",
                                style: TextStyle(
                                    fontSize: 9.0.sp,
                                    color: Constants.bgColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "B.tech I M.S University",
                                style: TextStyle(
                                    fontSize: 6.5.sp,
                                    color: Constants.bgColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 2.0.w),
                        child: GestureDetector(
                          onTap: () {
                            print('$index is Connected');
                          },
                          child: Container(
                            height: 3.0.h,
                            width: 16.0.w,
                            decoration: BoxDecoration(
                                border: Border.all(color: Constants.bgColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Center(
                              child: Text(
                                'Connect',
                                style: TextStyle(
                                    fontSize: 8.0.sp,
                                    color: Constants.bgColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              );
            }),
      ),
    );
  }
}
