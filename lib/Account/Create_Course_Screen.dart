import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({Key key}) : super(key: key);

  @override
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  int linkCount = 1;
  DateTime startDate, endDate;
  bool isStartDateSelected = false, isEndDateSelected = false;
  String startDateInString, endDateInString;

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
          'Create Course',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w, bottom: 2.0.h),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 4.0.h),
                  child: Container(
                    height: 7.0.h,
                    width: 90.0.w,
                    child: TextFormField(
                      //controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Constants.formBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Constants.formBorder,
                            //width: 2.0,
                          ),
                        ),
                      ),
                      //keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                          fontFamily: "Montserrat", fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ),
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                  child: Container(
                    height: 13.0.h,
                    width: 90.0.w,
                    child: TextFormField(
                      //controller: _achivementController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      //maxLength: 100,
                      decoration: InputDecoration(
                        labelText: "Course Description",
                        //counterText: '',
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Constants.formBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Constants.formBorder,
                            //width: 2.0,
                          ),
                        ),
                        // hintText:
                        //     "Please mention your achivements..."
                      ),
                      //keyboardType: TextInputType.emailAddress,
                      style: new TextStyle(
                          fontFamily: "Montserrat", fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 0.5.h),
                    child: Text(
                      'Maximum 100 words',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 8.0.sp,
                          color: Constants.bpSkipStyle,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                  child: GestureDetector(
                    onTap: () async {
                      print('Date Picker!!!');
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100),
                          helpText: 'Select Birth Date');
                      if (datePick != null && datePick != startDate) {
                        setState(() {
                          startDate = datePick;
                          isStartDateSelected = true;
                          if (startDate.day.toString().length == 1 &&
                              startDate.month.toString().length == 1) {
                            setState(() {
                              startDateInString =
                                  "0${startDate.day.toString()}/0${startDate.month}/${startDate.year}";
                            });
                            print('11111');
                          } else if (startDate.day.toString().length == 1) {
                            setState(() {
                              startDateInString =
                                  "0${startDate.day}/${startDate.month}/${startDate.year}";
                            });
                            print('22222');
                          } else if (startDate.month.toString().length == 1) {
                            startDateInString =
                                "${startDate.day}/0${startDate.month}/${startDate.year}";
                          } else {
                            startDateInString =
                                "${startDate.day}/${startDate.month}/${startDate.year}";
                          }
                          // 08/14/2019
                        });
                      }
                    },
                    child: Container(
                      height: 7.0.h,
                      width: 90.0.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Constants.formBorder),
                        borderRadius: BorderRadius.circular(5.0),
                        //color: Colors.transparent,//Color(0xFFA8B4C1).withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isStartDateSelected
                                ? startDateInString
                                : 'Starting Date',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Constants.bpSkipStyle),
                          ),
                          ImageIcon(AssetImage('assets/icons/calendar.png'),
                              size: 25, color: Constants.formBorder),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                  child: GestureDetector(
                    onTap: () async {
                      print('Date Picker!!!');
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(1900),
                          lastDate: new DateTime(2100),
                          helpText: 'Select Birth Date');
                      if (datePick != null && datePick != endDate) {
                        setState(() {
                          endDate = datePick;
                          isEndDateSelected = true;
                          if (endDate.day.toString().length == 1 &&
                              endDate.month.toString().length == 1) {
                            setState(() {
                              endDateInString =
                                  "0${endDate.day.toString()}/0${endDate.month}/${endDate.year}";
                            });
                            print('11111');
                          } else if (endDate.day.toString().length == 1) {
                            setState(() {
                              endDateInString =
                                  "0${endDate.day}/${endDate.month}/${endDate.year}";
                            });
                            print('22222');
                          } else if (endDate.month.toString().length == 1) {
                            endDateInString =
                                "${endDate.day}/0${endDate.month}/${endDate.year}";
                          } else {
                            endDateInString =
                                "${endDate.day}/${endDate.month}/${endDate.year}";
                          }
                          // 08/14/2019
                        });
                      }
                    },
                    child: Container(
                      height: 7.0.h,
                      width: 90.0.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Constants.formBorder),
                        borderRadius: BorderRadius.circular(5.0),
                        //color: Colors.transparent,//Color(0xFFA8B4C1).withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEndDateSelected ? endDateInString : 'End Date',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Constants.bpSkipStyle),
                          ),
                          ImageIcon(AssetImage('assets/icons/calendar.png'),
                              size: 25, color: Constants.formBorder),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 4.0.h, left: 3.0.w, right: 3.0.w),
                    child: Text(
                      'Add course links',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0.sp,
                          color: Constants.bgColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  itemCount: linkCount,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Theme(
                      data: new ThemeData(
                        primaryColor: Constants.bpSkipStyle,
                        primaryColorDark: Constants.bpSkipStyle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3.0.w, right: 3.0.w, top: 3.0.h),
                        child: Container(
                          height: 7.0.h,
                          width: 90.0.w,
                          child: TextFormField(
                            //controller: _fbLinkController,
                            decoration: InputDecoration(
                                labelText: "Link",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                    //width: 2.0,
                                  ),
                                ),
                                suffixIcon: //Image.asset('assets/icons/IconLink.png', fit: BoxFit.contain,),
                                Icon(
                                  Icons.link,
                                  size: 25,
                                  color: Constants.formBorder,
                                )
                                ), //keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                                fontFamily: "Montserrat", fontSize: 10.0.sp),
                          ),
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                child: Container(
                  width: 35.0.w,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (linkCount < 5) {
                            linkCount = linkCount + 1;
                          } else {
                            Fluttertoast.showToast(
                                msg: "You can add only 5 links",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Constants.bgColor,
                                textColor: Colors.white,
                                fontSize: 10.0.sp);
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            size: 15.0,
                            color: Constants.bpSkipStyle,
                          ),
                          Text(
                            'More Links',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Constants.bpSkipStyle),
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                child: GestureDetector(
                  onTap: (){
                    print('ADD!!!!');
                    Navigator.of(context).pop();
                  },
                                  child: Container(
                    height: 7.0.h,
                    width: 90.0.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Constants.bgColor,
                        ),
                        color: Constants.bgColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        'Add course'.toUpperCase(),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0.sp,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
