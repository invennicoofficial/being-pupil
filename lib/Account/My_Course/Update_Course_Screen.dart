import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Course_Model/Update_Course_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
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
  UpdateCourseScreen(
      {Key? key,
      this.courseId,
      this.courseName,
      this.courseDescription,
      this.startDate,
      this.endDate,
      this.linkList})
      : super(key: key);

  @override
  _UpdateCourseScreenState createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  List<TextEditingController> linkControllers = [];
  int linkCount = 1;
  DateTime? startDate, endDate;
  bool isStartDateSelected = false, isEndDateSelected = false;
  String? startDateInString, endDateInString, authToken;
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseDescController = TextEditingController();
  int wordCount = 0;

  var startNewDate, endNewDate;

  @override
  void initState() {
    super.initState();
    getToken();

    startNewDate = Jiffy(widget.startDate!, 'dd MMM yyyy').format('dd/MM/yyyy');
    endNewDate = Jiffy(widget.endDate!, 'dd MMM yyyy').format('dd/MM/yyyy');
    courseNameController.text = widget.courseName!;
    courseDescController.text = widget.courseDescription!;
    startDateInString = startNewDate;
    endDateInString = endNewDate;
    for (int i = 0; i < widget.linkList!.length; i++) {
      linkControllers.add(TextEditingController(text: widget.linkList![i]));
    }
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
  }

  wordCountForDescription(String str) {
    setState(() {
      wordCount = str.split(" ").length;
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
              TextInputWidget(
                  textEditingController: courseNameController,
                  lable: 'Course Name'),
              MultilineTextInput(
                  textEditingController: courseDescController,
                  hint: 'ourse Description'),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 2.0.w, right: 2.0.w, top: 0.5.h),
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
              Padding(
                padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                child: GestureDetector(
                  onTap: () async {
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
                        } else if (startDate!.day.toString().length == 1) {
                          setState(() {
                            startDateInString =
                                "0${startDate!.day}/${startDate!.month}/${startDate!.year}";
                          });
                        } else if (startDate!.month.toString().length == 1) {
                          startDateInString =
                              "${startDate!.day}/0${startDate!.month}/${startDate!.year}";
                        } else {
                          startDateInString =
                              "${startDate!.day}/${startDate!.month}/${startDate!.year}";
                        }
                      });
                    }
                  },
                  child: Container(
                    height: Constants.constHeight,
                    width: 90.0.w,
                    padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.formBorder),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDateInString!,
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
              Padding(
                padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
                child: GestureDetector(
                  onTap: () async {
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
                        } else if (endDate!.day.toString().length == 1) {
                          setState(() {
                            endDateInString =
                                "0${endDate!.day}/${endDate!.month}/${endDate!.year}";
                          });
                        } else if (endDate!.month.toString().length == 1) {
                          endDateInString =
                              "${endDate!.day}/0${endDate!.month}/${endDate!.year}";
                        } else {
                          endDateInString =
                              "${endDate!.day}/${endDate!.month}/${endDate!.year}";
                        }
                      });
                    }
                  },
                  child: Container(
                    height: Constants.constHeight,
                    width: 90.0.w,
                    padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.formBorder),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endDateInString!,
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
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 3.0.h, left: 3.0.w, right: 3.0.w),
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
                    return Row(
                      children: [
                        LinkInputWidget(
                          textEditingController: linkControllers[index],
                          lable: 'Link',
                          moreLink: true,
                        ),
                        GestureDetector(
                            onTap: () {
                              if (linkControllers.length > 1) {
                                setState(() {
                                  linkControllers.removeAt(index);
                                });
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.5.h),
                              child: ImageIcon(
                                AssetImage('assets/icons/close_icon.png'),
                                color: Constants.bpSkipStyle,
                                size: 20.0,
                              ),
                            )),
                      ],
                    );
                  }),
              Padding(
                padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w, top: 3.0.h),
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
                padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w, top: 3.0.h),
                child: GestureDetector(
                    onTap: () {
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
                      } else if (linkControllers[0].text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please Enter Course Link',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp,
                        );
                      } else if (wordCount > 100) {
                        Fluttertoast.showToast(
                          msg: 'Please Use 100 Words in Course Description',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp,
                        );
                      } else {
                        updateCourseAPI();
                      }
                    },
                    child: ButtonWidget(
                      btnName: 'UPDATE COURSE',
                      isActive: true,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        result = UpdateCourse.fromJson(response.data);

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
      closeProgressDialog(context);
      if (e.response != null) {
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
