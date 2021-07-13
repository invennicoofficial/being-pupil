import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class EducatorRegistration extends StatefulWidget {
  const EducatorRegistration({Key key}) : super(key: key);

  @override
  _EducatorRegistrationState createState() => _EducatorRegistrationState();
}

class _EducatorRegistrationState extends State<EducatorRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Constants.bgColor,
          title: Container(
              height: 8.0.h,
              width: 30.0.w,
              child: Image.asset('assets/images/beingPupil.png',
                  fit: BoxFit.contain)),
        ),
        body: Padding(
          padding: EdgeInsets.only(bottom: 3.0.h, left: 5.0.w, right: 5.0.w),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              //height: 90.0.h,
              width: 100.0.w,
              //color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Column(
                  children: <Widget>[
                    //Column for User Info
                    Stack(
                      children: <Widget>[
                        // Padding(padding: EdgeInsets.only(top: 2.0.h, left: 2.0.w, right: 2.0.w),
                        // child: ,)
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              print('Upload Pic!!!');
                            },
                            child: Container(
                              height: 16.5.h,
                              width: 29.5.w,
                              //color: Colors.grey,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'assets/icons/circle_upload.png'),
                                //backgroundColor: Colors.grey,
                                radius: 100.0,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5.0.h),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('Upload Pic!!!');
                                      },
                                      child: ImageIcon(
                                        AssetImage('assets/icons/camera.png'),
                                        size: 25,
                                        color: Constants.formBorder,
                                      ),
                                    ),
                                    Text(
                                      'Upload',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 8.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.formBorder),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                      ],
                    ),

                    Column(
                      children: <Widget>[
                        Theme(
                          data: new ThemeData(
                            primaryColor: Constants.bpSkipStyle,
                            primaryColorDark: Constants.bpSkipStyle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 4.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
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
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
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
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
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
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Theme(
                              data: new ThemeData(
                                primaryColor: Constants.bpSkipStyle,
                                primaryColorDark: Constants.bpSkipStyle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 3.0.h),
                                child: Container(
                                  height: 7.0.h,
                                  width: 35.0.w,
                                  child: CustomDropdown<int>(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bpSkipStyle),
                                        ),
                                        SizedBox(width: 2.0.w)
                                      ],
                                    ),
                                    icon: Icon(
                                      Icons.expand_more,
                                      color: Constants.bpSkipStyle,
                                    ),
                                    onChange: (int value, int index) {
                                      print(value);
                                    },
                                    dropdownButtonStyle: DropdownButtonStyle(
                                      height: 7.0.h,
                                      width: 90.0.w,
                                      //padding: EdgeInsets.only(left: 2.0.w),
                                      elevation: 0,
                                      backgroundColor:
                                          Color(0xFFA8B4C1).withOpacity(0.5),
                                      primaryColor: Constants.bpSkipStyle,
                                      side: BorderSide(
                                          color: Constants.formBorder),
                                    ),
                                    dropdownStyle: DropdownStyle(
                                      borderRadius: BorderRadius.circular(10.0),
                                      elevation: 6,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w, vertical: 1.5.h),
                                    ),
                                    items: ['Male  ', 'Female', 'Other ']
                                        .asMap()
                                        .entries
                                        .map(
                                          (item) => DropdownItem<int>(
                                            value: item.key + 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    item.value,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constants
                                                            .bpSkipStyle),
                                                  ),
                                                  SizedBox(width: 2.0.w)
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
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 3.0.h),
                                child: GestureDetector(
                                  onTap: () {
                                    print('Date Picker!!!');
                                  },
                                  child: Container(
                                    height: 7.0.h,
                                    width: 40.0.w,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants.formBorder),
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xFFA8B4C1).withOpacity(0.5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'DD/MM/YY',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bpSkipStyle),
                                        ),
                                        ImageIcon(
                                            AssetImage(
                                                'assets/icons/calendar.png'),
                                            size: 25,
                                            color: Constants.bpSkipStyle),
                                      ],
                                    ),
                                  ),
                                ),
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
                            padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                              //bottom: 3.0.h
                            ),
                            child: CustomDropdown<int>(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Document Type',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  SizedBox(width: 30.0.w)
                                ],
                              ),
                              icon: Icon(
                                Icons.expand_more,
                                color: Constants.bpSkipStyle,
                              ),
                              onChange: (int value, int index) {
                                print(value);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                backgroundColor:
                                    Color(0xFFA8B4C1).withOpacity(0.5),
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
                                'Aadhaar Card',
                                'PAN Card    ',
                                'Licence      '
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
                                                  color: Constants.bpSkipStyle),
                                            ),
                                            SizedBox(width: 45.0.w)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: 3.0.h, right: 3.0.w, left: 3.0.w),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5),
                            padding: EdgeInsets.all(12),
                            color: Constants.formBorder.withOpacity(0.5),
                            strokeWidth: 1.5,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: GestureDetector(
                                onTap: () {
                                  print('Upload!!!');
                                },
                                child: Container(
                                  height: 7.0.h,
                                  width: 90.0.w,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ImageIcon(
                                            AssetImage(
                                                'assets/icons/upload.png'),
                                            size: 25,
                                            color: Constants.bpSkipStyle),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Text(
                                          'Upload the file',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bpSkipStyle),
                                        )
                                      ],
                                    ),
                                  ),
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Identification Document Number",
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
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                              padding: EdgeInsets.only(
                                left: 3.0.w,
                                right: 3.0.w,
                                top: 3.0.h,
                                //bottom: 3.0.h
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print('Location!!!');
                                },
                                child: Container(
                                  height: 7.0.h,
                                  width: 90.0.w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.0.w),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Constants.formBorder),
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Color(0xFFA8B4C1).withOpacity(0.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Location',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Constants.bpSkipStyle),
                                      ),
                                      Icon(
                                        Icons.gps_fixed,
                                        size: 25,
                                        color: Constants.bpSkipStyle,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),

                        //Educational Details
                        // SizedBox(
                        //   height: 4.0.h,
                        // ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Educational Details',
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Name of School",
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
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                            padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                              //bottom: 3.0.h
                            ),
                            child: CustomDropdown<int>(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Year',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  SizedBox(width: 65.0.w)
                                ],
                              ),
                              icon: Icon(
                                Icons.expand_more,
                                color: Constants.bpSkipStyle,
                              ),
                              onChange: (int value, int index) {
                                print(value);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                backgroundColor:
                                    Color(0xFFA8B4C1).withOpacity(0.5),
                                primaryColor: Constants.bpSkipStyle,
                                side: BorderSide(color: Constants.formBorder),
                              ),
                              dropdownStyle: DropdownStyle(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 6,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0.w, vertical: 1.5.h),
                              ),
                              items: ['2001', '2002', '2003', '2004', '2005']
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
                                                  color: Constants.bpSkipStyle),
                                            ),
                                            SizedBox(width: 61.0.w)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        Theme(
                          data: new ThemeData(
                            primaryColor: Constants.bpSkipStyle,
                            primaryColorDark: Constants.bpSkipStyle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                              //bottom: 3.0.h
                            ),
                            child: CustomDropdown<int>(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Qualification',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  SizedBox(width: 50.0.w)
                                ],
                              ),
                              icon: Icon(
                                Icons.expand_more,
                                color: Constants.bpSkipStyle,
                              ),
                              onChange: (int value, int index) {
                                print(value);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                //backgroundColor: Colors.white,
                                primaryColor: Constants.bpSkipStyle,
                                side: BorderSide(color: Constants.formBorder),
                              ),
                              dropdownStyle: DropdownStyle(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 6,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0.w, vertical: 1.5.h),
                              ),
                              items: ['B.Ed', 'M.Ed', 'B.Com', 'M.Com', 'M.Sc']
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
                                                  color: Constants.bpSkipStyle),
                                            ),
                                            SizedBox(width: 60.0.w)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: 3.0.h, right: 3.0.w, left: 3.0.w),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(5),
                            padding: EdgeInsets.all(12),
                            color: Constants.formBorder.withOpacity(0.5),
                            strokeWidth: 1.5,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: GestureDetector(
                                onTap: () {
                                  print('Upload!!!');
                                },
                                child: Container(
                                  height: 7.0.h,
                                  width: 90.0.w,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ImageIcon(
                                            AssetImage(
                                                'assets/icons/upload.png'),
                                            size: 25,
                                            color: Constants.bpSkipStyle),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Text(
                                          'Upload the file',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bpSkipStyle),
                                        )
                                      ],
                                    ),
                                  ),
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
                              padding: EdgeInsets.only(
                                left: 3.0.w,
                                right: 3.0.w,
                                top: 3.0.h,
                                //bottom: 3.0.h
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print('Other!!!');
                                },
                                child: Container(
                                  height: 7.0.h,
                                  width: 90.0.w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.0.w),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Constants.formBorder),
                                    borderRadius: BorderRadius.circular(5.0),
                                    //color: Color(0xFFA8B4C1).withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Constants.bpSkipStyle,
                                        ),
                                        Text(
                                          'Other Degree/ Diploma',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bpSkipStyle),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),

                        Theme(
                          data: new ThemeData(
                            primaryColor: Constants.bpSkipStyle,
                            primaryColorDark: Constants.bpSkipStyle,
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(
                                left: 3.0.w,
                                right: 3.0.w,
                                top: 3.0.h,
                                //bottom: 3.0.h
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print('Add more!!!');
                                },
                                child: Container(
                                  height: 7.0.h,
                                  width: 90.0.w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.0.w),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Constants.formBorder),
                                    borderRadius: BorderRadius.circular(5.0),
                                    //color: Color(0xFFA8B4C1).withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Constants.bpSkipStyle,
                                        ),
                                        Text(
                                          'Add more details',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bpSkipStyle),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        ),

                        //Work Experience
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Work Experience',
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
                            padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                              //bottom: 3.0.h
                            ),
                            child: CustomDropdown<int>(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Work Experience',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  SizedBox(width: 30.0.w)
                                ],
                              ),
                              icon: Icon(
                                Icons.expand_more,
                                color: Constants.bpSkipStyle,
                              ),
                              onChange: (int value, int index) {
                                print(value);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                backgroundColor:
                                    Color(0xFFA8B4C1).withOpacity(0.5),
                                primaryColor: Constants.bpSkipStyle,
                                side: BorderSide(color: Constants.formBorder),
                              ),
                              dropdownStyle: DropdownStyle(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 6,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0.w, vertical: 1.5.h),
                              ),
                              items: ['1', '2', '3', '4', '5', '5+']
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
                                                  color: Constants.bpSkipStyle),
                                            ),
                                            SizedBox(width: 68.0.w)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        Theme(
                          data: new ThemeData(
                            primaryColor: Constants.bpSkipStyle,
                            primaryColorDark: Constants.bpSkipStyle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                              //bottom: 3.0.h
                            ),
                            child: CustomDropdown<int>(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Teaching Experience',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Constants.bpSkipStyle),
                                  ),
                                  SizedBox(width: 23.0.w)
                                ],
                              ),
                              icon: Icon(
                                Icons.expand_more,
                                color: Constants.bpSkipStyle,
                              ),
                              onChange: (int value, int index) {
                                print(value);
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                backgroundColor:
                                    Color(0xFFA8B4C1).withOpacity(0.5),
                                primaryColor: Constants.bpSkipStyle,
                                side: BorderSide(color: Constants.formBorder),
                              ),
                              dropdownStyle: DropdownStyle(
                                borderRadius: BorderRadius.circular(10.0),
                                elevation: 6,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0.w, vertical: 1.5.h),
                              ),
                              items: ['1', '2', '3', '4', '5', '5+']
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
                                                  color: Constants.bpSkipStyle),
                                            ),
                                            SizedBox(width: 68.0.w)
                                          ],
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
                              padding: EdgeInsets.only(
                                  top: 4.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Achievements',
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 13.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                maxLength: 100,
                                decoration: InputDecoration(
                                    //labelText: "Please mention your achivements...",
                                    counterText: '',
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
                                    hintText:
                                        "Please mention your achivements..."),
                                //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0.w, right: 3.0.w, top: 0.5.h),
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

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Skills',
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 13.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                maxLength: 100,
                                decoration: InputDecoration(
                                    //labelText: "Please mention your achivements...",
                                    counterText: '',
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
                                    hintText:
                                        "Please mention your skills example #skill1 #skill2..."),
                                //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Hobbies',
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 13.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                maxLength: 100,
                                decoration: InputDecoration(
                                    //labelText: "Please mention your achivements...",
                                    counterText: '',
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
                                    hintText:
                                        "Please mention your hobbies example #hobbie1 #hobbie2..."),
                                //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Other Social Media Links',
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Facebook",
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
                                    suffixIcon: Icon(
                                      Icons.link,
                                      size: 25,
                                      color: Constants.formBorder,
                                    )), //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Instagram",
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
                                    suffixIcon: Icon(
                                      Icons.link,
                                      size: 25,
                                      color: Constants.formBorder,
                                    )),
                                //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "LinkedIn",
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
                                    suffixIcon: Icon(
                                      Icons.link,
                                      size: 25,
                                      color: Constants.formBorder,
                                    )),
                                //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Other",
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
                                    suffixIcon: Icon(
                                      Icons.link,
                                      size: 25,
                                      color: Constants.formBorder,
                                    )),
                                //keyboardType: TextInputType.emailAddress,
                                style: new TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              right: 3.0.w,
                              left: 3.0.w,
                              top: 6.0.h,
                              bottom: 3.0.h),
                          child: GestureDetector(
                            onTap: () {
                              print('Submit!!!');
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => bottomNavBar(0)),
                                  (Route<dynamic> route) => false);
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
                                  'Submit'.toUpperCase(),
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
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
