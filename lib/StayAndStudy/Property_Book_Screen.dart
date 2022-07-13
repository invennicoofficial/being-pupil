import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Check_Booking_Model.dart';
import 'package:being_pupil/Model/Stay_And_Study_Model/Get_All_Property_Model.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'Booking_Review_Screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class BookPropertyScreen extends StatefulWidget {
  GetAllProperty? propertyDetails;
  List<dynamic>? propData;
  int? index;
  BookPropertyScreen(
      {Key? key, this.index, this.propertyDetails, this.propData})
      : super(key: key);

  @override
  _BookPropertyScreenState createState() => _BookPropertyScreenState();
}

class _BookPropertyScreenState extends State<BookPropertyScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  DateTime? checkInDate, checkOutDate;
  bool isCheckedIn = false, isCheckedOut = false;
  String? checkInString, checkOutString, roomType = '';
  String? checkInStringDate, checkOutStringDate;
  List<String> mealList = ['Breakfast', 'Lunch', 'Dinner'];
  List<int> mealPriceList = [1000, 2000, 2000];
  List<String?> selectedMeal = [];
  List<int?> selectedMealId = [];
  List<bool> isMeal = [false, false, false];

  String? userName, userGender, userNumber, userEmail;
  double roomCharge = 0.0, mealCharge = 0.0, taxCharge = 500.0, total = 500.0;
  List<double> roomChargeList = [], mealChargeList = [];

  int selectedMonth = 0;
  bool isRoomSelected = false;

  String? authToken;
  int? roomId;
  int totalMonths = 1;

  @override
  void initState() {
    super.initState();
    getToken();
    for (int i = 0; i < widget.propData![widget.index!]['room'].length; i++) {
      roomChargeList.add(double.parse(
          widget.propData![widget.index!]['room'][i]['room_amount']));
    }
    for (int j = 0; j < widget.propData![widget.index!]['meal'].length; j++) {
      mealChargeList.add(double.parse(
          widget.propData![widget.index!]['meal'][j]['meal_amount']));
    }
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString('name');
      userNumber = preferences.getString('mobileNumber');
      userGender = preferences.getString('gender');
      userEmail = preferences.getString('email');
      _nameController.text = userName!;
      _mobileController.text = '+91$userNumber';
      _emailController.text = userEmail!;
      _genderController.text = userGender == 'M'
          ? 'Male'
          : userGender == 'F'
              ? 'Female'
              : 'Other';
    });
  }

  totalAmount() {
    setState(() {
      roomCharge = roomCharge * totalMonths;
      mealCharge = mealCharge * totalMonths;
      total = roomCharge + mealCharge + taxCharge;
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
            children: <Widget>[
              Theme(
                data: new ThemeData(
                  primaryColor: Constants.bpSkipStyle,
                  primaryColorDark: Constants.bpSkipStyle,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 4.0.w,
                    right: 4.0.w,
                    top: 3.0.h,
                  ),
                  child: CustomDropdown<int>(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                          child: Text(
                            'Select Room Type',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Constants.bpSkipStyle),
                          ),
                        ),
                      ],
                    ),
                    onChange: (String value, int index) async {
                      if (int.parse(value) == index + 1) {
                        setState(() {
                          isRoomSelected = true;
                          roomType = widget.propData![widget.index!]['room']
                              [index]['room_type'];
                          roomId = 1;
                          roomCharge = roomChargeList[index];
                          total = roomCharge + mealCharge + taxCharge;
                        });
                      }
                    },
                    dropdownButtonStyle: DropdownButtonStyle(
                      height: 7.0.h,
                      width: 90.0.w,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      primaryColor: Constants.bpSkipStyle,
                      side: BorderSide(color: Constants.formBorder),
                    ),
                    dropdownStyle: DropdownStyle(
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 6,
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0.w, vertical: 1.5.h),
                    ),
                    items: [
                      for (int i = 0;
                          i < widget.propData![widget.index!]['room'].length;
                          i++)
                        {
                          '${widget.propData![widget.index!]['room'][i]['room_type']}\t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t \t',
                          //₹${widget.propData![widget.index!]['room'][i]['room_amount']}',
                        }
                    ]
                        .asMap()
                        .entries
                        .map(
                          (item) => DropdownItem<int>(
                            value: item.key + 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                item.value.toString().substring(
                                    1, item.value.toString().length - 1),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Constants.bgColor),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 3.0.h, left: 4.0.w, right: 3.0.w),
                    child: Text(
                      'Select Meal',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0.sp,
                          color: Constants.bgColor,
                          fontWeight: FontWeight.w500),
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
                        EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 2.0.h),
                    child: ListView.builder(
                        itemCount:
                            widget.propData![widget.index!]['meal'].length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding:
                                  EdgeInsets.only(left: 0.0, right: 0.0),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      widget.propData![widget.index!]['meal']
                                          [index]['meal_type'],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          color: Color(0xFF6B737C),
                                          fontWeight: FontWeight.w400)),
                                  Visibility(
                                    visible: false,
                                    child: Text(
                                        '₹${widget.propData![widget.index!]['meal'][index]['meal_amount']}/mth',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10.0.sp,
                                            color: Color(0xFF6B737C),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                              activeColor: Constants.bgColor,
                              value: isMeal[index],
                              onChanged: (value) {
                                setState(() {
                                  isMeal[index] = !isMeal[index];
                                });

                                if (isMeal[index] == true) {
                                  setState(() {
                                    mealCharge = mealCharge +
                                        mealChargeList[index] * totalMonths;

                                    total = mealCharge + taxCharge + roomCharge;
                                    selectedMeal.add(
                                        widget.propData![widget.index!]['meal']
                                            [index]['meal_type']);

                                    selectedMealId.add(
                                        widget.propData![widget.index!]['meal']
                                            [index]['meal_id']);
                                  });
                                } else {
                                  setState(() {
                                    mealCharge = mealCharge -
                                        mealChargeList[index] * totalMonths;

                                    total = total -
                                        (int.parse(
                                                widget.propData![widget.index!]
                                                        ['meal'][index]
                                                    ['meal_amount']) *
                                            totalMonths);
                                    selectedMeal.remove(
                                        widget.propData![widget.index!]['meal']
                                            [index]['meal_type']);

                                    selectedMealId.remove(
                                        widget.propData![widget.index!]['meal']
                                            [index]['meal_id']);
                                  });
                                }
                              });
                        })),
              ),
              Visibility(
                visible: isRoomSelected ? true : false,
                child: Theme(
                  data: new ThemeData(
                    primaryColor: Constants.bpSkipStyle,
                    primaryColorDark: Constants.bpSkipStyle,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 3.0.h),
                    child: CustomDropdown<int>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                            child: Text(
                              'Select Number of Months',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bpSkipStyle),
                            ),
                          ),
                        ],
                      ),
                      onChange: (String value, int index) async {
                        roomCharge = roomCharge / totalMonths;
                        mealCharge = mealCharge / totalMonths;
                        total = 0.0;

                        total = roomCharge + mealCharge + taxCharge;

                        if (int.parse(value) == 1) {
                          setState(() {
                            selectedMonth = 1;
                            totalMonths = 1;
                            roomCharge = roomCharge * totalMonths;
                            mealCharge = mealCharge * totalMonths;

                            total = roomCharge + mealCharge + taxCharge;
                          });
                        } else if (int.parse(value) == 2) {
                          setState(() {
                            selectedMonth = 2;
                            totalMonths = 2;
                            roomCharge = roomCharge * totalMonths;
                            mealCharge = mealCharge * totalMonths;

                            total = roomCharge + mealCharge + taxCharge;
                          });
                        } else {
                          setState(() {
                            selectedMonth = 3;
                            totalMonths = 3;
                            roomCharge = roomCharge * totalMonths;
                            mealCharge = mealCharge * totalMonths;

                            total = roomCharge + mealCharge + taxCharge;
                          });
                        }
                      },
                      dropdownButtonStyle: DropdownButtonStyle(
                        height: 7.0.h,
                        width: 90.0.w,
                        elevation: 0,
                        backgroundColor: Colors.white,
                        primaryColor: Constants.bpSkipStyle,
                        side: BorderSide(color: Constants.formBorder),
                      ),
                      dropdownStyle: DropdownStyle(
                        borderRadius: BorderRadius.circular(10.0),
                        elevation: 6,
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0.w, vertical: 1.5.h),
                      ),
                      items: ['1', '2', '3']
                          .asMap()
                          .entries
                          .map(
                            (item) => DropdownItem<int>(
                              value: item.key + 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.value,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Constants.bgColor),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: selectedMonth == 0 ? false : true,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w, right: 4.0.w),
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: new ThemeData(
                          primaryColor: Constants.bpSkipStyle,
                          primaryColorDark: Constants.bpSkipStyle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.0.h),
                          child: GestureDetector(
                            onTap: () async {
                              final datePick = await showDatePicker(
                                  context: context,
                                  initialDate: new DateTime.now().add(const Duration(days: 1)),
                                  firstDate: new DateTime.now().add(const Duration(days: 1)),
                                  lastDate: new DateTime.now()
                                      .add(const Duration(days: 365)),
                                  helpText: 'Select Check In Date');
                              if (datePick != null && datePick != checkInDate) {
                                setState(() {
                                  checkInDate = datePick;
                                  isCheckedIn = true;

                                  if (checkInDate!.day.toString().length == 1 &&
                                      checkInDate!.month.toString().length ==
                                          1) {
                                    setState(() {
                                      checkInString =
                                          "0${checkInDate!.day.toString()}/0${checkInDate!.month}";
                                      checkInStringDate =
                                          "0${checkInDate!.day.toString()}/0${checkInDate!.month}/${checkInDate!.year}";
                                    });
                                  } else if (checkInDate!.day
                                          .toString()
                                          .length ==
                                      1) {
                                    setState(() {
                                      checkInString =
                                          "0${checkInDate!.day}/${checkInDate!.month}";
                                      checkInStringDate =
                                          "0${checkInDate!.day.toString()}/${checkInDate!.month}/${checkInDate!.year}";
                                    });
                                  } else if (checkInDate!.month
                                          .toString()
                                          .length ==
                                      1) {
                                    checkInString =
                                        "${checkInDate!.day}/0${checkInDate!.month}";
                                    checkInStringDate =
                                        "${checkInDate!.day.toString()}/0${checkInDate!.month}/${checkInDate!.year}";
                                  } else {
                                    checkInString =
                                        "${checkInDate!.day}/${checkInDate!.month}";
                                    checkInStringDate =
                                        "${checkInDate!.day.toString()}/${checkInDate!.month}/${checkInDate!.year}";
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 7.0.h,
                              width: 44.0.w,
                              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Constants.formBorder),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isCheckedIn ? checkInString! : 'Check In',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  ImageIcon(
                                      AssetImage('assets/icons/calendar.png'),
                                      size: 25,
                                      color: Constants.formBorder),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.0.w),
                      Theme(
                        data: new ThemeData(
                          primaryColor: Constants.bpSkipStyle,
                          primaryColorDark: Constants.bpSkipStyle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.0.h),
                          child: GestureDetector(
                            onTap: () async {
                              if (checkInDate != null) {
                                final datePick = await showDatePicker(
                                    context: context,
                                    initialDate: checkInDate!,
                                    firstDate: checkInDate!,
                                    lastDate:
                                        checkInDate!.add(selectedMonth == 1
                                            ? const Duration(days: 30)
                                            : selectedMonth == 2
                                                ? const Duration(days: 60)
                                                : const Duration(days: 90)),
                                    helpText: 'Select Check Out Date');
                                if (datePick != null &&
                                    datePick != checkOutDate) {
                                  setState(() {
                                    checkOutDate = datePick;
                                    isCheckedOut = true;

                                    if (checkOutDate!.day.toString().length ==
                                            1 &&
                                        checkOutDate!.month.toString().length ==
                                            1) {
                                      setState(() {
                                        checkOutString =
                                            "0${checkOutDate!.day.toString()}/0${checkOutDate!.month}";
                                        checkOutStringDate =
                                            "0${checkOutDate!.day.toString()}/0${checkOutDate!.month}/${checkOutDate!.year}";
                                      });
                                    } else if (checkOutDate!.day
                                            .toString()
                                            .length ==
                                        1) {
                                      setState(() {
                                        checkOutString =
                                            "0${checkOutDate!.day}/${checkOutDate!.month}";
                                        checkOutStringDate =
                                            "0${checkOutDate!.day.toString()}/${checkOutDate!.month}/${checkOutDate!.year}";
                                      });
                                    } else if (checkOutDate!.month
                                            .toString()
                                            .length ==
                                        1) {
                                      checkOutString =
                                          "${checkOutDate!.day}/0${checkOutDate!.month}";
                                      checkOutStringDate =
                                          "${checkOutDate!.day.toString()}/0${checkOutDate!.month}/${checkOutDate!.year}";
                                    } else {
                                      checkOutString =
                                          "${checkOutDate!.day}/${checkOutDate!.month}";
                                      checkOutStringDate =
                                          "${checkOutDate!.day.toString()}/${checkOutDate!.month}/${checkOutDate!.year}";
                                    }
                                  });
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please Select Check In Date First",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              }
                            },
                            child: Container(
                              height: 7.0.h,
                              width: 44.0.w,
                              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Constants.formBorder),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isCheckedOut
                                        ? checkOutString!
                                        : 'Check Out',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  ImageIcon(
                                      AssetImage('assets/icons/calendar.png'),
                                      size: 25,
                                      color: Constants.formBorder),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 3.0.h, left: 4.0.w, right: 3.0.w),
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0.sp,
                          color: Constants.bgColor,
                          fontWeight: FontWeight.w500),
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
                      EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 4.0.h),
                  child: Container(
                    height: 7.0.h,
                    child: TextFormField(
                      controller: _nameController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            color: Constants.bpSkipStyle,
                            fontFamily: "Montserrat",
                            fontSize: 10.0.sp),
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
                          ),
                        ),
                      ),
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
                      EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 4.0.h),
                  child: Container(
                    height: 7.0.h,
                    child: TextFormField(
                      controller: _genderController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: TextStyle(
                            color: Constants.bpSkipStyle,
                            fontFamily: "Montserrat",
                            fontSize: 10.0.sp),
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
                          ),
                        ),
                      ),
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
                      EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 4.0.h),
                  child: Container(
                    height: 7.0.h,
                    child: TextFormField(
                      controller: _emailController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Constants.bpSkipStyle,
                            fontFamily: "Montserrat",
                            fontSize: 10.0.sp),
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
                          ),
                        ),
                      ),
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
                      EdgeInsets.only(left: 4.0.w, right: 4.0.w, top: 3.0.h),
                  child: Container(
                    height: 7.0.h,
                    child: TextFormField(
                      controller: _mobileController,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        labelStyle: TextStyle(
                            color: Constants.bpSkipStyle,
                            fontFamily: "Montserrat",
                            fontSize: 10.0.sp),
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
                          ),
                        ),
                      ),
                      style: new TextStyle(
                          fontFamily: "Montserrat", fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 4.0.w, right: 4.0.w, top: 3.0.h, bottom: 3.0.h),
                  child: Divider(
                    color: Constants.formBorder,
                    height: 2.0.h,
                    thickness: 1.0,
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: Container(
                  width: 100.0.w,
                  padding: EdgeInsets.only(
                      left: 4.0.w, right: 4.0.w, top: 3.0.h, bottom: 3.0.h),
                  color: Color(0xFFD3D9E0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Summary',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Constants.bgColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: 'Room Charges ',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Constants.bgColor)),
                              TextSpan(
                                  text: roomType == null || roomType == ''
                                      ? ''
                                      : '($roomType)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Constants.blueTitle)),
                            ])),
                            Text(
                              roomCharge == 0 ? '₹0' : '₹$roomCharge',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Meal Charges',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                            Text(
                              mealCharge == 0 ? '₹0' : '₹$mealCharge',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Taxes & Fees',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                            Text(
                              '₹$taxCharge',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h),
                        child: Divider(
                          color: Constants.formBorder,
                          height: 2.0.h,
                          thickness: 1.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w700,
                                color: Constants.bgColor),
                          ),
                          Text(
                            total == 0 ? '₹0' : '₹$total',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w700,
                                color: Constants.bgColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0.h),
                child: GestureDetector(
                  onTap: () {
                    if (isRoomSelected == false) {
                      Fluttertoast.showToast(
                          msg: "Please Select Room Type",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp);
                    } else if (selectedMonth == 0) {
                      Fluttertoast.showToast(
                          msg: "Please Select Number of Months",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp);
                    } else if (checkInDate == null) {
                      Fluttertoast.showToast(
                          msg: "Please Select Check In Date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp);
                    } else if (checkOutDate == null) {
                      Fluttertoast.showToast(
                          msg: "Please Select Check Out Date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp);
                    } else {
                      checkBookingDateAPI();
                    }
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
                        'Continue'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 11.0.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<CheckBooking> checkBookingDateAPI() async {
    displayProgressDialog(context);

    var result = CheckBooking();
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap({
        'stay_months': selectedMonth,
        'checkIn_date': '$checkInStringDate 09:10:22 AM',
        'checkOut_date': '$checkOutStringDate 09:10:22 AM'
      });
      var response = await dio.post(Config.bookingCheckUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        result = CheckBooking.fromJson(response.data);

        if (result.status == true) {
          pushNewScreen(context,
              screen: BookingReviewScreen(
                name: userName,
                mobileNumber: userNumber,
                email: userEmail,
                checkIn: DateFormat('EEE, dd MMM yyyy')
                    .format(checkInDate!)
                    .toString(),
                checkOut: DateFormat('EEE, dd MMM yyyy')
                    .format(checkOutDate!)
                    .toString(),
                checkInDateFormat: '$checkInStringDate 09:10:22 AM',
                checkOutDateFormat: '$checkOutStringDate 09:10:22 AM',
                roomType: roomType,
                meal: selectedMeal.toString(),
                mealId: selectedMealId,
                roomCharge: roomCharge.toDouble(),
                mealCharge: mealCharge.toDouble(),
                taxCharge: taxCharge.toDouble(),
                total: total.toDouble(),
                propertyDetails: widget.propData,
                index: widget.index,
                roomId: roomId,
                stayMonths: selectedMonth,
              ),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino);
        } else {
          Fluttertoast.showToast(
            msg: result.message == null ? result.errorMsg : result.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
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
      } else {}
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
