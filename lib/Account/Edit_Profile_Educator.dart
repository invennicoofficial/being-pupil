import 'dart:io';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/UpdateProfile_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';



class EditEducatorProfile extends StatefulWidget {
  const EditEducatorProfile({Key key}) : super(key: key);

  @override
  _EditEducatorProfileState createState() => _EditEducatorProfileState();
}

class _EditEducatorProfileState extends State<EditEducatorProfile> {
  File _image, _certificate, _document;
  String birthDateInString, selectedYearString;
  DateTime birthDate, selectedYear;
  bool isDateSelected = false;
  bool isYearSelected = false;
  String gender = 'Gender';
  String docType = 'DocType';
  String qualification = '0';
  String workExp = '0';
  String teachExp = '0';
  String fileName;
  String _certiName;
  int itemCount = 0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idNumController = TextEditingController();
  TextEditingController _achivementController = TextEditingController();
  TextEditingController _fbLinkController = TextEditingController();
  TextEditingController _instagramLinkController = TextEditingController();
  TextEditingController _linkedInLinkLinkController = TextEditingController();
  TextEditingController _otherLinkLinkController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  var myControllers = [];
  var certificate = [];
  String registerAs;
  int userId;
  String authToken;
  List<String> education_details = [];
  List<String> skillList = [];
  List<String> hobbieList = [];
  int totalWorkExp, totalTeachExp;
  //List<String> _schoolNameList

  // List<Skills> _selectedSkills;
  // String _selectedSkillsJson = 'Nothing to show';

  // List<Hobbies> _selectedHobbies;
  // String _selectedHobbiesJson = 'Nothing to show';

  @override
  void initState() {
    itemCount = 1;
    createControllers();
    getData();
    getToken();
    //_document  = File('assets/images/postImage.png');
    super.initState();
    // _selectedSkills = [];
    // _selectedHobbies = [];
  }

