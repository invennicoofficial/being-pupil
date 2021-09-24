import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class BookPropertyScreen extends StatefulWidget {
  BookPropertyScreen({Key key}) : super(key: key);

  @override
  _BookPropertyScreenState createState() => _BookPropertyScreenState();
}

class _BookPropertyScreenState extends State<BookPropertyScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  DateTime checkInDate, checkOutDate;
  bool isCheckedIn = false, isCheckedOut = false;
  String checkInString, checkOutString, roomType = '';

  List<String> mealList = ['Breakfast', 'Lunch', 'Dinner'];
  List<int> mealPriceList = [1000, 2000, 2000];
  //List<String> mealPriceList = ['₹1000/mth', '₹2000/mth', '₹2000/mth'];
  List<bool> isMeal = [false, false, false];

  String userName, userGender, userNumber;
  int roomCharge = 0, mealCharge = 0, taxCharge = 500, total = 500;

  int selectedMonth = 0;

  // List<String> sharingList = ['Single Sharing', 'Double Sharing'];
  // List<String> sharingPriceList = ['₹4000/mth', '₹6000/mth'];

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString('name');
      userNumber = preferences.getString('mobileNumber');
      userGender = preferences.getString('gender');
      _nameController.text = userName;
      _mobileController.text = '+91$userNumber';
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
                        //SizedBox(width: 50.0.w)
                      ],
                    ),
                    // icon: Icon(
                    //   Icons.expand_more,
                    //   color: Constants.bpSkipStyle,
                    // ),
                    onChange: (int value, int index) async {
                      print(value);
                      if (value == 1) {
                        setState(() {
                          roomType = 'Single Sharing';
                          roomCharge = 4000;
                          total = roomCharge + mealCharge + taxCharge;
                        });
                      } else {
                        setState(() {
                          roomType = 'Double Sharing';
                          roomCharge = 6000;
                          total = roomCharge + mealCharge + taxCharge;
                        });
                      }
                    },
                    dropdownButtonStyle: DropdownButtonStyle(
                      height: 7.0.h,
                      width: 90.0.w,
                      //padding: EdgeInsets.only(left: 2.0.w),
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
                      'Single Sharing                           ₹4000/mth',
                      'Double Sharing                         ₹6000/mth'
                    ]
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
                        itemCount: mealList.length,
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
                                  Text(mealList[index],
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          color: Color(0xFF6B737C),
                                          fontWeight: FontWeight.w400)),
                                  Text(
                                      '₹${mealPriceList[index]}/mth'.toString(),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          color: Color(0xFF6B737C),
                                          fontWeight: FontWeight.w400)),
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
                                    mealCharge =
                                        mealCharge + mealPriceList[index];
                                    total = mealCharge + taxCharge + roomCharge;
                                  });
                                } else {
                                  setState(() {
                                    mealCharge =
                                        mealCharge - mealPriceList[index];
                                    total = total - mealCharge;
                                  });
                                }
                              });
                        })),
              ),
              Theme(
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
                        //SizedBox(width: 50.0.w)
                      ],
                    ),
                    // icon: Icon(
                    //   Icons.expand_more,
                    //   color: Constants.bpSkipStyle,
                    // ),
                    onChange: (int value, int index) async {
                      print(value);
                      if (value == 1) {
                        setState(() {
                          selectedMonth = 1;
                        });
                      } else if (value == 2) {
                        setState(() {
                          selectedMonth = 2;
                        });
                      } else {
                        setState(() {
                          selectedMonth = 3;
                        });
                      }
                    },
                    dropdownButtonStyle: DropdownButtonStyle(
                      height: 7.0.h,
                      width: 90.0.w,
                      //padding: EdgeInsets.only(left: 2.0.w),
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
                              print('Date Picker!!!');
                              final datePick = await showDatePicker(
                                  context: context,
                                  initialDate: new DateTime.now(),
                                  firstDate: new DateTime.now(),
                                  lastDate: new DateTime.now()
                                      .add(const Duration(days: 365)),
                                  helpText: 'Select Check In Date');
                              if (datePick != null && datePick != checkInDate) {
                                setState(() {
                                  checkInDate = datePick;
                                  isCheckedIn = true;

                                  if (checkInDate.day.toString().length == 1 &&
                                      checkInDate.month.toString().length ==
                                          1) {
                                    setState(() {
                                      checkInString =
                                          "0${checkInDate.day.toString()}/0${checkInDate.month}";
                                    });
                                    print('11111');
                                  } else if (checkInDate.day
                                          .toString()
                                          .length ==
                                      1) {
                                    setState(() {
                                      checkInString =
                                          "0${checkInDate.day}/${checkInDate.month}";
                                    });
                                    print('22222');
                                  } else if (checkInDate.month
                                          .toString()
                                          .length ==
                                      1) {
                                    checkInString =
                                        "${checkInDate.day}/0${checkInDate.month}";
                                  } else {
                                    checkInString =
                                        "${checkInDate.day}/${checkInDate.month}";
                                  }
                                  // checkInString =
                                  //     "${checkInDate.day}/${checkInDate.month}";
                                });
                              }

                              //  SfDateRangePicker(
                              //    //onSelectionChanged: _onSelectionChanged,
                              //    selectionMode: DateRangePickerSelectionMode.range,
                              //    initialSelectedRange: PickerDateRange(
                              //        DateTime.now().subtract(const Duration(days: 4)),
                              //        DateTime.now().add(const Duration(days: 3))),
                              //  );
                            },
                            child: Container(
                              height: 7.0.h,
                              width: 44.0.w,
                              padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Constants.formBorder),
                                borderRadius: BorderRadius.circular(5.0),
                                //color: Colors.transparent,//Color(0xFFA8B4C1).withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isCheckedIn ? checkInString : 'Check In',
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
                                print('Date Picker!!!');
                                final datePick = await showDatePicker(
                                    context: context,
                                    initialDate: checkInDate,
                                    firstDate: checkInDate,
                                    lastDate: checkInDate.add(selectedMonth == 1
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

                                    if (checkOutDate.day.toString().length ==
                                            1 &&
                                        checkInDate.month.toString().length ==
                                            1) {
                                      setState(() {
                                        checkOutString =
                                            "0${checkOutDate.day.toString()}/0${checkOutDate.month}";
                                      });
                                      print('11111');
                                    } else if (checkOutDate.day
                                            .toString()
                                            .length ==
                                        1) {
                                      setState(() {
                                        checkOutString =
                                            "0${checkOutDate.day}/${checkOutDate.month}";
                                      });
                                      print('22222');
                                    } else if (checkOutDate.month
                                            .toString()
                                            .length ==
                                        1) {
                                      checkOutString =
                                          "${checkOutDate.day}/0${checkOutDate.month}";
                                    } else {
                                      checkOutString =
                                          "${checkOutDate.day}/${checkOutDate.month}";
                                    }
                                    // checkOutString =
                                    //     "${checkOutDate.day}/${checkOutDate.month}";
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
                                //color: Colors.transparent,//Color(0xFFA8B4C1).withOpacity(0.5),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isCheckedOut ? checkOutString : 'Check Out',
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
                    //width: 90.0.w,
                    child: TextFormField(
                      controller: _nameController,
                      readOnly: true,
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
                      // validator: (value) {
                      //   if (value.isEmpty) {
                      //     Fluttertoast.showToast(
                      //         msg: "Please Enter Name",
                      //         toastLength: Toast.LENGTH_SHORT,
                      //         gravity: ToastGravity.BOTTOM,
                      //         timeInSecForIosWeb: 1,
                      //         backgroundColor: Colors.red,
                      //         textColor: Colors.white,
                      //         fontSize: 16.0);
                      //   }
                      // },
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
                    //width: 90.0.w,
                    child: CustomDropdown<int>(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.0.w),
                            child: Text(
                              userGender == 'M'
                                  ? 'Male'
                                  : userGender == 'F'
                                      ? 'Female'
                                      : 'Other',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor),
                            ),
                          ),
                          //SizedBox(width: 10.0.w)
                        ],
                      ),
                      // icon: Icon(
                      //   Icons.expand_more,
                      //   color: Constants.bpSkipStyle,
                      // ),
                      onChange: (int value, int index) {
                        print(value);
                        // if (value != 1 ||
                        //     value != 2 ||
                        //     value != 3) {
                        //   setState(() {
                        //     gender = 'GenderSelected';
                        //   });
                        // }
                        // if (value == 1) {
                        //   gender = 'M';
                        // } else if (value == 2) {
                        //   gender = 'F';
                        // } else {
                        //   gender = 'O';
                        // }
                      },
                      dropdownButtonStyle: DropdownButtonStyle(
                        height: 7.0.h,
                        //width: 90.0.w,
                        //padding: EdgeInsets.only(left: 2.0.w),
                        elevation: 0,
                        // backgroundColor:
                        //     //Color(0xFFA8B4C1).withOpacity(0.5),
                        //     Colors.white,
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
                        userGender == 'M'
                            ? 'Male'
                            : userGender == 'F'
                                ? 'Female'
                                : 'Other'
                      ]
                          .asMap()
                          .entries
                          .map(
                            (item) => DropdownItem<int>(
                              value: item.key + 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      item.value,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.bgColor),
                                    ),
                                    //SizedBox(width: 10.0.w)
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
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
                    // width: 90.0.w,
                    child: TextFormField(
                      controller: _mobileController,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
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
              Padding(
                padding: EdgeInsets.only(
                    left: 4.0.w, right: 4.0.w, top: 3.0.h, bottom: 3.0.h),
                child: Divider(
                  color: Constants.formBorder,
                  height: 2.0.h,
                  thickness: 1.0,
                ),
              ),
              Container(
                //height: 40.0.h,
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
                                text: 'Room Charges',
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0.h),
                child: GestureDetector(
                  onTap: () {
                    // pushNewScreen(context,
                    //     screen: BookPropertyScreen(),
                    //     withNavBar: false,
                    //     pageTransitionAnimation: PageTransitionAnimation.cupertino);
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
}
