import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Update_Course_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:jiffy/jiffy.dart';

class UpdateCourseScreen extends StatefulWidget {
  String? courseName, courseDescription, startDate, endDate;
  List<String>? linkList;
  int? courseId;
  UpdateCourseScreen({Key? key, 
  this.courseId,
  this.courseName, 
  this.courseDescription, 
  this.startDate, 
  this.endDate, 
  this.linkList}) : super(key: key);

  @override
  _UpdateCourseScreenState createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  //List<Widget> childeren = [];
  List<TextEditingController> linkControllers = [];//List<TextEditingController>();
  int linkCount = 1;
  DateTime? startDate, endDate;
  bool isStartDateSelected = false, isEndDateSelected = false;
  String? startDateInString, endDateInString, authToken;
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseDescController = TextEditingController();
  int wordCount = 0;
  // DateFormat dateFormat1 = DateFormat("dd MMMyyyy");
  // DateFormat dateFormat2 = DateFormat("dd/MM/yyyy");
  // var dateCheck = DateFormat.jm(DateTime.now());
  var startNewDate, endNewDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    //linkControllers.add(TextEditingController());
    startNewDate = Jiffy(widget.startDate!, 'dd MMM yyyy').format('dd/MM/yyyy');
    endNewDate = Jiffy(widget.endDate!, 'dd MMM yyyy').format('dd/MM/yyyy');
    courseNameController.text = widget.courseName!;
    courseDescController.text = widget.courseDescription!;
    startDateInString = startNewDate;
    endDateInString = endNewDate;
    for(int i = 0; i < widget.linkList!.length; i++){
      linkControllers.add(TextEditingController(text: widget.linkList![i]));
    }
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
  }

  wordCountForDescription(String str){
    setState((){
      wordCount = str.split(" ").length;
      //print('Total Word Count:::'+wordCount.toString());
    });
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
          'Update Course',
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
                      controller: courseNameController,
                      decoration: InputDecoration(
                        labelText: "Course Name",
                        labelStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat", 
                                  fontSize: 10.0.sp
                                ),
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
                      controller: courseDescController,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      //maxLength: 100,
                      decoration: InputDecoration(
                        labelText: "Course Description",
                        labelStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat", 
                                  fontSize: 10.0.sp
                                ),
                        alignLabelWithHint: true,
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
                     // print('Date Picker!!!');
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: new DateTime.now(),
                          lastDate: new DateTime(2100),
                          helpText: 'Select Course Date');
                      if (datePick != null && datePick != startDate) {
                        setState(() {
                          startDate = datePick;
                          isStartDateSelected = true;
                          if (startDate!.day.toString().length == 1 &&
                              startDate!.month.toString().length == 1) {
                            setState(() {
                              startDateInString =
                                  "0${startDate!.day.toString()}/0${startDate!.month}/${startDate!.year}";
                            });
                            //print('11111');
                          } else if (startDate!.day.toString().length == 1) {
                            setState(() {
                              startDateInString =
                                  "0${startDate!.day}/${startDate!.month}/${startDate!.year}";
                            });
                            //print('22222');
                          } else if (startDate!.month.toString().length == 1) {
                            startDateInString =
                                "${startDate!.day}/0${startDate!.month}/${startDate!.year}";
                          } else {
                            startDateInString =
                                "${startDate!.day}/${startDate!.month}/${startDate!.year}";
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
                            // isStartDateSelected
                            //     ? 
                                startDateInString!,
                                // : 'Starting Date',
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
                      //print('Date Picker!!!');
                      final datePick = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime.now(),
                          lastDate: new DateTime(2100),
                          helpText: 'Select Course Date');
                      if (datePick != null && datePick != endDate) {
                        setState(() {
                          endDate = datePick;
                          isEndDateSelected = true;
                          if (endDate!.day.toString().length == 1 &&
                              endDate!.month.toString().length == 1) {
                            setState(() {
                              endDateInString =
                                  "0${endDate!.day.toString()}/0${endDate!.month}/${endDate!.year}";
                            });
                           // print('11111');
                          } else if (endDate!.day.toString().length == 1) {
                            setState(() {
                              endDateInString =
                                  "0${endDate!.day}/${endDate!.month}/${endDate!.year}";
                            });
                           // print('22222');
                          } else if (endDate!.month.toString().length == 1) {
                            endDateInString =
                                "${endDate!.day}/0${endDate!.month}/${endDate!.year}";
                          } else {
                            endDateInString =
                                "${endDate!.day}/${endDate!.month}/${endDate!.year}";
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
                            //isEndDateSelected ? 
                            endDateInString!, //: 'End Date',
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
                  itemCount: linkControllers.length,
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
                          //height: 8.0.h,
                          width: 90.0.w,
                          child: TextFormField(
                            controller: linkControllers[index],
                            decoration: InputDecoration(
                                labelText: "Link",
                                labelStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat", 
                                  fontSize: 10.0.sp
                                ),
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
                                suffixIconConstraints: BoxConstraints(
                                  maxHeight: 30.0,
                                  maxWidth: 30.0,
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(right: 2.0.w),
                                  child: Image.asset(
                                    'assets/icons/link.png',
                                    color: Constants.formBorder,
                                  ),
                                )), //keyboardType: TextInputType.emailAddress,
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
                          if (linkControllers.length < 5) {
                            linkControllers.add(TextEditingController());
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
                  onTap: () {
                   // print('ADD!!!!');
                    wordCountForDescription(courseDescController.text);
                    if (courseNameController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please Enter Course Name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Constants.bgColor,
                        textColor: Colors.white,
                        fontSize: 10.0.sp,
                      );
                    } else if (courseDescController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please Enter Course Name',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Constants.bgColor,
                        textColor: Colors.white,
                        fontSize: 10.0.sp,
                      );
                    } else if (startNewDate == null) {
                      Fluttertoast.showToast(
                        msg: 'Please Select Start Date',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Constants.bgColor,
                        textColor: Colors.white,
                        fontSize: 10.0.sp,
                      );
                    } else if (endNewDate == null) {
                      Fluttertoast.showToast(
                        msg: 'Please Select End Date',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Constants.bgColor,
                        textColor: Colors.white,
                        fontSize: 10.0.sp,
                      );
                    }else if (linkControllers[0].text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Please Enter Course Link',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Constants.bgColor,
                        textColor: Colors.white,
                        fontSize: 10.0.sp,
                      );
                    }else if (wordCount > 100) {
                      Fluttertoast.showToast(
                        msg: 'Please Use 100 Words in Course Description',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Constants.bgColor,
                        textColor: Colors.white,
                        fontSize: 10.0.sp,
                      );
                    }
                     else {
                      updateCourseAPI();
                    }
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
                        'Update course'.toUpperCase(),
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

  //Create Course API
  Future<UpdateCourse> updateCourseAPI() async {
    displayProgressDialog(context);
    var result = UpdateCourse();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'course_id': widget.courseId!,
        'course_name': courseNameController.text,
        'course_description': courseDescController.text,
        'start_date': startDateInString,
        'end_date': endDateInString,
      });
      for (int i = 0; i < linkControllers.length; i++) {
        formData.fields
            .addAll([MapEntry('course_link[$i]', linkControllers[i].text)]);
      }
      var response = await dio.post(Config.updateCourseUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        //closeProgressDialog(context);
        result = UpdateCourse.fromJson(response.data);
       // print(response.data);
        if (result.status == true) {
           Fluttertoast.showToast(
            msg: result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return bottomNavBar(4);
              },
             ),
             (_) => false,
            );
        } else {
          closeProgressDialog(context);
          Fluttertoast.showToast(
            msg: result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: result.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    } on DioError catch (e, stack) {
      //print(e.response);
      //print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        //print("This is the error message::::" +
            //e.response!.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    }
    return result;
  }

  displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog();
        }));
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