  // @override
  // void dispose() {
  //   _selectedSkills.clear();
  //   _selectedHobbies.clear();
  //   super.dispose();
  // }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      userId = preferences.getInt('userId');
    });
    print(registerAs);
  }

  createControllers() {
    myControllers = [];
    certificate = [];
    for (var i = 0; i < 5; i++) {
      myControllers.add(TextEditingController());
      //certificate.add(_certiName);
    }
  }

  _imageFromCamera() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  _imageFromGallery() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,
                          color: Constants.formBorder),
                      title: new Text('Gallery',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400,
                              color: Constants.bpSkipStyle)),
                      onTap: () {
                        _imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera,
                        color: Constants.formBorder),
                    title: new Text('Camera',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bpSkipStyle)),
                    onTap: () {
                      _imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showLocation(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Container(
                height: 70.0.h,
                width: 100.0.w,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 3.0.h, left: 5.0.w, right: 5.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Search Location',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Constants.bgColor)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 4.0.h,
                              width: 5.0.w,
                              child: Center(
                                child: Icon(Icons.close,
                                    size: 25, color: Constants.bpSkipStyle),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Theme(
                      data: new ThemeData(
                        primaryColor: Constants.bpSkipStyle,
                        primaryColorDark: Constants.bpSkipStyle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 5.0.w, right: 5.0.w, top: 3.0.h),
                        child: Container(
                          height: 7.0.h,
                          width: 90.0.w,
                          child: TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                                //labelText: "Search for your location",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                    //width: 2.0,
                                  ),
                                ),
                                hintText: "Search for your location",
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: Constants.bpSkipStyle,
                                )),
                            //keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                                fontFamily: "Montserrat", fontSize: 10.0.sp),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.0.w, vertical: 3.0.h),
                      child: Divider(
                        color: Constants.formBorder,
                        height: 0.5.h,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          contentPadding: EdgeInsets.only(
                              left: 5.0.w, right: 5.0.w, bottom: 3.0.w),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                index == 1
                                    ? Icons.work_outline
                                    : Icons.home_outlined,
                                size: 25,
                                color: Constants.formBorder,
                              ),
                              Text('2 km',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 6.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Constants.bpSkipStyle)),
                            ],
                          ),
                          title: Text(index == 1 ? 'Work' : 'Home',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bgColor)),
                          subtitle: Text(
                              index == 1
                                  ? 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed'
                                  : 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 8.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Constants.bpOnBoardSubtitleStyle)),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _uploadDocument() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null) {
      //File file = File(result.files.single.name);
      PlatformFile file = result.files.first;
      setState(() {
        fileName = file.name;
        _document = File(file.path);
      });

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {}
  }

  _certificateFromCamera() async {
    File doc = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _certificate = doc;
      _certiName = doc.path.split('/scaled_').last.substring(35);
    });
  }

  _certificateFromGallery() async {
    File doc = (await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _certificate = doc;
      _certiName = doc.path.split('/scaled_image_picker').last;
      print(_certiName);
    });
  }

  void _showCertificatePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,
                          color: Constants.formBorder),
                      title: new Text('Gallery',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w400,
                              color: Constants.bpSkipStyle)),
                      onTap: () {
                        _certificateFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera,
                        color: Constants.formBorder),
                    title: new Text('Camera',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bpSkipStyle)),
                    onTap: () {
                      _certificateFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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
                              _showPicker(context);
                            },
                            child: _image != null
                                ? Stack(children: [
                                    CircleAvatar(
                                      radius: 65,
                                      backgroundImage: AssetImage(
                                          'assets/icons/circle_upload.png'),
                                      backgroundColor: Colors.transparent,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(65),
                                        child: Image.file(
                                          _image,
                                          height: 13.5.h,
                                          width: 28.0.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       shape: BoxShape.circle,
                                      //       ),
                                      //   child: Image.file(
                                      //     _image,
                                      //     width: 100,
                                      //     height: 100,
                                      //     fit: BoxFit.cover,
                                      //   ),
                                      // )
                                    ),
                                  ])
                                : CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/icons/circle_upload.png'),
                                    //backgroundColor: Colors.white,
                                    radius: 65.0,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0.h),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    print('Upload Pic!!!');
                                                    _showPicker(context);
                                                  },
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        'assets/icons/camera.png'),
                                                    size: 25,
                                                    color: Constants.formBorder,
                                                  ),
                                                ),
                                                Text(
                                                  'Upload',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 8.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          Constants.formBorder),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.5.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
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
                                controller: _nameController,
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
                            padding: EdgeInsets.only(
                                left: 3.0.w, right: 3.0.w, top: 3.0.h),
                            child: Container(
                              height: 7.0.h,
                              width: 90.0.w,
                              child: TextFormField(
                                controller: _mobileController,
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
                                controller: _emailController,
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.0.w),
                                          child: Text(
                                            'Gender',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Constants.bpSkipStyle),
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
                                      if (value != 1 ||
                                          value != 2 ||
                                          value != 3) {
                                        setState(() {
                                          gender = 'GenderSelected';
                                        });
                                      }
                                      if(value == 1){
                                        gender = 'M';
                                      } else if(value == 2){
                                        gender = 'F';
                                      } else {
                                        gender = 'O';
                                      }
                                    },
                                    dropdownButtonStyle: DropdownButtonStyle(
                                      height: 7.0.h,
                                      width: 90.0.w,
                                      //padding: EdgeInsets.only(left: 2.0.w),
                                      elevation: 0,
                                      // backgroundColor:
                                      //     //Color(0xFFA8B4C1).withOpacity(0.5),
                                      //     Colors.white,
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
                                    items: ['Male', 'Female', 'Other']
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
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 3.0.h),
                                child: GestureDetector(
                                  onTap: () async {
                                    print('Date Picker!!!');
                                    final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: new DateTime.now(),
                                        firstDate: new DateTime(1900),
                                        lastDate: new DateTime(2100),
                                        helpText: 'Select Birth Date');
                                    if (datePick != null &&
                                        datePick != birthDate) {
                                      setState(() {
                                        birthDate = datePick;
                                        isDateSelected = true;
                                        if(birthDate.day.toString().length == 1 && birthDate.month.toString().length == 1){
                                          setState(() {
                                            birthDateInString = "0${birthDate.day.toString()}/0${birthDate.month}/${birthDate.year}";
                                          });
                                          print('11111');
                                        } else if(birthDate.day.toString().length == 1){
                                          setState(() {
                                           birthDateInString = "0${birthDate.day}/${birthDate.month}/${birthDate.year}";

                                          });
                                          print('22222');
                                        }else if(birthDate.month.toString().length == 1){
                                          birthDateInString = "${birthDate.day}/0${birthDate.month}/${birthDate.year}"; 
                                        }
                                        else{
                                          birthDateInString = "${birthDate.day}/${birthDate.month}/${birthDate.year}";
                                        }
                                        // 08/14/2019
                                      });
                                    }
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
                                      //color: Colors.transparent,//Color(0xFFA8B4C1).withOpacity(0.5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isDateSelected
                                              ? birthDateInString
                                              : 'DOB',
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
                                            color: Constants.formBorder),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    child: Text(
                                      'Select Document Type',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.bpSkipStyle),
                                    ),
                                  ),
                                  //SizedBox(width: 30.0.w)
                                ],
                              ),
                              // icon: Icon(
                              //   Icons.expand_more,
                              //   color: Constants.bpSkipStyle,
                              // ),
                              onChange: (int value, int index) {
                                print(value);
                                if (value != 1 ||
                                    value != 2 ||
                                    value != 3 ||
                                    value != 4 ||
                                    value != 5) {
                                  setState(() {
                                    docType = 'DocSelected';
                                  });
                                }
                                 if(value == 1){
                                  docType = 'Aadhaar';
                                  print(docType);
                                }else if(value == 2){
                                  docType = 'PAN';
                                  print(docType);
                                }else if(value == 3){
                                  docType = 'Passport';
                                  print(docType);
                                }else if(value == 4){
                                  docType = 'Voter ID';
                                  print(docType);
                                }else {
                                  docType = 'Driving License';
                                  print(docType);
                                }

                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                //backgroundColor: Colors.transparent,
                                //Color(0xFFA8B4C1).withOpacity(0.5),
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
                                'Aadhaar',
                                'PAN',
                                'Passport',
                                'Voter ID',
                                'Driving License'
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
                                           // SizedBox(width: 45.0.w)
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
                                  _uploadDocument();
                                },
                                child: Container(
                                  height: 6.0.h,
                                  width: 90.0.w,
                                  //color: Colors.grey,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ImageIcon(
                                            AssetImage(
                                                'assets/icons/upload.png'),
                                            size: 25,
                                            color: Constants.formBorder),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Flexible(
                                                                                  child: Text(
                                            (fileName == null || fileName == '')
                                                ? 'Upload the file'
                                                : fileName,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Constants.bpSkipStyle),
                                                overflow: TextOverflow.fade,
                                          ),
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
                                controller: _idNumController,
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
                                  _showLocation(context);
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
                                        color: Constants.formBorder,
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

                        ListView.builder(
                          itemCount: itemCount,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 3.0.w, right: 3.0.w, top: 3.0.h),
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(5),
                                padding: EdgeInsets.all(12),
                                color: Constants.formBorder.withOpacity(0.7),
                                strokeWidth: 1.8,
                                strokeCap: StrokeCap.butt,
                                dashPattern: [4, 3],
                                child: Column(
                                  children: <Widget>[
                                    Theme(
                                      data: new ThemeData(
                                        primaryColor: Constants.bpSkipStyle,
                                        primaryColorDark: Constants.bpSkipStyle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 1.0.w,
                                            right: 1.0.w,
                                            top: 1.0.h),
                                        child: Container(
                                          height: 7.0.h,
                                          width: 90.0.w,
                                          child: TextFormField(
                                            controller: myControllers[index],
                                            decoration: InputDecoration(
                                              labelText: "Name of School",
                                              fillColor: Colors.white,
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                borderSide: BorderSide(
                                                  color: Constants.formBorder,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
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
                                              left: 1.0.w,
                                              right: 1.0.w,
                                              top: 3.0.h),
                                          child: GestureDetector(
                                            onTap: () async {
                                              print('Year!!!');
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      "Select Qualification Year",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 14.0.sp,
                                                          color:
                                                              Constants.bgColor,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    content: Container(
                                                      // Need to use container to add size constraint.
                                                      width: 75.0.w,
                                                      height: 50.0.h,
                                                      child: YearPicker(
                                                        firstDate: DateTime(
                                                            DateTime(1960).year,
                                                            1),
                                                        lastDate: DateTime(
                                                            DateTime.now().year,
                                                            1),
                                                        //initialDate: DateTime.now(),
                                                        // save the selected date to _selectedDate DateTime variable.
                                                        // It's used to set the previous selected date when
                                                        // re-showing the dialog.
                                                        selectedDate:
                                                            isYearSelected
                                                                ? selectedYear
                                                                : DateTime(
                                                                    DateTime.now()
                                                                        .year),
                                                        onChanged: (DateTime
                                                            dateTime) {
                                                          // close the dialog when year is selected.
                                                          setState(() {
                                                            isYearSelected =
                                                                true;
                                                            selectedYear =
                                                                dateTime;
                                                          });

                                                          print(selectedYear
                                                              .year);
                                                          Navigator.pop(
                                                              context);
                                                          // Do something with the dateTime selected.
                                                          // Remember that you need to use dateTime.year to get the year
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              // final pickedYear =
                                              //     await showDatePicker(
                                              //   context: context,
                                              //   initialDate: DateTime.now(),
                                              //   firstDate: DateTime(1960, 1, 1),
                                              //   lastDate: DateTime.now(),
                                              //   helpText:
                                              //       'Select Qualification Year',
                                              //   initialDatePickerMode:
                                              //       DatePickerMode.year,
                                              // );
                                              // final pickedYear = await YearPicker(
                                              //  selectedDate: DateTime.now(),
                                              //  firstDate: DateTime(1960),
                                              //  lastDate: DateTime.now(),
                                              //  onChanged: (value) {
                                              //    selectedYear = value;
                                              //    },
                                              // );
                                              // if (pickedYear != null &&
                                              //     pickedYear != selectedYear) {
                                              //   setState(() {
                                              //     selectedYear = pickedYear;
                                              //     isYearSelected = true;
                                              //     selectedYearString =
                                              //         '${selectedYear.year}';
                                              //   });
                                              // }
                                            },
                                            child: Container(
                                              height: 7.0.h,
                                              width: 90.0.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.0.w),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        Constants.formBorder),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                //color: Color(0xFFA8B4C1).withOpacity(0.5),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    isYearSelected
                                                        ? selectedYear.year
                                                            .toString()
                                                        : 'Year',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constants
                                                            .bpSkipStyle),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                                    // Theme(
                                    //   data: new ThemeData(
                                    //     primaryColor: Constants.bpSkipStyle,
                                    //     primaryColorDark: Constants.bpSkipStyle,
                                    //   ),
                                    //   child: Padding(
                                    //     padding: EdgeInsets.only(
                                    //       left: 3.0.w,
                                    //       right: 3.0.w,
                                    //       top: 3.0.h,
                                    //       //bottom: 3.0.h
                                    //     ),
                                    //     child: CustomDropdown<int>(
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Padding(
                                    //             padding:
                                    //                 EdgeInsets.symmetric(horizontal: 3.0.w),
                                    //             child: Text(
                                    //               'Year',
                                    //               style: TextStyle(
                                    //                   fontFamily: 'Montserrat',
                                    //                   fontSize: 10.0.sp,
                                    //                   fontWeight: FontWeight.w400,
                                    //                   color: Constants.bpSkipStyle),
                                    //             ),
                                    //           ),
                                    //           //SizedBox(width: 65.0.w)
                                    //         ],
                                    //       ),
                                    //       // icon: Icon(
                                    //       //   Icons.expand_more,
                                    //       //   color: Constants.bpSkipStyle,
                                    //       // ),
                                    //       onChange: (int value, int index) {
                                    //         print(value);
                                    //       },
                                    //       dropdownButtonStyle: DropdownButtonStyle(
                                    //         height: 7.0.h,
                                    //         width: 90.0.w,
                                    //         //padding: EdgeInsets.only(left: 2.0.w),
                                    //         elevation: 0,
                                    //         backgroundColor:
                                    //             Color(0xFFA8B4C1).withOpacity(0.5),
                                    //         primaryColor: Constants.bpSkipStyle,
                                    //         side: BorderSide(color: Constants.formBorder),
                                    //       ),
                                    //       dropdownStyle: DropdownStyle(
                                    //         borderRadius: BorderRadius.circular(10.0),
                                    //         elevation: 6,
                                    //         padding: EdgeInsets.symmetric(
                                    //             horizontal: 2.0.w, vertical: 1.5.h),
                                    //       ),
                                    //       items: ['2001', '2002', '2003', '2004', '2005']
                                    //           .asMap()
                                    //           .entries
                                    //           .map(
                                    //             (item) => DropdownItem<int>(
                                    //               value: item.key + 1,
                                    //               child: Padding(
                                    //                 padding: const EdgeInsets.all(8.0),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     Text(
                                    //                       item.value,
                                    //                       style: TextStyle(
                                    //                           fontFamily: 'Montserrat',
                                    //                           fontSize: 10.0.sp,
                                    //                           fontWeight: FontWeight.w400,
                                    //                           color: Constants.bpSkipStyle),
                                    //                     ),
                                    //                     SizedBox(width: 61.0.w)
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           )
                                    //           .toList(),
                                    //     ),
                                    //   ),
                                    // ),
                                    Theme(
                                      data: new ThemeData(
                                        primaryColor: Constants.bpSkipStyle,
                                        primaryColorDark: Constants.bpSkipStyle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 1.0.w,
                                            right: 1.0.w,
                                            top: 3.0.h),
                                        child: CustomDropdown<int>(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0.w),
                                                child: Text(
                                                  'Qualification',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants
                                                          .bpSkipStyle),
                                                ),
                                              ),
                                              //SizedBox(width: 50.0.w)
                                            ],
                                          ),
                                          // icon: Icon(
                                          //   Icons.expand_more,
                                          //   color: Constants.bpSkipStyle,
                                          // ),
                                          onChange: (int value, int index) {
                                            print(value);
                                            if (value > 0) {
                                              setState(() {
                                                qualification = '1';
                                              });
                                            }
                                            if(value == 1){
                                              qualification = 'Graduate';
                                              print(qualification);
                                            }else if(value == 2){
                                              qualification = 'Post-graduate';
                                              print(qualification);
                                            }else if(value == 3){
                                              qualification = 'Chartered Accountant';
                                              print(qualification);
                                            }else{
                                              qualification = 'Others';
                                              print(qualification);
                                            } 
                                          },
                                          dropdownButtonStyle:
                                              DropdownButtonStyle(
                                            height: 7.0.h,
                                            width: 90.0.w,
                                            //padding: EdgeInsets.only(left: 2.0.w),
                                            elevation: 0,
                                            //backgroundColor: Colors.white,
                                            primaryColor: Constants.bpSkipStyle,
                                            side: BorderSide(
                                                color: Constants.formBorder),
                                          ),
                                          dropdownStyle: DropdownStyle(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            elevation: 6,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0.w,
                                                vertical: 1.5.h),
                                          ),
                                          items: [
                                            'Graduate',
                                            'Post-graduate',
                                            'Chartered Accountant',
                                            'Others'
                                          ]
                                              .asMap()
                                              .entries
                                              .map(
                                                (item) => DropdownItem<int>(
                                                  value: item.key + 1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          item.value,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Constants
                                                                  .bpSkipStyle),
                                                        ),
                                                        //SizedBox(width: 60.0.w)
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
                                          left: 1.0.w,
                                          right: 1.0.w,
                                          top: 3.0.h),
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: Radius.circular(5),
                                        padding: EdgeInsets.all(12),
                                        color: Constants.formBorder
                                            .withOpacity(0.5),
                                        strokeWidth: 1.5,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: GestureDetector(
                                            onTap: () {
                                              print('Upload!!!');
                                              _showCertificatePicker(context);
                                            },
                                            child: Container(
                                              height: 6.0.h,
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
                                                        color: Constants
                                                            .formBorder),
                                                    SizedBox(
                                                      width: 1.0.w,
                                                    ),
                                                    Text(
                                                      _certiName != null
                                                          ? _certiName
                                                          : 'Upload Certificate/Degree',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 10.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Constants
                                                              .bpSkipStyle),
                                                      overflow:
                                                          TextOverflow.clip,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Theme(
                        //   data: new ThemeData(
                        //     primaryColor: Constants.bpSkipStyle,
                        //     primaryColorDark: Constants.bpSkipStyle,
                        //   ),
                        //   child: Padding(
                        //       padding: EdgeInsets.only(
                        //         left: 3.0.w,
                        //         right: 3.0.w,
                        //         top: 3.0.h,
                        //         //bottom: 3.0.h
                        //       ),
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           print('Other!!!');
                        //         },
                        //         child: Container(
                        //           height: 7.0.h,
                        //           width: 90.0.w,
                        //           padding:
                        //               EdgeInsets.symmetric(horizontal: 3.0.w),
                        //           decoration: BoxDecoration(
                        //             border:
                        //                 Border.all(color: Constants.formBorder),
                        //             borderRadius: BorderRadius.circular(5.0),
                        //             //color: Color(0xFFA8B4C1).withOpacity(0.5),
                        //           ),
                        //           child: Center(
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Icon(
                        //                   Icons.add,
                        //                   size: 15,
                        //                   color: Constants.bpSkipStyle,
                        //                 ),
                        //                 Text(
                        //                   'Other Degree/ Diploma',
                        //                   style: TextStyle(
                        //                       fontFamily: 'Montserrat',
                        //                       fontSize: 10.0.sp,
                        //                       fontWeight: FontWeight.w400,
                        //                       color: Constants.bpSkipStyle),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       )),
                        // ),

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
                                  setState(() {
                                    if (itemCount < 5) {
                                      itemCount = itemCount + 1;
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "You can add only 5 degree",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    }
                                  });
                                  print(myControllers[1].text.toString());
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
                                          color: Constants.bgColor,
                                        ),
                                        Text(
                                          ' Add more details',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 10.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Constants.bgColor),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    child: Text(
                                      'Total Work Experience',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.bpSkipStyle),
                                    ),
                                  ),
                                  //SizedBox(width: 30.0.w)
                                ],
                              ),
                              // icon: Icon(
                              //   Icons.expand_more,
                              //   color: Constants.bpSkipStyle,
                              // ),
                              onChange: (int value, int index) {
                                totalWorkExp = value;
                                print(totalWorkExp);
                                if (value > 0) {
                                  setState(() {
                                    workExp = '1';
                                  });
                                }
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                // backgroundColor:
                                //     Color(0xFFA8B4C1).withOpacity(0.5),
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
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '15',
                                '15+'
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
                                            //SizedBox(width: 68.0.w)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    child: Text(
                                      'Total Teaching Experience',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.bpSkipStyle),
                                    ),
                                  ),
                                  //SizedBox(width: 23.0.w)
                                ],
                              ),
                              // icon: Icon(
                              //   Icons.expand_more,
                              //   color: Constants.bpSkipStyle,
                              // ),
                              onChange: (int value, int index) {
                                 totalTeachExp = value;
                                print(totalTeachExp);
                                if (value > 0) {
                                  setState(() {
                                    teachExp = '1';
                                  });
                                }
                              },
                              dropdownButtonStyle: DropdownButtonStyle(
                                height: 7.0.h,
                                width: 90.0.w,
                                //padding: EdgeInsets.only(left: 2.0.w),
                                elevation: 0,
                                // backgroundColor:
                                //     Color(0xFFA8B4C1).withOpacity(0.5),
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
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '15',
                                '15+'
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
                                            //SizedBox(width: 68.0.w)
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
                                controller: _achivementController,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                //maxLength: 100,
                                decoration: InputDecoration(
                                    //labelText: "Please mention your achivements...",
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
                              // height: 13.0.h,
                              // width: 90.0.w,
                              child: TextFieldTags(
                                //initialTags: ["college"],
                                tagsStyler: TagsStyler(
                                  showHashtag: true,
                                  tagMargin: const EdgeInsets.only(right: 4.0),
                                  tagCancelIcon: Icon(Icons.cancel,
                                      size: 20.0, color: Constants.bgColor),
                                  tagCancelIconPadding:
                                      EdgeInsets.only(left: 4.0, top: 2.0),
                                  tagPadding: EdgeInsets.only(
                                      top: 2.0,
                                      bottom: 4.0,
                                      left: 8.0,
                                      right: 4.0),
                                  tagDecoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Constants.formBorder,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                  tagTextStyle: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Constants.bgColor,
                                      fontFamily: "Montserrat"),
                                ),
                                textFieldStyler: TextFieldStyler(
                                  helperText: '',
                                  hintText:
                                      "Please mention your skills example #skills1 #skills2...",
                                  hintStyle: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 10.0.sp),
                                  isDense: false,
                                  textFieldFocusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Constants.formBorder,
                                    ),
                                  ),
                                  textFieldBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Constants.formBorder,
                                    ),
                                  ),
                                  textFieldEnabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Constants.formBorder,
                                    ),
                                  ),
                                  textFieldDisabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Constants.formBorder,
                                    ),
                                  ),
                                ),
                                onDelete: (tag) {
                                  print('onDelete: $tag');
                                },
                                onTag: (tag) {
                                  print('onTag: $tag');
                                  skillList.add(tag);
                                },
                                // validator: (String tag) {
                                //   print('validator: $tag');
                                //   if (tag.length > 10) {
                                //     return "hey that is too much";
                                //   }
                                //   return null;
                                // },
                              ),
                              // FlutterTagging<Skills>(
                              //   initialItems: _selectedSkills,
                              //   textFieldConfiguration: TextFieldConfiguration(
                              //     decoration: InputDecoration(
                              //         //labelText: "Please mention your achivements...",
                              //         counterText: '',
                              //         fillColor: Colors.white,
                              //         focusedBorder: OutlineInputBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(5.0),
                              //           borderSide: BorderSide(
                              //             color: Constants.formBorder,
                              //           ),
                              //         ),
                              //         enabledBorder: OutlineInputBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(5.0),
                              //           borderSide: BorderSide(
                              //             color: Constants.formBorder,
                              //             //width: 2.0,
                              //           ),
                              //         ),
                              //         hintText:
                              //             "Please mention your skills example #skill1 #skill2..."),
                              //     //keyboardType: TextInputType.emailAddress,
                              //     style: new TextStyle(
                              //         fontFamily: "Montserrat",
                              //         fontSize: 10.0.sp),
                              //   ),
                              //   findSuggestions: SkillService.getLanguages,
                              //   additionCallback: (value) {
                              //     return Skills(
                              //       name: value,
                              //       position: 0,
                              //     );
                              //   },
                              //   onAdded: (language) {
                              //     // api calls here, triggered when add to tag button is pressed
                              //     return Skills(
                              //       name: language.name,
                              //       position: 0,
                              //     );
                              //   },
                              //   configureSuggestion: (lang) {
                              //     return SuggestionConfiguration(
                              //       title: Text(lang.name),
                              //       //subtitle: Text(lang.position.toString()),
                              //       additionWidget: Chip(
                              //         avatar: Icon(
                              //           Icons.add_circle,
                              //           color: Colors.white,
                              //         ),
                              //         label: Text('Add New Tag'),
                              //         labelStyle: TextStyle(
                              //           fontFamily: 'Montserrat',
                              //           fontSize: 10.0.sp,
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w300,
                              //         ),
                              //         backgroundColor: Constants.bgColor,
                              //       ),
                              //     );
                              //   },
                              //   configureChip: (lang) {
                              //     return ChipConfiguration(
                              //       label: Text(lang.name),
                              //       backgroundColor: Constants.bgColor,
                              //       labelStyle: TextStyle(color: Colors.white),
                              //       deleteIconColor: Colors.white,
                              //     );
                              //   },
                              //   onChanged: () {
                              //     setState(() {
                              //       _selectedSkillsJson = _selectedSkills
                              //           .map<String>(
                              //               (lang) => '\n${lang.toJson()}')
                              //           .toList()
                              //           .toString();
                              //       _selectedSkillsJson = _selectedSkillsJson
                              //           .replaceFirst('}]', '}\n]');
                              //     });
                              //   },
                              // ),

                              // TextFormField(
                              //   maxLines: 5,
                              //   keyboardType: TextInputType.multiline,
                              //   maxLength: 100,
                              //   decoration: InputDecoration(
                              //       //labelText: "Please mention your achivements...",
                              //       counterText: '',
                              //       fillColor: Colors.white,
                              //       focusedBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5.0),
                              //         borderSide: BorderSide(
                              //           color: Constants.formBorder,
                              //         ),
                              //       ),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(5.0),
                              //         borderSide: BorderSide(
                              //           color: Constants.formBorder,
                              //           //width: 2.0,
                              //         ),
                              //       ),
                              //       hintText:
                              //           "Please mention your skills example #skill1 #skill2..."),
                              //   //keyboardType: TextInputType.emailAddress,
                              //   style: new TextStyle(
                              //       fontFamily: "Montserrat",
                              //       fontSize: 10.0.sp),
                              // ),
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 2.0.h, left: 3.0.w, right: 3.0.w),
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
                                // height: 13.0.h,
                                // width: 90.0.w,
                                child: TextFieldTags(
                              //initialTags: ["college"],
                              tagsStyler: TagsStyler(
                                showHashtag: true,
                                tagMargin: const EdgeInsets.only(right: 4.0),
                                tagCancelIcon: Icon(Icons.cancel,
                                    size: 20.0, color: Constants.bgColor),
                                tagCancelIconPadding:
                                    EdgeInsets.only(left: 4.0, top: 2.0),
                                tagPadding: EdgeInsets.only(
                                    top: 2.0,
                                    bottom: 4.0,
                                    left: 8.0,
                                    right: 4.0),
                                tagDecoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Constants.formBorder,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                tagTextStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Constants.bgColor,
                                    fontFamily: "Montserrat"),
                              ),
                              textFieldStyler: TextFieldStyler(
                                helperText: '',
                                hintText:
                                    "Please mention your hobbies example #hobbies1 #hobbies2...",
                                hintStyle: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10.0.sp),
                                isDense: false,
                                textFieldFocusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                                textFieldBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                                textFieldEnabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                                textFieldDisabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Constants.formBorder,
                                  ),
                                ),
                              ),
                              onDelete: (tag) {
                                print('onDelete: $tag');
                              },
                              onTag: (tag) {
                                print('onTag: $tag');
                                hobbieList.add(tag);
                              },
                              // validator: (String tag) {
                              //   print('validator: $tag');
                              //   if (tag.length > 10) {
                              //     return "hey that is too much";
                              //   }
                              //   return null;
                              // },
                            )
                                // FlutterTagging<Hobbies>(
                                //   initialItems: _selectedHobbies,
                                //   textFieldConfiguration: TextFieldConfiguration(
                                //     decoration: InputDecoration(
                                //         //labelText: "Please mention your achivements...",
                                //         counterText: '',
                                //         fillColor: Colors.white,
                                //         focusedBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(5.0),
                                //           borderSide: BorderSide(
                                //             color: Constants.formBorder,
                                //           ),
                                //         ),
                                //         enabledBorder: OutlineInputBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(5.0),
                                //           borderSide: BorderSide(
                                //             color: Constants.formBorder,
                                //             //width: 2.0,
                                //           ),
                                //         ),
                                //         hintText:
                                //             "Please mention your hobbies example #hobbies1 #hobbies2..."),
                                //     //keyboardType: TextInputType.emailAddress,
                                //     style: new TextStyle(
                                //         fontFamily: "Montserrat",
                                //         fontSize: 10.0.sp),
                                //   ),
                                //   findSuggestions: HobbieService.getLanguages,
                                //   additionCallback: (value) {
                                //     return Hobbies(
                                //       name: value,
                                //       position: 0,
                                //     );
                                //   },
                                //   onAdded: (language) {
                                //     // api calls here, triggered when add to tag button is pressed
                                //     return Hobbies(
                                //       name: language.name,
                                //       position: 0,
                                //     );
                                //   },
                                //   configureSuggestion: (lang) {
                                //     return SuggestionConfiguration(
                                //       title: Text(lang.name),
                                //       //subtitle: Text(lang.position.toString()),
                                //       additionWidget: Chip(
                                //         avatar: Icon(
                                //           Icons.add_circle,
                                //           color: Colors.white,
                                //         ),
                                //         label: Text('Add New Tag'),
                                //         labelStyle: TextStyle(
                                //           fontFamily: 'Montserrat',
                                //           fontSize: 10.0.sp,
                                //           color: Colors.white,
                                //           fontWeight: FontWeight.w300,
                                //         ),
                                //         backgroundColor: Constants.bgColor,
                                //       ),
                                //     );
                                //   },
                                //   configureChip: (lang) {
                                //     return ChipConfiguration(
                                //       label: Text(lang.name),
                                //       backgroundColor: Constants.bgColor,
                                //       labelStyle: TextStyle(color: Colors.white),
                                //       deleteIconColor: Colors.white,
                                //     );
                                //   },
                                //   onChanged: () {
                                //     setState(() {
                                //       _selectedHobbiesJson = _selectedHobbies
                                //           .map<String>(
                                //               (lang) => '\n${lang.toJson()}')
                                //           .toList()
                                //           .toString();
                                //       _selectedHobbiesJson = _selectedHobbiesJson
                                //           .replaceFirst('}]', '}\n]');
                                //     });
                                //   },
                                // ),
                                ),
                          ),
                        ),
                        // Theme(
                        //   data: new ThemeData(
                        //     primaryColor: Constants.bpSkipStyle,
                        //     primaryColorDark: Constants.bpSkipStyle,
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 3.0.w, right: 3.0.w, top: 3.0.h),
                        //     child: Container(
                        //       height: 13.0.h,
                        //       width: 90.0.w,
                        //       child: TextFormField(
                        //         maxLines: 5,
                        //         keyboardType: TextInputType.multiline,
                        //         maxLength: 100,
                        //         decoration: InputDecoration(
                        //             //labelText: "Please mention your achivements...",
                        //             counterText: '',
                        //             fillColor: Colors.white,
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(5.0),
                        //               borderSide: BorderSide(
                        //                 color: Constants.formBorder,
                        //               ),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(5.0),
                        //               borderSide: BorderSide(
                        //                 color: Constants.formBorder,
                        //                 //width: 2.0,
                        //               ),
                        //             ),
                        //             hintText:
                        //                 "Please mention your hobbies example #hobbie1 #hobbie2..."),
                        //         //keyboardType: TextInputType.emailAddress,
                        //         style: new TextStyle(
                        //             fontFamily: "Montserrat",
                        //             fontSize: 10.0.sp),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 2.0.h, left: 3.0.w, right: 3.0.w),
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
                                controller: _fbLinkController,
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
                                controller: _instagramLinkController,
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
                                controller: _linkedInLinkLinkController,
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
                                controller: _otherLinkLinkController,
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
                            onTap: () async {
                              print('Submit!!!');
                              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9."
                                      r"!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(_emailController.text.trim());
                              if (_nameController.text.trim().isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (_mobileController.text
                                      .trim()
                                      .isEmpty ||
                                  _mobileController.text.length < 10) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Valid Mobile Number",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (_emailController.text.trim().isEmpty ||
                                  (emailValid == false)) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Valid Email Id",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (gender == 'Gender') {
                                Fluttertoast.showToast(
                                    msg: "Please Select Gender",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (birthDateInString == null ||
                                  birthDateInString == '') {
                                Fluttertoast.showToast(
                                    msg: "Please Select DOB",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (docType == 'DocType') {
                                Fluttertoast.showToast(
                                    msg: "Please Select Document Type",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (myControllers[0].text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter School Name",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (_idNumController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Valid ID Number",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (qualification == '0') {
                                Fluttertoast.showToast(
                                    msg: "Please Select Qualification",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (workExp == '0') {
                                Fluttertoast.showToast(
                                    msg: "Please Select Work Experience",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (teachExp == '0') {
                                Fluttertoast.showToast(
                                    msg: "Please Select Teaching Experience",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (fileName == null || fileName == '') {
                                Fluttertoast.showToast(
                                    msg: "Please Pick Selected Document",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if (_certiName == null ||
                                  _certiName == '') {
                                Fluttertoast.showToast(
                                    msg: "Please Pick Certificate",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else {
                                if (_document != null && _image != null && _certificate != null) {
                      final dir = await path_provider
                          .getTemporaryDirectory();
                      final targetPath =
                          dir.absolute.path + "/temp.jpg";
                      final docFile =
                      await compressAndGetFile(
                          _document, targetPath);
                      final imgFile =
                      await compressAndGetFile(
                          _document, targetPath);
                      final certiFile =
                      await compressAndGetFile(
                          _certificate, targetPath);
                      if (imgFile == null && docFile == null) {
                        return;
                      }
                      setState(() {});
                      print(imgFile.path);
                      // saveProfileWithImage(imgFile);
                      //updateProfilewithImage(imgFile);
                       updateProfile(
                                  userId,
                                  registerAs,
                                  //'https://static4.depositphotos.com/1006994/298/v/950/depositphotos_2983099-stock-illustration-grunge-design.jpg',
                                  //'https://static4.depositphotos.com/1006994/298/v/950/depositphotos_2983099-stock-illustration-grunge-design.jpg',
                                  _nameController.text,
                                  _mobileController.text,
                                  _emailController.text,
                                  gender,
                                  birthDateInString,
                                  docType,
                                  imgFile,
                                  docFile,
                                  certiFile,
                                  //'https://static4.depositphotos.com/1006994/298/v/950/depositphotos_2983099-stock-illustration-grunge-design.jpg',
                                  _idNumController.text,
                                  _achivementController.text,
                                  skillList.toString(),
                                  hobbieList.toString(),
                                  _fbLinkController.text,
                                  _instagramLinkController.text,
                                  _linkedInLinkLinkController.text,
                                  _otherLinkLinkController.text,
                                  totalWorkExp,
                                  totalTeachExp);
                    } else {
                      // updateProfileWithoutMedia(
                      //             userId,
                      //             registerAs,
                      //             //'https://static4.depositphotos.com/1006994/298/v/950/depositphotos_2983099-stock-illustration-grunge-design.jpg',
                      //             //'https://static4.depositphotos.com/1006994/298/v/950/depositphotos_2983099-stock-illustration-grunge-design.jpg',
                      //             _nameController.text,
                      //             _mobileController.text,
                      //             _emailController.text,
                      //             'M',
                      //             '10/10/2010', //birthDateInString,
                      //             "A",
                      //             //imgFile,
                      //             //'https://static4.depositphotos.com/1006994/298/v/950/depositphotos_2983099-stock-illustration-grunge-design.jpg',
                      //             _idNumController.text,
                      //             _achivementController.text,
                      //             skillList.toString(),
                      //             hobbieList.toString(),
                      //             '5',
                      //             '5');
                    }
                             
                              // Navigator.of(context).push
                              //     //pushAndRemoveUntil
                              //     (MaterialPageRoute(
                              //         builder: (context) => bottomNavBar(0)));
                              // //(Route<dynamic> route) => false);
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

  //Update Profile API
  Future<ProfileUpdate> updateProfile(
    int userId,
    String registerAs,
    //String imageFile,
    //String imageUrl,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String dob,
    String documentType,
    File documentFile,
    File imageFile,
    File certificateFile,
    //String documentUrl,
    String idNumber,
    //List<Location> location,
    String achievements,
    String skills,
    String hobbies,
    String facbookUrl,
    String instaUrl,
    String linkedinUrl,
    String otherUrl,
    //List<EducationalDetails> educationalDetails,
    int totalWorkExp,
    int totalTeachExp,
    //List<InterestedCategory> interestedCategory,
  ) async {
    displayProgressDialog(context);
    String docname = documentFile.path.split('/').last;
    String imgname = imageFile.path.split('/').last;
    String certiname = certificateFile.path.split('/').last;
    Map<String, dynamic> educationDetailMap;
    var result = ProfileUpdate();
    // for (int i = 0; i <= myControllers.length; i++) {
    //   //education_details.add()
    //   educationDetailMap = {
    //     "id": 5,
    //     "school_name": "",
    //     "year": "",
    //     "qualification": "",
    //     "certificate_file": ""
    //   };
    // }
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'user_id': userId,
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_file': await MultipartFile.fromFile(documentFile.path,
            filename: docname,),
        'image_file': await MultipartFile.fromFile(imageFile.path,
            filename: imgname,),
        //'document_url': documentUrl,
        'identification_document_number': idNumber,
        'location[0][id]': 54,
        'location[0][address_line_1]': 'abc',
        'location[0][address_line_2]': 'def',
        'location[0][city]': 'Gujarat',
        'location[0][country]': 'India',
        'location[0][pincode]': 390006,
        'location[0][latitude]': 123.00,
        'location[0][longitude]': 456.00,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills,
        'hobbies': hobbies,
        'educational_details[0][id]': 25,
        'educational_details[0][school_name]': myControllers[0].text.toString(),
        'educational_details[0][year]': selectedYear.year,
        'educational_details[0][qualification]': qualification.toString(),
        'educational_details[0][certificate_file]': await MultipartFile.fromFile(certificateFile.path,
            filename: certiname,
            //contentType: new MediaType("jpg", "jpeg", "png", "pdf"),
            ),
        'facbook_link': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
        'total_teaching_experience': totalTeachExp,
      });
      var response = await dio.post(Config.updateProfileUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}),
          // onSendProgress: (int sent, int total){
          //   print('SENT $sent + TOTAL $total');
          // }
          );
      if (response.statusCode == 200) {
        print(response.data);
        closeProgressDialog(context);
        result = ProfileUpdate.fromJson(response.data);
        print(result.data.name);
        //if(result.status == true){
        // print('ID ::: ' + result.data.userId.toString());
        // saveUserData(result.data.userId);

        Fluttertoast.showToast(
          msg: result.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        Fluttertoast.showToast(
          msg: result.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
      print(result);
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::" +
            e.response.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return result;
  }

  //Update Profile API without Media
  // Future<ProfileUpdate> updateProfileWithoutMedia(
  //   int userId,
  //   String registerAs,
  //   //String imageFile,
  //   //String imageUrl,
  //   String name,
  //   String mobileNumber,
  //   String email,
  //   String gender,
  //   String dob,
  //   String documentType,
  //   //File documentFile,
  //   //String documentUrl,
  //   String idNumber,
  //   //List<Location> location,
  //   String achievements,
  //   String skills,
  //   String hobbies,
  //   // Null facbookUrl,
  //   // Null instaUrl,
  //   // Null linkedinUrl,
  //   //Null otherUrl,
  //   //List<EducationalDetails> educationalDetails,
  //   String totalWorkExp,
  //   String totalTeachExp,
  //   //List<InterestedCategory> interestedCategory,
  // ) async {
  //   displayProgressDialog(context);
  //   //String filename = documentFile.path.split('/').last;
  //   Map<String, dynamic> educationDetailMap;
  //   var result = ProfileUpdate();
  //   // for (int i = 0; i <= myControllers.length; i++) {
  //   //   //education_details.add()
  //   //   educationDetailMap = {
  //   //     "id": 5,
  //   //     "school_name": "",
  //   //     "year": "",
  //   //     "qualification": "",
  //   //     "certificate_file": ""
  //   //   };
  //   // }
  //   try {
  //     Dio dio = Dio();
  //     FormData formData = FormData.fromMap({
  //       'user_id': userId,
  //       'register_as': registerAs,
  //       //'image_file': imageFile,
  //       //'image_url': imageUrl,
  //       'name': name,
  //       'mobile_number': mobileNumber,
  //       'email': email,
  //       'gender': gender,
  //       'dob': dob,
  //       'document_type': documentType,
  //       // 'document_file': await MultipartFile.fromFile(documentFile.path,
  //       //     filename: filename,
  //       //     //contentType: new MediaType("jpg", "jpeg", "png", "pdf"),
  //       //     ),
  //       //'dicument_url': documentUrl,
  //       'identification_document_number': idNumber,
  //       'achievements': achievements,
  //       'skills': skills,
  //       'hobbies': hobbies,
  //       'total_work_experience': totalWorkExp,
  //       'total_teaching_experience': totalTeachExp,
  //     });
  //     var response = await dio.post(Config.updateProfileUrl,
  //         data: formData,
  //         options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
  //     if (response.statusCode == 200) {
  //       print(response.data);
  //       closeProgressDialog(context);
  //       result = ProfileUpdate.fromJson(response.data);
  //       print(result.data.name);
  //       //if(result.status == true){
  //       // print('ID ::: ' + result.data.userId.toString());
  //       // saveUserData(result.data.userId);

  //       Fluttertoast.showToast(
  //         msg: result.message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Constants.bgColor,
  //         textColor: Colors.white,
  //         fontSize: 10.0.sp,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: result.message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Constants.bgColor,
  //         textColor: Colors.white,
  //         fontSize: 10.0.sp,
  //       );
  //     }
  //     print(result);
  //   } on DioError catch (e, stack) {
  //     print(e.response);
  //     print(stack);
  //     closeProgressDialog(context);
  //     if (e.response != null) {
  //       print("This is the error message::::" +
  //           e.response.data['meta']['message']);
  //       Fluttertoast.showToast(
  //         msg: e.response.data['meta']['message'],
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Constants.bgColor,
  //         textColor: Colors.white,
  //         fontSize: 10.0.sp,
  //       );
  //     } else {
  //       // Something happened in setting up or sending the request that triggered an Error
  //       print(e.request);
  //       print(e.message);
  //     }
  //   }
  //   return result;
  // }

  // compress image
  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75,
    );

    // print(file.lengthSync());
    // print(result.lengthSync());

    return result;
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
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

/// LanguageService
// class SkillService {
//   /// Mocks fetching language from network API with delay of 500ms.
//   static Future<List<Skills>> getLanguages(String query) async {
//     await Future.delayed(Duration(milliseconds: 500), null);
//     return <Skills>[
//       Skills(name: 'JavaScript', position: 1),
//       Skills(name: 'Python', position: 2),
//       Skills(name: 'Java', position: 3),
//       Skills(name: 'PHP', position: 4),
//       Skills(name: 'C#', position: 5),
//       Skills(name: 'C++', position: 6),
//     ]
//         .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
// }

// class Skills extends Taggable {
//   ///
//   final String name;

//   ///
//   final int position;

//   /// Creates Language
//   Skills({
//     this.name,
//     this.position,
//   });

//   @override
//   List<Object> get props => [name];

//   /// Converts the class to json string.
//   String toJson() => '''  {
//     "name": $name,\n
//     "position": $position\n
//   }''';
// }

// class HobbieService {
//   /// Mocks fetching language from network API with delay of 500ms.
//   static Future<List<Hobbies>> getLanguages(String query) async {
//     await Future.delayed(Duration(milliseconds: 500), null);
//     return <Hobbies>[
//       Hobbies(name: 'Dance', position: 1),
//       Hobbies(name: 'Music', position: 2),
//       Hobbies(name: 'Teach', position: 3),
//       Hobbies(name: 'Play', position: 4),
//       Hobbies(name: 'Swim', position: 5),
//       Hobbies(name: 'Read', position: 6),
//     ]
//         .where((lang) => lang.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
// }

// class Hobbies extends Taggable {
//   ///
//   final String name;

//   ///
//   final int position;

//   /// Creates Language
//   Hobbies({
//     this.name,
//     this.position,
//   });

//   @override
//   List<Object> get props => [name];

//   /// Converts the class to json string.
//   String toJson() => '''  {
//     "name": $name,\n
//     "position": $position\n
//   }''';
// }
