import 'dart:io';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Learner_ProfileDetails_Model.dart';
import 'package:being_pupil/Model/Profile_Details_Model.dart';
import 'package:being_pupil/Model/UpdateProfile_Model.dart';
import 'package:being_pupil/Model/Update_Learner_Profile_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:being_pupil/Registration/Learner_Registration.dart';


class EditLearnerProfile extends StatefulWidget {
  const EditLearnerProfile({Key key}) : super(key: key);

  @override
  _EditLearnerProfileState createState() => _EditLearnerProfileState();
}

class _EditLearnerProfileState extends State<EditLearnerProfile> {
  File _image, _certificate, _document;
  String birthDateInString, selectedYearString;
  DateTime birthDate, selectedYear;
  bool isDateSelected = false;
  bool isYearSelected = false;
  String gender = 'Gender';
  String docType = 'DocType';
  String workExp = '0';
  String fileName;
  String imagePath, documentPath;
  String address1, address2, city, country, pinCode;
  double lat, lng;
  bool isCat1 = false;
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

  Map<String, dynamic> categoryMap = Map<String, dynamic>();
  List<dynamic> categoryMapData = List<dynamic>();
  List<bool> intrestedCat = List<bool>();
  List<int> intrestedCatKey = List<int>();

  List<String> selectedSkillList = [];
  List<String> selectedHobbiesList = [];

  Map<String, dynamic> skillMap = Map<String, dynamic>();
  List<dynamic> skillMapData = List();

  Map<String, dynamic> hobbieMap = Map<String, dynamic>();
  List<dynamic> hobbieMapData = List();

  var result = LearnerProfileDetails();
  bool isLoading = true;
  String registerAs;
  int totalWorkExp;

  // List<Skills> _selectedSkills;
  // String _selectedSkillsJson = 'Nothing to show';

  // List<Hobbies> _selectedHobbies;
  // String _selectedHobbiesJson = 'Nothing to show';

  List<String> catList = List();
  String authToken;
  List controllersList = [];
  Map<String, dynamic> eduMap;
  List<dynamic> eduMapData;

  @override
  void initState() {
    super.initState();
    // _selectedSkills = [];
    // _selectedHobbies = [];
    getToken();
    //getCatList();
    // catList = [
    //   'Category 1',
    //   'Category 2',
    //   'Category 3',
    //   'Category 4',
    //   'Category 5',
    //   'Category 6',
    //   'Category 7',
    //   'Category 8',
    // ];
  }
  
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }

   populateEducationDetails(){
    print(result.data.educationalDetails);
    if(result.data.educationalDetails != null){
      for(int i = 0; i < result.data.educationalDetails.length; i++){
        controllersList.add(TextEditingController());
        controllersList[i].text = eduMapData[i]['school_name'];
        result.data.educationalDetails1[i]['year'] = eduMapData[i]['year'];
        result.data.educationalDetails1[i]['qualification'] = eduMapData[i]['qualification'];
        //fileImage.add(result.data.educationalDetails1[i]['certificate_file']);
      }
    }else{
      if(eduMapData != null){
        for(int i = 0; i < eduMapData.length; i++){
          controllersList.add(TextEditingController());
          controllersList[i].text = eduMapData[i]['school_name'];
        }
      }else{
        eduMapData = [];
      }
    }
  }

  // @override
  // void dispose() {
  //   _selectedSkills.clear();
  //   _selectedHobbies.clear();
  //   super.dispose();
  // }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getData();
    getCatSkillHobbieList();
    // getSkillListApi();
    // getHobbiesListApi();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      //userId = preferences.getInt('userId');
    });
    print(registerAs);
  }

  _imageFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      imagePath = _image.path;
    });
    //print('FILE::' + imagePath);
  }

  _imageFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      imagePath = _image.path;
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
        documentPath = _document.path;
      });

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print('DOC:::' + documentPath);
    } else {}
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Constants.bgColor),
                ),
              )
            : Padding(
                padding:
                    EdgeInsets.only(bottom: 3.0.h, left: 5.0.w, right: 5.0.w),
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
                                      ? Stack(
                                    children: [
                                      Container(
                                        height: 3.2.w * 10,
                                        width: 3.2.w * 10,
                                        child: Stack(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 70,
                                              backgroundImage: AssetImage(
                                                  'assets/icons/circle_upload.png'),
                                              backgroundColor: Colors.transparent,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(70),
                                                child: Image.file(
                                                  _image,
                                                  height: 125.0,//14.0.h,
                                                  width: 125.0,//30.0.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 3.2.w * 2.5,
                                                width: 3.2.w * 2.5,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Constants.formBorder,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Center(
                                                  heightFactor: 5.0.w * 1.5,
                                                  widthFactor: 5.0.w * 1.5,
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Constants.formBorder,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  )
                                      : Stack(
                                    children: [
                                      Container(
                                        height: 3.2.w * 10,
                                        width: 3.2.w * 10,
                                        child: Stack(
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  'assets/icons/circle_upload.png'),
                                              //backgroundColor: Colors.white,
                                              radius: 70.0,
                                              child: ClipRRect(
                                          borderRadius: BorderRadius.circular(70),
                                          child: Image.network(
                                            result.data.imageUrl,
                                            height: 125.0,//14.0.h,
                                            width: 125.0,//30.0.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                              // Align(
                                              //   alignment: Alignment.center,
                                              //   child: Column(
                                              //     // crossAxisAlignment: CrossAxisAlignment.center,
                                              //     mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              //     children: [
                                              //       Padding(
                                              //         padding: EdgeInsets.symmetric(
                                              //             vertical: 4.85.h),
                                              //         child: Column(
                                              //           children: [
                                              //             GestureDetector(
                                              //               onTap: () {
                                              //                 print('Upload Pic!!!');
                                              //                 _showPicker(context);
                                              //               },
                                              //               child: ImageIcon(
                                              //                 AssetImage(
                                              //                     'assets/icons/camera.png'),
                                              //                 size: 25,
                                              //                 color: Constants.formBorder,
                                              //               ),
                                              //             ),
                                              //             Text(
                                              //               'Upload',
                                              //               style: TextStyle(
                                              //                   fontFamily: 'Montserrat',
                                              //                   fontSize: 8.0.sp,
                                              //                   fontWeight:
                                              //                   FontWeight.w400,
                                              //                   color:
                                              //                   Constants.formBorder),
                                              //             )
                                              //           ],
                                              //         ),
                                              //       ),
                                              //       SizedBox(
                                              //         height: 0.5.h,
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 3.2.w * 2.5,
                                                width: 3.2.w * 2.5,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Constants.formBorder,
                                                    ),
                                                    shape: BoxShape.circle,
                                                    color: Colors.white),
                                                child: Center(
                                                  heightFactor: 5.0.w * 1.5,
                                                  widthFactor: 5.0.w * 1.5,
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Constants.formBorder,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Theme(
                                    data: new ThemeData(
                                      primaryColor: Constants.bpSkipStyle,
                                      primaryColorDark: Constants.bpSkipStyle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 3.0.w,
                                          right: 3.0.w,
                                          top: 3.0.h),
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
                                                  result.data.gender == null
                                                      ? 'Gender'
                                                      : result.data.gender ==
                                                              'M'
                                                          ? 'Male'
                                                          : result.data
                                                                      .gender ==
                                                                  'F'
                                                              ? 'Female'
                                                              : 'Other',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants
                                                          .bpSkipStyle),
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
                                            if (value == 1) {
                                        gender = 'M';
                                      } else if (value == 2) {
                                        gender = 'F';
                                      } else {
                                        gender = 'O';
                                      }
                                          },
                                          dropdownButtonStyle:
                                              DropdownButtonStyle(
                                            height: 7.0.h,
                                            width: 90.0.w,
                                            //padding: EdgeInsets.only(left: 2.0.w),
                                            elevation: 0,
                                            // backgroundColor:
                                            //     Color(0xFFA8B4C1).withOpacity(0.5),
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
                                          items: ['Male', 'Female', 'Other']
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
                                          left: 3.0.w,
                                          right: 3.0.w,
                                          top: 3.0.h),
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

                                        if (birthDate.day.toString().length ==
                                                1 &&
                                            birthDate.month.toString().length ==
                                                1) {
                                          setState(() {
                                            birthDateInString =
                                                "0${birthDate.day.toString()}/0${birthDate.month}/${birthDate.year}";
                                          });
                                          print('11111');
                                        } else if (birthDate.day
                                                .toString()
                                                .length ==
                                            1) {
                                          setState(() {
                                            birthDateInString =
                                                "0${birthDate.day}/${birthDate.month}/${birthDate.year}";
                                          });
                                          print('22222');
                                        } else if (birthDate.month
                                                .toString()
                                                .length ==
                                            1) {
                                          birthDateInString =
                                              "${birthDate.day}/0${birthDate.month}/${birthDate.year}";
                                        } else {
                                          birthDateInString =
                                              "${birthDate.day}/${birthDate.month}/${birthDate.year}";
                                        } // 08/14/2019
                                      });
                                          }
                                        },
                                        child: Container(
                                          height: 7.0.h,
                                          width: 40.0.w,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.0.w),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Constants.formBorder),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                isDateSelected
                                                    ? birthDateInString
                                                    : result.data.dob != null
                                                        ? result.data.dob
                                                        : 'DOB',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 10.0.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Constants.bpSkipStyle),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.0.w),
                                          child: Text(
                                            result.data.documentType == null
                                                ? 'Select Document Type'
                                                : result.data.documentType ==
                                                        'A'
                                                    ? 'Aadhaar'
                                                    : result.data
                                                                .documentType ==
                                                            'PN'
                                                        ? 'PAN'
                                                        : result.data
                                                                    .documentType ==
                                                                'PAS'
                                                            ? 'Passport'
                                                            : result.data
                                                                        .documentType ==
                                                                    'VI'
                                                                ? 'Voter ID'
                                                                : 'Driving Licence',
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
                                       if (value == 1) {
                                  docType = 'A';
                                  print(docType);
                                } else if (value == 2) {
                                  docType = 'PN';
                                  print(docType);
                                } else if (value == 3) {
                                  docType = 'PAS';
                                  print(docType);
                                } else if (value == 4) {
                                  docType = 'VI';
                                  print(docType);
                                } else {
                                  docType = 'DL';
                                  print(docType);
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
                                      side: BorderSide(
                                          color: Constants.formBorder),
                                    ),
                                    dropdownStyle: DropdownStyle(
                                      borderRadius: BorderRadius.circular(10.0),
                                      elevation: 6,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w, vertical: 1.5.h),
                                    ),
                                    items: [
                                      'Aadhaar        ',
                                      'PAN            ',
                                      'Passport       ',
                                      'Voter ID       ',
                                      'Driving License'
                                    ]
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
                                        _uploadDocument();
                                      },
                                      child: Container(
                                        height: 6.0.h,
                                        width: 90.0.w,
                                        color: Colors.transparent,
                                        child: Center(
                                            child: result.data.documentUrl ==
                                                    null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        (fileName == null ||
                                                                fileName == '')
                                                            ? 'Upload the file'
                                                            : fileName,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: 10.0.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Constants
                                                                .bpSkipStyle),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      Container(
                                                        //height: 5.0.h,
                                                        width: 15.0.w,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    result.data
                                                                        .documentUrl),
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                      SizedBox(width: 2.0.w),
                                                      Expanded(
                                                        child:
                                                            SingleChildScrollView(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Container(
                                                            height: 3.0.h,
                                                            //width: 50.0.w,
                                                            child: Text(
                                                              result.data
                                                                  .documentUrl
                                                                  .split('/')
                                                                  .last,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontSize:
                                                                      10.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Constants
                                                                      .bpSkipStyle),
                                                              //overflow: TextOverflow.fade,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
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
                                        labelText:
                                            "Identification Document Number",
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
                                      left: 3.0.w,
                                      right: 3.0.w,
                                      top: 3.0.h,
                                      //bottom: 3.0.h
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('Location!!!');
                                        //_showLocation(context);
                                        showPlacePicker();
                                      },
                                      child: Container(
                                        height: 7.0.h,
                                        width: 90.0.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.0.w),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constants.formBorder),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          //color: Color(0xFFA8B4C1).withOpacity(0.5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Container(
                                                  height: 2.5.h,
                                                  //width: 70.0.w,
                                                  child: Text(
                                                    address1 != null
                                                        ? address1
                                                        : result.data.location
                                                                .isEmpty
                                                            ? 'Location'
                                                            : result
                                                                .data
                                                                .location[0]
                                                                .addressLine1,
                                                    // address1 == null
                                                    //     ? 'Location'
                                                    //     : address1,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constants
                                                            .bpSkipStyle),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.0.w),
                                              child: Icon(
                                                Icons.gps_fixed,
                                                size: 25,
                                                color: Constants.formBorder,
                                              ),
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
                          itemCount: result.data.educationalDetails.length, //educationDetailMap.length, //itemCount,
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
                                    // index == 0
                                    //     ? Container()
                                    //     : Align(
                                    //         alignment: Alignment.topRight,
                                    //         child: Padding(
                                    //           padding:
                                    //               EdgeInsets.only(left: 4.0.w),
                                    //           child: GestureDetector(
                                    //             onTap: () {
                                    //               print(
                                    //                   'Remove Education ${index + 1} Block');
                                    //               setState(() {
                                    //                 //itemCount = itemCount - 1;
                                    //                 // educationDetailMap
                                    //                 //     .removeWhere(
                                    //                 //         (key, value) =>
                                    //                 //             key == index);
                                    //                 result.data.educationalDetails1.removeAt(index);
                                    //               });
                                    //               //print(educationDetailMap);
                                    //             },
                                    //             child: CircleAvatar(
                                    //               radius: 12.0,
                                    //               backgroundColor:
                                    //                   Constants.bgColor,
                                    //               child: Icon(
                                    //                 Icons.close_rounded,
                                    //                 color: Colors.white,
                                    //                 size: 12.0,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
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
                                            readOnly: true,
                                            controller: controllersList[index],
                                            // onChanged: (value) {
                                            //   educationDetailMap[index]
                                            //           ['school_name'] =
                                            //       value.toString();
                                            //   print(
                                            //       'SCHOOL### ${value.toString()}');
                                            // },
                                            decoration: InputDecoration(
                                              labelText: 
                                              // result
                                              //     .data
                                              //     .educationalDetails1[index]['school_name'],
                                                   "Name of School",
                                              fillColor: Colors.white,
                                              // hintText: result
                                              //     .data
                                              //     .educationalDetails[index]
                                              //     .schoolName,
                                              // educationDetailMap[index]
                                              //         ['school_name']
                                              //     .toString(),
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
                                          // child: GestureDetector(
                                          //   onTap: () async {
                                          //     print('Year!!!');
                                          //     showDialog(
                                          //       context: context,
                                          //       builder:
                                          //           (BuildContext context) {
                                          //         return AlertDialog(
                                          //           title: Text(
                                          //             "Select Qualification Year",
                                          //             style: TextStyle(
                                          //                 fontFamily:
                                          //                     'Montserrat',
                                          //                 fontSize: 14.0.sp,
                                          //                 color:
                                          //                     Constants.bgColor,
                                          //                 fontWeight:
                                          //                     FontWeight.w700),
                                          //           ),
                                          //           content: Container(
                                          //             // Need to use container to add size constraint.
                                          //             width: 75.0.w,
                                          //             height: 50.0.h,
                                          //             child: YearPicker(
                                          //               firstDate: DateTime(
                                          //                   DateTime(1960).year,
                                          //                   1),
                                          //               lastDate: DateTime(
                                          //                   DateTime.now().year,
                                          //                   1),
                                          //               //initialDate: DateTime.now(),
                                          //               // save the selected date to _selectedDate DateTime variable.
                                          //               // It's used to set the previous selected date when
                                          //               // re-showing the dialog.
                                          //               selectedDate:
                                          //                   // isYearSelected
                                          //                   //     ? DateFormat('YYYY').parse(educationDetailMap[index]['year'])
                                          //                   //     :
                                          //                   DateTime(
                                          //                       DateTime.now()
                                          //                           .year),
                                          //               onChanged: (DateTime
                                          //                   dateTime) {
                                          //                 // close the dialog when year is selected.
                                          //                 setState(() {
                                          //                   isYearSelected =
                                          //                       true;
                                          //                   selectedYear =
                                          //                       dateTime;
                                          //                 });

                                          //                  result.data.educationalDetails1[index]['year'] =
                                          //                     selectedYear.year
                                          //                         .toString();

                                          //                 print(educationDetailMap);
                                          //                 print(selectedYear);
                                          //                 print(selectedYear
                                          //                     .year);
                                          //                 Navigator.pop(
                                          //                     context);
                                          //                 // Do something with the dateTime selected.
                                          //                 // Remember that you need to use dateTime.year to get the year
                                          //               },
                                          //             ),
                                          //           ),
                                          //         );
                                          //       },
                                          //     );
                                              
                                          //   },
                                            child: 
                                            Container(
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    // isYearSelected
                                                    //     ? selectedYear.year.toString()
                                                    //     : 
                                                        result.data.educationalDetails1[index]['year'],
                                                    //'Year',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constants
                                                            .bpSkipStyle),
                                                  ),
                                                  Padding(
                                                  padding: EdgeInsets.only(left: 0.0),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 25,
                                                    color: Constants.formBorder,
                                                  ),
                                                )
                                                ],
                                              ),
                                            //),
                                          )),
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
                                        //child: 
                                        // CustomDropdown<int>(
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Padding(
                                        //         padding: EdgeInsets.symmetric(
                                        //             horizontal: 3.0.w),
                                        //         child: Text(result.data.educationalDetails1[index]['qualification'],
                                        //           // result
                                        //           //     .data
                                        //           //     .educationalDetails[index]
                                        //           //     .qualification,
                                        //           //'Qualification',
                                        //           style: TextStyle(
                                        //               fontFamily: 'Montserrat',
                                        //               fontSize: 10.0.sp,
                                        //               fontWeight:
                                        //                   FontWeight.w400,
                                        //               color: Constants
                                        //                   .bpSkipStyle),
                                        //         ),
                                        //       ),
                                        //       //SizedBox(width: 50.0.w)
                                        //     ],
                                        //   ),
                                        //   // icon: Icon(
                                        //   //   Icons.expand_more,
                                        //   //   color: Constants.bpSkipStyle,
                                        //   // ),
                                        //   onChange: (int value, int index) {
                                        //     print(value);
                                        //     if (value > 0) {
                                        //       setState(() {
                                        //         qualification = '1';
                                        //       });
                                        //     }
                                        //     if (value == 1) {
                                        //       qualification = 'Graduate';
                                        //       // educationDetailMap[educationId]
                                        //       //         ['qualification'] =
                                        //       //     'Graduate';
                                        //       eduMapData[index]['qualification'] = 'Graduate';
                                        //       print(qualification);
                                        //     } else if (value == 2) {
                                        //       qualification = 'Post-graduate';
                                        //       // educationDetailMap[educationId]
                                        //       //         ['qualification'] =
                                        //       //     'Post-graduate';
                                        //       eduMapData[index]['qualification'] = 'Post-graduate';
                                        //       print(qualification);
                                        //     } else if (value == 3) {
                                        //       qualification =
                                        //           'Chartered Accountant';
                                        //       // educationDetailMap[educationId]
                                        //       //         ['qualification'] =
                                        //       //     'Chartered Accountant';
                                        //       eduMapData[index]['qualification'] = 'Chartered Accountant';
                                        //       print(qualification);
                                        //     } else {
                                        //       qualification = 'Others';
                                        //       // educationDetailMap[educationId]
                                        //       //     ['qualification'] = 'Others';
                                        //       eduMapData[index]['qualification'] = 'Others';
                                        //       print(qualification);
                                        //     }
                                        //   },
                                        //   dropdownButtonStyle:
                                        //       DropdownButtonStyle(
                                        //     height: 7.0.h,
                                        //     width: 90.0.w,
                                        //     //padding: EdgeInsets.only(left: 2.0.w),
                                        //     elevation: 0,
                                        //     //backgroundColor: Colors.white,
                                        //     primaryColor: Constants.bpSkipStyle,
                                        //     side: BorderSide(
                                        //         color: Constants.formBorder),
                                        //   ),
                                        //   dropdownStyle: DropdownStyle(
                                        //     borderRadius:
                                        //         BorderRadius.circular(10.0),
                                        //     elevation: 6,
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 2.0.w,
                                        //         vertical: 1.5.h),
                                        //   ),
                                        //   items: [
                                        //     'Graduate',
                                        //     'Post-graduate',
                                        //     'Chartered Accountant',
                                        //     'Others'
                                        //   ]
                                        //       .asMap()
                                        //       .entries
                                        //       .map(
                                        //         (item) => DropdownItem<int>(
                                        //           value: item.key + 1,
                                        //           child: Padding(
                                        //             padding:
                                        //                 const EdgeInsets.all(
                                        //                     8.0),
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    // isYearSelected
                                                    //     ? selectedYear.year.toString()
                                                    //     : 
                                                       result.data.educationalDetails1[index]['qualification'],
                                                    //'Year',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 10.0.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Constants
                                                            .bpSkipStyle),
                                                  ),
                                                  Padding(
                                                  padding: EdgeInsets.only(left: 0.0),
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 25,
                                                    color: Constants.formBorder,
                                                  ),
                                                )
                                                ],
                                              ),
                                            //),
                                          )
                                                  //   Row(
                                                  //     children: [
                                                  //       Text(
                                                  //         result.data.educationalDetails1[index]['qualification'],
                                                  //         style: TextStyle(
                                                  //             fontFamily:
                                                  //                 'Montserrat',
                                                  //             fontSize: 10.0.sp,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .w400,
                                                  //             color: Constants
                                                  //                 .bpSkipStyle),
                                                  //       ),
                                                  //       //SizedBox(width: 60.0.w)
                                                  //     ],
                                                  //   //),
                                                  // ),
                                                //),
                                              //)
                                              //.toList(),
                                       // ),
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
                                          //child:  GestureDetector(
                                          //   onTap: () {
                                          //     print('Upload!!!');
                                          //     //certificateList.removeAt(index);
                                          //     _showCertificatePicker(context, index);
                                          //     print(fileImage);
                                          //   },
                                            child: Container(
                                              height: 6.0.h,
                                              width: 90.0.w,
                                              color: Colors.transparent,
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    //height: 5.0.h,
                                                    width: 15.0.w,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: 
                                                            //fileImage[index] == null ? //NetworkImage(certificateList[index])
                                                            NetworkImage(result.data.educationalDetails1[index]['certificate_file']),
                                                            //: FileImage(fileImage[index]),
                                                            fit: BoxFit.fill)),
                                                  ),
                                                  SizedBox(width: 2.0.w),
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Container(
                                                        height: 3.0.h,
                                                        //width: 50.0.w,
                                                        child: Text('Certificate ${index + 1}',
                                                          // result
                                                          //     .data
                                                          //     .educationalDetails1[
                                                          //         index]['certificate_file']
                                                          //     .split('/')
                                                          //     .last,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Constants
                                                                  .bpSkipStyle),
                                                          //overflow: TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                                 
                                                  ),
                                            //),
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

                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 4.0.h, left: 3.0.w, right: 3.0.w),
                                    child: Text(
                                      'Interested Categories',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12.0.sp,
                                          color: Constants.bgColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),

                              GridView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(0.0),
                                  itemCount: categoryMapData.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 5),
                                  itemBuilder: (context, index) {
                                    return CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        title: Text(
                                            categoryMapData[index]['value'],
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 10.0.sp,
                                                color: Color(0xFF6B737C),
                                                fontWeight: FontWeight.w400)),
                                        activeColor: Constants.bgColor,
                                        value: intrestedCat[index],
                                        onChanged: (value) {
                                          setState(() {
                                            intrestedCat[index] =
                                                !intrestedCat[index];
                                            if (intrestedCat[index] == true) {
                                              intrestedCatKey.add(index + 1);
                                              intrestedCatKey.sort();
                                            } else {
                                              intrestedCatKey.remove(index + 1);
                                            }
                                            intrestedCatKey.sort();
                                            print(intrestedCatKey);
                                          });
                                        });
                                  }),

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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.0.w),
                                          child: Text(
                                            result.data.totalWorkExperience ==
                                                    null
                                                ? 'Total Work Experience'
                                                : result.data.totalWorkExperience,
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
                                      print(value);
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
                                      side: BorderSide(
                                          color: Constants.formBorder),
                                    ),
                                    dropdownStyle: DropdownStyle(
                                      borderRadius: BorderRadius.circular(10.0),
                                      elevation: 6,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w, vertical: 1.5.h),
                                    ),
                                    items: [
                                '1 Year',
                                '2 Years',
                                '3 Years',
                                '4 Years',
                                '5 Years',
                                '6 Years',
                                '7 Years',
                                '8 Years',
                                '9 Years',
                                '10 Years',
                                '11 Years',
                                '12 Years',
                                '13 Years',
                                '14 Years',
                                '15 Years',
                                '15+ Years'
                                    ]
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
                                  child: GestureDetector(
                                    onTap: () {
                                      _openFilterSkillsDialog();
                                    },
                                    child: Container(
                                      height: 13.0.h,
                                      width: 90.0.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constants.formBorder),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Text(
                                          selectedSkillList == null ||
                                            selectedSkillList.length == 0
                                              ? result.data.skills
                                              : selectedSkillList.length > 0
                                                  ? selectedSkillList.toString().replaceAll('[', '').replaceAll(']', '').
                                            replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#')
                                                  : "Please mention your hobbies example #skill1 #skill2....",
                                          //: '',
                                          //.replaceAll(new RegExp(r', '), '# '),
                                          style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 10.0.sp,
                                              color: Constants.bpSkipStyle),
                                        ),
                                      ),
                                      //TextFieldTags(
                                      //   //initialTags: ["college"],
                                      //   tagsStyler: TagsStyler(
                                      //     showHashtag: true,
                                      //     tagMargin: const EdgeInsets.only(right: 4.0),
                                      //     tagCancelIcon: Icon(Icons.cancel,
                                      //         size: 20.0, color: Constants.bgColor),
                                      //     tagCancelIconPadding:
                                      //         EdgeInsets.only(left: 4.0, top: 2.0),
                                      //     tagPadding: EdgeInsets.only(
                                      //         top: 2.0,
                                      //         bottom: 4.0,
                                      //         left: 8.0,
                                      //         right: 4.0),
                                      //     tagDecoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       border: Border.all(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //       borderRadius: const BorderRadius.all(
                                      //         Radius.circular(20.0),
                                      //       ),
                                      //     ),
                                      //     tagTextStyle: TextStyle(
                                      //         fontWeight: FontWeight.normal,
                                      //         color: Constants.bgColor,
                                      //         fontFamily: "Montserrat"),
                                      //   ),
                                      //   textFieldStyler: TextFieldStyler(
                                      //     helperText: '',
                                      //     hintText:
                                      //         "Please mention your skills example #skills1 #skills2...",
                                      //     hintStyle: TextStyle(
                                      //         fontFamily: "Montserrat",
                                      //         fontSize: 10.0.sp),
                                      //     isDense: false,
                                      //     textFieldFocusedBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //     textFieldBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //     textFieldEnabledBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //     textFieldDisabledBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   onDelete: (tag) {
                                      //     print('onDelete: $tag');
                                      //   },
                                      //   onTag: (tag) {
                                      //     print('onTag: $tag');
                                      //   },
                                      //   // validator: (String tag) {
                                      //   //   print('validator: $tag');
                                      //   //   if (tag.length > 10) {
                                      //   //     return "hey that is too much";
                                      //   //   }
                                      //   //   return null;
                                      //   // },
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
                                  child: GestureDetector(
                                    onTap: () {
                                      _openFilterHobbiesDialog();
                                    },
                                    child: Container(
                                      height: 13.0.h,
                                      width: 90.0.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0.w),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Constants.formBorder),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Center(
                                        child: Text(
                                          selectedHobbiesList == null ||
                                            selectedHobbiesList.length == 0
                                              ? result.data.hobbies
                                              : selectedHobbiesList.length > 0
                                                  ? selectedHobbiesList
                                                      .toString().replaceAll('[', '').replaceAll(']', '').
                                            replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#')
                                                  : "Please mention your hobbies example #hobbie1 #hobbie2....",
                                          // selectedHobbiesList == null ||
                                          //         selectedHobbiesList.length == 0
                                          //     ? "Please mention your hobbies example #hobbie1 #hobbie2..."
                                          //     : selectedHobbiesList
                                          //         .toString(), //.replaceAll(new RegExp(r', '), '# '),
                                          style: TextStyle(
                                              fontFamily: "Montserrat",
                                              fontSize: 10.0.sp,
                                              color: Constants.bpSkipStyle),
                                        ),
                                      ),
                                      //     TextFieldTags(
                                      //   //initialTags: ["college"],
                                      //   tagsStyler: TagsStyler(
                                      //     showHashtag: true,
                                      //     tagMargin: const EdgeInsets.only(right: 4.0),
                                      //     tagCancelIcon: Icon(Icons.cancel,
                                      //         size: 20.0, color: Colors.black),
                                      //     tagCancelIconPadding:
                                      //         EdgeInsets.only(left: 4.0, top: 2.0),
                                      //     tagPadding: EdgeInsets.only(
                                      //         top: 2.0,
                                      //         bottom: 4.0,
                                      //         left: 8.0,
                                      //         right: 4.0),
                                      //     tagDecoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       border: Border.all(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //       borderRadius: const BorderRadius.all(
                                      //         Radius.circular(20.0),
                                      //       ),
                                      //     ),
                                      //     tagTextStyle: TextStyle(
                                      //         fontWeight: FontWeight.normal,
                                      //         color: Constants.bgColor,
                                      //         fontFamily: "Montserrat"),
                                      //   ),
                                      //   textFieldStyler: TextFieldStyler(
                                      //     helperText: '',
                                      //     hintText:
                                      //         "Please mention your hobbies example #hobbies1 #hobbies2...",
                                      //     hintStyle: TextStyle(
                                      //         fontFamily: "Montserrat",
                                      //         fontSize: 10.0.sp),
                                      //     isDense: false,
                                      //     textFieldFocusedBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //     textFieldBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //     textFieldEnabledBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //     textFieldDisabledBorder: OutlineInputBorder(
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       borderSide: BorderSide(
                                      //         color: Constants.formBorder,
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   onDelete: (tag) {
                                      //     print('onDelete: $tag');
                                      //   },
                                      //   onTag: (tag) {
                                      //     print('onTag: $tag');
                                      //   },
                                      //   // validator: (String tag) {
                                      //   //   print('validator: $tag');
                                      //   //   if (tag.length > 10) {
                                      //   //     return "hey that is too much";
                                      //   //   }
                                      //   //   return null;
                                      //   // },
                                      // )
                                    ),
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
                                           suffixIconConstraints: BoxConstraints(
                                      maxHeight: 30.0,
                                      maxWidth: 30.0,                                   
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 2.0.w),
                                      child: Image.asset('assets/icons/link.png', color: Constants.formBorder,),
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
                                           suffixIconConstraints: BoxConstraints(
                                      maxHeight: 30.0,
                                      maxWidth: 30.0,                                   
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 2.0.w),
                                      child: Image.asset('assets/icons/link.png', color: Constants.formBorder,),
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
                                           suffixIconConstraints: BoxConstraints(
                                      maxHeight: 30.0,
                                      maxWidth: 30.0,                                   
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 2.0.w),
                                      child: Image.asset('assets/icons/link.png', color: Constants.formBorder,),
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
                                           suffixIconConstraints: BoxConstraints(
                                      maxHeight: 30.0,
                                      maxWidth: 30.0,                                   
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(right: 2.0.w),
                                      child: Image.asset('assets/icons/link.png', color: Constants.formBorder,),
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
                                    print(imagePath);
                                    print(documentPath);
                                    print('Submit!!!');
                                    bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9."
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
                                          msg:
                                              "Please Enter Valid Mobile Number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (_emailController.text
                                            .trim()
                                            .isEmpty ||
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
                                    } else if (_idNumController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter Valid ID Number",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (totalWorkExp == null) {
                                      Fluttertoast.showToast(
                                          msg: "Please Select Work Experience",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else if (fileName == null  && result.data.imageUrl.split("/").last == 'default.jpg'//|| fileName == ''
                                    ) {
                                      Fluttertoast.showToast(
                                          msg: "Please Pick Selected Document",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    } else {
                                      _image != null
                                    //&& _document == null
                                    ? updateProfileWithImage(
                                    //userId,
                                    registerAs,
                                    _nameController.text,
                                    _mobileController.text,
                                    _emailController.text,
                                    gender,
                                    birthDateInString,
                                    docType,
                                    //_document != null ? _document : result.data.documentUrl,
                                    //_document.uri.path,
                                    //_image != null ? _image : result.data.imageUrl,
                                    //_image.uri.path,
                                    //certiFile,
                                    _idNumController.text,
                                    address1,
                                    address2,
                                    city,
                                    country,
                                    pinCode,
                                    lat,
                                    lng,
                                    _achivementController.text,
                                    // selectedSkillList == [] ? result.data.skills : selectedSkillList.toString(),
                                    // selectedHobbiesList == [] ? result.data.hobbies : selectedHobbiesList.toString(),
                                    selectedSkillList.length == 0 ? result.data.skills : selectedSkillList.toString().replaceAll('[', '').replaceAll(']', '')
                                            .replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                    selectedHobbiesList.length == 0 ? result.data.hobbies : selectedHobbiesList.toString().replaceAll('[', '').replaceAll(']', '')
                                           .replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                    _fbLinkController.text,
                                    _instagramLinkController.text,
                                    _linkedInLinkLinkController.text,
                                    _otherLinkLinkController.text,
                                    totalWorkExp,
                                    totalWorkExp)
                                    : updateProfile(
                                    //userId,
                                    registerAs,
                                    _nameController.text,
                                    _mobileController.text,
                                    _emailController.text,
                                    gender,
                                    birthDateInString,
                                    docType,
                                    //_document != null ? _document : result.data.documentUrl,
                                    //_document.uri.path,
                                    //_image != null ? _image : result.data.imageUrl,
                                    //_image.uri.path,
                                    //certiFile,
                                    _idNumController.text,
                                    address1,
                                    address2,
                                    city,
                                    country,
                                    pinCode,
                                    lat,
                                    lng,
                                    _achivementController.text,
                                    selectedSkillList.length == 0 ? result.data.skills : selectedSkillList.toString().replaceAll('[', '').replaceAll(']', '')
                                            .replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                    selectedHobbiesList.length == 0 ? result.data.hobbies : selectedHobbiesList.toString().replaceAll('[', '').replaceAll(']', '')
                                           .replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                    _fbLinkController.text,
                                    _instagramLinkController.text,
                                    _linkedInLinkLinkController.text,
                                    _otherLinkLinkController.text,
                                    totalWorkExp,
                                    totalWorkExp);
                                    print('SKILL1 '+ result.data.skills);
                                    print('SKILL2 '+ selectedSkillList.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'));
                                    print('SKILL3 '+ selectedSkillList.toString());
                                      // editLearnerProfileApi(
                                      //     registerAs,
                                      //     _nameController.text,
                                      //     _mobileController.text,
                                      //     _emailController.text,
                                      //     gender == 'Gender' ? result.data.gender : gender ,
                                      //     birthDateInString,
                                      //     docType == 'DocType' ? result.data.documentType : docType,
                                      //     _document,
                                      //     _image,
                                      //     _idNumController.text,
                                      //     address1 == null ? result.data.location[0].addressLine1 : address1,
                                      //     address2 == null ? result.data.location[0].addressLine2 : address2,
                                      //     city == null ? result.data.location[0].city : city,
                                      //     country == null ? result.data.location[0].country : country,
                                      //     pinCode == null ? result.data.location[0].pincode : pinCode,
                                      //     lat == null ? result.data.location[0].latitude : lat,
                                      //     lng == null ? result.data.location[0].longitude : lng,
                                      //     _achivementController.text,
                                      //     selectedSkillList.isEmpty ? result.data.skills.toString() : selectedSkillList.toString(),
                                      //     selectedHobbiesList.isEmpty ? result.data.hobbies.toString() : selectedHobbiesList.toString(),
                                      //     _fbLinkController.text,
                                      //     _instagramLinkController.text,
                                      //     _linkedInLinkLinkController.text,
                                      //     _otherLinkLinkController.text,
                                      //     totalWorkExp);
                                      // Navigator.of(context).push
                                      //     //pushAndRemoveUntil
                                      //     (MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             bottomNavBar(0)));
                                      //(Route<dynamic> route) => false);
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
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
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

  //Tag for Skills
  void _openFilterSkillsDialog() async {
    await FilterListDialog.display(context,
        listData: skillMapData,
        selectedListData: selectedSkillList,
        height: 480,
        headlineText: "Select or Search Skill",
        searchFieldHintText: "Search Skill Here",
        searchFieldTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 10.0.sp,
            color: Constants.bgColor),
        headerTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 12.0.sp,
            color: Constants.bgColor),
        label: (item) {
          return item;
        },
        validateSelectedItem: (list, val) {
          return list.contains(val);
        },
        applyButonTextBackgroundColor: Constants.bgColor,
        applyButtonTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 12.0.sp,
            color: Colors.white),
        selectedChipTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 10.0.sp,
            color: Colors.white),
        controlButtonTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 11.0.sp,
            color: Constants.bgColor),
        unselectedChipTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 10.0.sp,
            color: Constants.bgColor),
        //useSafeArea: true,
        onItemSearch: (list, text) {
          if (list.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                    element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        },
        onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedSkillList = List.from(list);
            });
          }
          Navigator.pop(context);
        });
  }

  //Tag for Hobbies
  void _openFilterHobbiesDialog() async {
    await FilterListDialog.display(context,
        listData: hobbieMapData,
        selectedListData: selectedHobbiesList,
        height: 480,
        headlineText: "Select or Search Hobbie",
        searchFieldHintText: "Search Hobbie Here",
        searchFieldTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 10.0.sp,
            color: Constants.bgColor),
        headerTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 12.0.sp,
            color: Constants.bgColor),
        label: (item) {
          return item;
        },
        validateSelectedItem: (list, val) {
          return list.contains(val);
        },
        applyButonTextBackgroundColor: Constants.bgColor,
        applyButtonTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 12.0.sp,
            color: Colors.white),
        selectedChipTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 10.0.sp,
            color: Colors.white),
        controlButtonTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 11.0.sp,
            color: Constants.bgColor),
        unselectedChipTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 10.0.sp,
            color: Constants.bgColor),
        //useSafeArea: true,
        onItemSearch: (list, text) {
          if (list.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                    element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        },
        onApplyButtonClick: (list) {
          if (list != null) {
            setState(() {
              selectedHobbiesList = List.from(list);
            });
          }
          Navigator.pop(context);
        });
  }

  //Location Picker
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              Config.locationKey,
              // displayLocation: customLocation,
            )));

    setState(() {
      address1 = result.formattedAddress;
      address2 = result.subLocalityLevel1.name;
      city = result.locality;
      country = result.country.name;
      lat = result.latLng.latitude;
      lng = result.latLng.longitude;
      pinCode = result.postalCode;
    });

    print('CITY::: $city');
    print('LATLNG::: ${result.latLng}');
    print('Country::: $pinCode');
    print('ADDRESS::: $address1');
  }

 Future<void> saveImage() async {
    final response = await http.get(result.data.imageUrl);
    final response1 = await http.get(result.data.documentUrl);

    // Get the image name 
    final imageName = path.basename(result.data.imageUrl);
    final documentName = path.basename(result.data.documentUrl);
    // Get the document directory path 
    final appDir = await pathProvider.getApplicationDocumentsDirectory();

    // This is the saved image path 
    // You can use it to display the saved image later. 
    final localPath = path.join(appDir.path, imageName);
    final localPath1 = path.join(appDir.path, documentName);

    setState(() {
      imagePath = localPath;
      documentPath = localPath1;
       _image = File(imagePath);
      _document = File(documentPath);
    });
    print(imagePath);
    print(documentPath);
    // Downloading
    final imageFile = File(localPath);
    final documentFile = File(localPath1);
    await imageFile.writeAsBytes(response.bodyBytes);
    await documentFile.writeAsBytes(response1.bodyBytes);
    print('Image Downloaded!');
    print('Document Downloaded!');
}

//Get Category, Skills, and Hobbies List
  getCatSkillHobbieList() async {
    //displayProgressDialog(context);
    //var result = CategoryList();
    try {
      Dio dio = Dio();
      var response = await Future.wait([
        dio.get(Config.profileDetailsUrl,
            options: Options(headers: {
              "Authorization": 'Bearer $authToken',
            })),
        dio.get(Config.categoryListUrl,
            options: Options(headers: {
              "Authorization": 'Bearer $authToken',
            })),
        dio.get(Config.skillListUrl),
        dio.get(Config.hobbieListUrl)
      ]);

      if (response[0].statusCode == 200 &&
          response[1].statusCode == 200 &&
          response[2].statusCode == 200 &&
          response[3].statusCode == 200) {
        //closeProgressDialog(context);
        result = LearnerProfileDetails.fromJson(response[0].data);
        categoryMap = response[1].data;
        skillMap = response[2].data;
        hobbieMap = response[3].data;
        //saveImage();

          print('SKILLDATA::: ${result.data.skills}');
        print(response[0].data);
        eduMap = response[0].data;
        eduMapData = eduMap['data']['educational_details'];
        print('EDU:::' + eduMapData.toString());
         populateEducationDetails();
        
          categoryMapData = categoryMap['data'];
          skillMapData = skillMap['data'];
          hobbieMapData = hobbieMap['data'];
          // _image = File(imagePath);
          // _document = File(documentPath);
          // _nameController.text = result.data.name;
          // _mobileController.text = result.data.mobileNumber;
          // _emailController.text =
          //     //result.data.email == null ? '' :
          //     result.data.email;
          // gender = result.data.gender;
          // birthDateInString = result.data.dob;
          // docType = result.data.documentType;
          // totalWorkExp = int.parse(result.data.totalWorkExperience);
          // _idNumController.text =
          //     //result.data.identificationDocumentNumber == null ? '' :
          //     result.data.identificationDocumentNumber;
          // _achivementController.text = result.data.achievements;
          // _fbLinkController.text = result.data.facebookUrl;
          // _instagramLinkController.text = result.data.instaUrl;
          // _linkedInLinkLinkController.text = result.data.linkedinUrl;
          // _otherLinkLinkController.text = result.data.otherUrl;
        setState(() {});

        if(result.data.identificationDocumentNumber != null){
         
            _nameController.text = result.data.name;
          _mobileController.text = result.data.mobileNumber;
          _emailController.text =
              //result.data.email == null ? '' :
              result.data.email;
          gender = result.data.gender;
          birthDateInString = result.data.dob;
          docType = result.data.documentType;
          totalWorkExp = int.parse(result.data.totalWorkExperience);
          _idNumController.text =
              //result.data.identificationDocumentNumber == null ? '' :
              result.data.identificationDocumentNumber;
          _achivementController.text = result.data.achievements;
          _fbLinkController.text = result.data.facebookUrl;
          _instagramLinkController.text = result.data.instaUrl;
          _linkedInLinkLinkController.text = result.data.linkedinUrl;
          _otherLinkLinkController.text = result.data.otherUrl;
         setState(() {});
        }else{
          
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LearnerRegistration(
            name: result.data.name,
            mobileNumber: result.data.mobileNumber,
          )));
        }

        if (result != null) {
          isLoading = false;
        }

        for (int i = 0; i < categoryMapData.length; i++) {
          intrestedCat.add(categoryMapData[i]['selected']);
          if(intrestedCat[i] == true){
            intrestedCatKey.add(categoryMapData[i]['key']);
          } 
          //else{
          //   intrestedCatKey.removeAt(i);
          // }
        }
        print(result.data.documentUrl);
        debugPrint(result.data.skills);
        debugPrint(result.data.hobbies);
        print(intrestedCat);
        print(intrestedCatKey);
        print(categoryMap);
        print(skillMap);
        print(hobbieMap);
        //closeProgressDialog(context);
      } else {
        //closeProgressDialog(context);
        if (categoryMap['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: categoryMap['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else if (skillMap['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: skillMap['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else if (hobbieMap['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: hobbieMap['error_msg'],
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
      //closeProgressDialog(context);
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
    //return result;
  }


// //Add profile for Learner
//   Future<LearnerProfileUpdate> addLearnerProfileApi(
//     //int userId,
//     String registerAs,
//     //String imageFile,
//     //String imageUrl,
//     String name,
//     String mobileNumber,
//     String email,
//     String gender,
//     String dob,
//     String documentType,
//     File documentFile,
//     File imageFile,
//     //File certificateFile,
//     //String documentUrl,
//     String idNumber,
//     String addressLine1,
//     String addressLine2,
//     String city,
//     String country,
//     String pinCode,
//     double latitude,
//     double longitude,
//     String achievements,
//     String skills,
//     String hobbies,
//     String facbookUrl,
//     String instaUrl,
//     String linkedinUrl,
//     String otherUrl,
//     //List<EducationalDetails> educationalDetails,
//     int totalWorkExp,
//     //int totalTeachExp,
//     //List<InterestedCategory> interestedCategory,
//   ) async {
//     displayProgressDialog(context);
//     String docname = documentFile.path.split('/').last;
//     String imgname = imageFile.path.split('/').last;
//     //String certiname = certificateFile.path.split('/').last;
//     //SharedPreferences preferences = await SharedPreferences.getInstance();
//     var updateResult = LearnerProfileUpdate();

//     try {
//       Dio dio = Dio();
//       FormData formData = FormData.fromMap({
//         //'user_id': userId,
//         'register_as': registerAs,
//         'name': name,
//         'mobile_number': mobileNumber,
//         'email': email,
//         'gender': gender,
//         'dob': dob,
//         'document_type': documentType,
//         'document_file': await MultipartFile.fromFile(
//           //documentPath,
//           documentFile.path,
//           filename: docname,
//         ),
//         'image_file': await MultipartFile.fromFile(
//           imageFile.path,
//           //imagePath,
//           filename: imgname,
//         ),
//         //'document_url': documentUrl,
//         'identification_document_number': idNumber,
//         //'location[0][id]': result.data.location[0].id,
//         'location[0][address_line_1]': addressLine1,
//         'location[0][address_line_2]': addressLine2,
//         'location[0][city]': city,
//         'location[0][country]': country,
//         'location[0][pincode]': pinCode,
//         'location[0][latitude]': latitude,
//         'location[0][longitude]': longitude,
//         'location[0][location_type]': 'work',
//         'achievements': achievements,
//         'skills': skills,
//         'hobbies': hobbies,
//         'educational_details[]': '[]',
//         //'interested_category[]': intrestedCatKey.toString(),
//         //'educational_details[0][id]': 25,
//         // 'educational_details[0][school_name]': myControllers[0].text.toString(),
//         // 'educational_details[0][year]': selectedYear.year,
//         // 'educational_details[0][qualification]': qualification.toString(),
//         // 'educational_details[0][certificate_file]':
//         //     await MultipartFile.fromFile(
//         //   certificateFile.path,
//         //   filename: certiname,
//         //   //contentType: new MediaType("jpg", "jpeg", "png", "pdf"),
//         // ),
//         'facebook_url': facbookUrl,
//         'insta_url': instaUrl,
//         'linkedin_url': linkedinUrl,
//         'other_url': otherUrl,
//         'total_work_experience': totalWorkExp,
//         //'total_teaching_experience': totalTeachExp,
//       });

//       // for(int i = 0; i < result.data.interestedCategory.length; i++){
//       //   formData.fields.add(
//       //     MapEntry('interested_category[$i]', result.data.interestedCategory[i].key.toString()),
//       //   );
//       // }

//       // print('MAP:::' + educationDetailMap[0]['school_name']);
//       // print('MAP:::' + educationDetailMap[1]['school_name']);
//       // print('MAP:::' + educationDetailMap[2]['school_name']);
//       // print('MAP:::' + educationDetailMap[3]['school_name']);

//       //print(formData.fields);

//       var response = await dio.post(
//         Config.updateProfileUrl,
//         data: formData,
//         options: Options(headers: {"Authorization": 'Bearer ' + authToken}),
//         // onSendProgress: (int sent, int total){
//         //   print('SENT $sent + TOTAL $total');
//         // }
//       );
//       if (response.statusCode == 200) {
//         print(response.data);
//         closeProgressDialog(context);
//         updateResult = LearnerProfileUpdate.fromJson(response.data);
//         print(updateResult.data.name);
//         if (updateResult.status == true) {
//           print('TRUE::');
//           // preferences.setString("name", result.data.name);
//           // preferences.setString("imageUrl", result.data.imageUrl);
//           // preferences.setString("mobileNumber", result.data.mobileNumber);
//           // preferences.setString("gender", result.data.gender);
//           // preferences.setString(
//           //     "qualification", result.data.educationalDetails.toString());
//           // preferences.setString(
//           //     "schoolName", result.data.educationalDetails.toString());
//           // preferences.setString("address1", result.data.location.toString());
//           // preferences.setString("address2", result.data.location.toString());
//           // preferences.setString("facebookUrl", result.data.facebookUrl);
//           // preferences.setString("instaUrl", result.data.instaUrl);
//           // preferences.setString("linkedInUrl", result.data.linkedinUrl);
//           // preferences.setString("otherUrl", result.data.otherUrl);
//           // print('QUALIFICATION:::: ' +
//           //     result.data.educationalDetails.last.qualification);
//           // print('LOCATION:::: ' + result.data.location[0].addressLine2);
//           // print('IMAGE:::: ' + result.data.imageUrl);
//           // Navigator.of(context).pushAndRemoveUntil(
//           //     MaterialPageRoute(builder: (context) => bottomNavBar(0)),
//           //     (Route<dynamic> route) => false);
//         } else {
//           print('FALSE::');
//         }
//         // saveUserData(result.data.userId);

//         Fluttertoast.showToast(
//           msg: updateResult.message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Constants.bgColor,
//           textColor: Colors.white,
//           fontSize: 10.0.sp,
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: updateResult.message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Constants.bgColor,
//           textColor: Colors.white,
//           fontSize: 10.0.sp,
//         );
//       }
//       print(result);
//     } on DioError catch (e, stack) {
//       print(e.response);
//       print(stack);
//       //closeProgressDialog(context);
//       if (e.response != null) {
//         print("This is the error message::::" +
//             e.response.data['meta']['message']);
//         Fluttertoast.showToast(
//           msg: e.response.data['meta']['message'],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Constants.bgColor,
//           textColor: Colors.white,
//           fontSize: 10.0.sp,
//         );
//       } else {
//         // Something happened in setting up or sending the request that triggered an Error
//         print(e.request);
//         print(e.message);
//       }
//     }
//     return updateResult;
//   }

//   //Update profile for Learner
//   Future<LearnerProfileUpdate> editLearnerProfileApi(
//     //int userId,
//     String registerAs,
//     //String imageFile,
//     //String imageUrl,
//     String name,
//     String mobileNumber,
//     String email,
//     String gender,
//     String dob,
//     String documentType,
//     File documentFile,
//     File imageFile,
//     //File certificateFile,
//     //String documentUrl,
//     String idNumber,
//     String addressLine1,
//     String addressLine2,
//     String city,
//     String country,
//     String pinCode,
//     String latitude,
//     String longitude,
//     String achievements,
//     String skills,
//     String hobbies,
//     String facbookUrl,
//     String instaUrl,
//     String linkedinUrl,
//     String otherUrl,
//     //List<EducationalDetails> educationalDetails,
//     int totalWorkExp,
//     //int totalTeachExp,
//     //List<InterestedCategory> interestedCategory,
//   ) async {
//     //displayProgressDialog(context);
//     //String docname = documentFile.path.split('/').last;
//     //String imgname = imageFile.path.split('/').last;
//     //String certiname = certificateFile.path.split('/').last;
//     //SharedPreferences preferences = await SharedPreferences.getInstance();
//     var updateResult = LearnerProfileUpdate();

//     try {
//       Dio dio = Dio();
//       FormData formData = FormData.fromMap({
//         //'user_id': userId,
//         'register_as': registerAs,
//         'name': name,
//         'mobile_number': mobileNumber,
//         'email': email,
//         'gender': gender,
//         'dob': dob,
//         'document_type': documentType,
//         'document_file': await MultipartFile.fromFile(
//           _document.path,
//           //documentPath.toString(),
//           filename: //docname,
//           _document.path.split("/").last,
//         ),
//         'image_file': await MultipartFile.fromFile(
//           _image.path,
//           //imagePath.toString(),
//           filename: //imgname,
//           _image.path.split("/").last,
//         ),
//         //'document_url': documentUrl,
//         'identification_document_number': idNumber,
//         'location[0][id]': result.data.location.isEmpty  ? null : result.data.location[0].id,
//         'location[0][address_line_1]': addressLine1,
//         'location[0][address_line_2]': addressLine2,
//         'location[0][city]': city,
//         'location[0][country]': country,
//         'location[0][pincode]': pinCode,
//         'location[0][latitude]': latitude,
//         'location[0][longitude]': longitude,
//         'location[0][location_type]': 'work',
//         'achievements': achievements,
//         'skills': skills,
//         'hobbies': hobbies,
//         'educational_details[]': '[]',
//         'facebook_url': facbookUrl,
//         'insta_url': instaUrl,
//         'linkedin_url': linkedinUrl,
//         'other_url': otherUrl,
//         'total_work_experience': totalWorkExp,
//         //'total_teaching_experience': totalTeachExp,
//       });

//       for (int i = 0; i < intrestedCatKey.length; i++) {
//         //formData.fields.addAll(params.entries);
//         //print('MAP:::' + educationDetailMap.length.toString());
//         formData.fields.addAll([
//           MapEntry('interested_category[$i]', intrestedCatKey.contains(i) ? '0' : '1'
//               //intrestedCatKey[i].toString()
//               ),
//         ]);
//       }

//       //print(formData.fields);

//       var response = await dio.post(
//         Config.updateProfileUrl,
//         data: formData,
//         options: Options(headers: {"Authorization": 'Bearer ' + authToken}),
//         // onSendProgress: (int sent, int total){
//         //   print('SENT $sent + TOTAL $total');
//         // }
//       );
//       if (response.statusCode == 200) {
//         print(response.data);
//         //closeProgressDialog(context);
//         updateResult = LearnerProfileUpdate.fromJson(response.data);
//         print(updateResult.data.name);
//         if (updateResult.status == true) {
//           print('TRUE::');
//           print(gender);
//           print(result.data.gender);
//           // preferences.setString("name", result.data.name);
//           // preferences.setString("imageUrl", result.data.imageUrl);
//           // preferences.setString("mobileNumber", result.data.mobileNumber);
//           // preferences.setString("gender", result.data.gender);
//           // preferences.setString(
//           //     "qualification", result.data.educationalDetails.toString());
//           // preferences.setString(
//           //     "schoolName", result.data.educationalDetails.toString());
//           // preferences.setString("address1", result.data.location.toString());
//           // preferences.setString("address2", result.data.location.toString());
//           // preferences.setString("facebookUrl", result.data.facebookUrl);
//           // preferences.setString("instaUrl", result.data.instaUrl);
//           // preferences.setString("linkedInUrl", result.data.linkedinUrl);
//           // preferences.setString("otherUrl", result.data.otherUrl);
//           // print('QUALIFICATION:::: ' +
//           //     result.data.educationalDetails.last.qualification);
//           // print('LOCATION:::: ' + result.data.location[0].addressLine2);
//           // print('IMAGE:::: ' + result.data.imageUrl);
//           // Navigator.of(context).pushAndRemoveUntil(
//           //     MaterialPageRoute(builder: (context) => bottomNavBar(0)),
//           //     (Route<dynamic> route) => false);
//         } else {
//           print('FALSE::');
//         }
//         // saveUserData(result.data.userId);

//         Fluttertoast.showToast(
//           msg: updateResult.message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Constants.bgColor,
//           textColor: Colors.white,
//           fontSize: 10.0.sp,
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: updateResult.message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Constants.bgColor,
//           textColor: Colors.white,
//           fontSize: 10.0.sp,
//         );
//       }
//       print(result);
//     } on DioError catch (e, stack) {
//       print(e.response);
//       print(stack);
//       //closeProgressDialog(context);
//       if (e.response != null) {
//         print("This is the error message::::" +
//             e.response.data['meta']['message']);
//         Fluttertoast.showToast(
//           msg: e.response.data['meta']['message'],
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Constants.bgColor,
//           textColor: Colors.white,
//           fontSize: 10.0.sp,
//         );
//       } else {
//         // Something happened in setting up or sending the request that triggered an Error
//         print(e.request);
//         print(e.message);
//       }
//     }
//     return updateResult;
//   }

   //Update Profile API
  Future<ProfileUpdate> updateProfile(
    //int userId,
    String registerAs,
    //String imageFile,
    //String imageUrl,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String dob,
    String documentType,
    //File documentFile,
    //String documentUrl,
    //File imageFile,
    //String imageUrl,
    String idNumber,
    String addressLine1,
    String addressLine2,
    String city,
    String country,
    String pinCode,
    double latitude,
    double longitude,
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
    // String docname = documentFile.path.split('/').last;
    // String imgname = imageFile.path.split('/').last;
    //String certiname = certificateFile.path.split('/').last;

    var update = ProfileUpdate();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();
      
      FormData formData = FormData.fromMap({
        //'user_id': userId,
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_url': result.data.documentUrl,
        // 'document_file': _document != null ? await MultipartFile.fromFile(
        //   _document.path, //documentFile.path,
        //   filename: _document.path.split("/").last,
        // )
        // : result.data.documentUrl,
        //'document_url': documentUrl,
      //   'image_file':  _image != null
      //   ? await MultipartFile.fromFile(
      //     _image.path,//imageFile.path,
      //     filename: _image.path.split("/").last,
      //   )
      //  : null,
        //result.data.imageUrl,
        'image_url': result.data.imageUrl,
        'identification_document_number': idNumber,
        //?TODO: Used dynamic ID at location[0][id]
        'location[0][id]': result.data.location[0].id,
        'location[0][address_line_1]': addressLine1 == null ? result.data.location[0].addressLine1 : addressLine1,
        'location[0][address_line_2]': addressLine2 == null ? result.data.location[0].addressLine2 : addressLine2,
        'location[0][city]': city == null ? result.data.location[0].city : city,
        'location[0][country]': country == null ? result.data.location[0].country : country,
        'location[0][pincode]': pinCode == null ? result.data.location[0].pincode : pinCode,
        'location[0][latitude]': latitude == null ? result.data.location[0].latitude : latitude,
        'location[0][longitude]': longitude == null ?  result.data.location[0].longitude : longitude,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills,
        'hobbies': hobbies,
        'facebook_url': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
        'total_teaching_experience': totalTeachExp,
      });

      print('MAPO:::' + eduMap.length.toString());
      print('Called:::No');
      print('RESULT:::'+result.data.educationalDetails.toString());

      for (int i = 0; i < result.data.educationalDetails.length; i++) {
        //formData.fields.addAll(params.entries);
        if(result.data.educationalDetails1[i]['id'] != null){
        formData.fields.addAll([
          //?TODO: Used dynamic ID at educational_details[0][id]
          MapEntry('educational_details[$i][id]', result.data.educationalDetails1[i]['id'].toString()),
          MapEntry('educational_details[$i][school_name]',
              controllersList[i].text),
          MapEntry('educational_details[$i][year]',
              result.data.educationalDetails1[i]['year'].toString()),
          MapEntry('educational_details[$i][qualification]',
              result.data.educationalDetails1[i]['qualification']),
          MapEntry('educational_details[$i][certificate_file]', ''),
          
        ]);
        // fileImage[i] != null
        // ? formData.files.addAll([
        //   MapEntry(
        //       'educational_details[$i][certificate_file]', 
        //       //MultipartFile.fromString(result.data.educationalDetails[i].certificateFile)
        //       await MultipartFile.fromFile(fileImage[i].path,
        //           filename: fileImage[i].toString().split('/').last)
        //          ),
        // ])
        // : MapEntry('educational_details[$i][certificate_file]', fileImage[i]);
        } 
        else{
          formData.fields.addAll([
           MapEntry('educational_details[$i][id]', result.data.educationalDetails1[i]['id'].toString()),
          MapEntry('educational_details[$i][school_name]',
              controllersList[i].text),
          MapEntry('educational_details[$i][year]',
              result.data.educationalDetails1[i]['year'].toString()),
          MapEntry('educational_details[$i][qualification]',
              result.data.educationalDetails1[i]['qualification']),
          MapEntry('educational_details[$i][certificate_file]', ''),
        ]);
        //  formData.files.addAll([
        //   MapEntry(
        //       'educational_details[$i][certificate_file]', 
        //       //MultipartFile.fromString(result.data.educationalDetails[i].certificateFile)
        //       await MultipartFile.fromFile(fileImage[i].path,
        //           filename: fileImage[i].toString().split('/').last)
        //          ),
        // ]);
        }
      }

      for(int i = 0; i < intrestedCatKey.length; i++){
        formData.fields.addAll([
          MapEntry('interested_category[$i]', intrestedCatKey[i].toString())
        ]);
        print('ICAT:::' + intrestedCatKey[i].toString());
      }

      debugPrint('REQ:::'+formData.files.toString());
print('MAP:::' + formData.fields.toString());
      //print('MAP:::' + result.data.educationalDetails1[1].toString());
      //print(fileImage);
      //print(educationList);

      print('FORMDATA::: ${result.data.skills}');
      print('FORMDATA::: ${selectedSkillList.toString().replaceAll('[', '').replaceAll(']', '')}');

      var response = await dio.post(
        Config.updateProfileUrl,
        data: formData,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken}),
        // onSendProgress: (int sent, int total){
        //   print('SENT $sent + TOTAL $total');
        // }
      );
      if (response.statusCode == 200) {
        print(response.data);
        closeProgressDialog(context);
        update = ProfileUpdate.fromJson(response.data);
    
        print(update.data.name);
        //if(result.status == true){
        // print('ID ::: ' + result.data.userId.toString());
        // saveUserData(result.data.userId);

        if (update.status == true) {
          print('TRUE::');

          setState(() {
            preferences.setString("name", update.data.name);
            preferences.setString("mobileNumber", update.data.mobileNumber);
          });

          Fluttertoast.showToast(
            msg: update.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          // Close current screen after profile update
          //Navigator.of(context).pop();
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return bottomNavBar(4);
              },
             ),
             (_) => false,
            );
        } else {
          print('FALSE::');
          Fluttertoast.showToast(
            msg: update.message,
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
          msg: update.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
      print(update);
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::"  +
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
    return update;
  }

  Future<ProfileUpdate> updateProfileWithImage(
    //int userId,
    String registerAs,
    //String imageFile,
    //String imageUrl,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String dob,
    String documentType,
    //File documentFile,
    //String documentUrl,
    //File imageFile,
    //String imageUrl,
    String idNumber,
    String addressLine1,
    String addressLine2,
    String city,
    String country,
    String pinCode,
    double latitude,
    double longitude,
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
    print('PROFILE::: IMAGE');
    displayProgressDialog(context);
    // String docname = documentFile.path.split('/').last;
    // String imgname = imageFile.path.split('/').last;
    //String certiname = certificateFile.path.split('/').last;

    var update = ProfileUpdate();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();
      
     FormData formDataI = FormData.fromMap({
        //'user_id': userId,
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_url': result.data.documentUrl,
        // 'document_file': await MultipartFile.fromFile(
        //   _document.path, //documentFile.path,
        //   filename: _document.path.split("/").last,
        // ),
        // : result.data.documentUrl,
        //'document_url': documentUrl,
        'image_file':
        await MultipartFile.fromFile(
          _image.path,//imageFile.path,
          filename: _image.path.split("/").last,
        ),
        // : 
        //result.data.imageUrl,
        //'image_url': null,
        'identification_document_number': idNumber,
        //?TODO: Used dynamic ID at location[0][id]
        'location[0][id]': result.data.location[0].id,
        'location[0][address_line_1]': addressLine1 == null ? result.data.location[0].addressLine1 : addressLine1,
        'location[0][address_line_2]': addressLine2 == null ? result.data.location[0].addressLine2 : addressLine2,
        'location[0][city]': city == null ? result.data.location[0].city : city,
        'location[0][country]': country == null ? result.data.location[0].country : country,
        'location[0][pincode]': pinCode == null ? result.data.location[0].pincode : pinCode,
        'location[0][latitude]': latitude == null ? result.data.location[0].latitude : latitude,
        'location[0][longitude]': longitude == null ?  result.data.location[0].longitude : longitude,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills,
        'hobbies': hobbies,
        'facebook_url': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
        'total_teaching_experience': totalTeachExp,
      });


      //print('MAPO:::' + educationDetailMap.length.toString());
      print('Called:::Image');
      print('IDDD::'+result.data.educationalDetails[0].id.toString());

      for (int i = 0; i < result.data.educationalDetails.length; i++) {

        formDataI.fields.addAll([
          //?TODO: Used dynamic ID at educational_details[0][id]
          MapEntry('educational_details[$i][id]', result.data.educationalDetails[i].id.toString()),
          MapEntry('educational_details[$i][school_name]',
              result.data.educationalDetails[i].schoolName.toString()),
          MapEntry('educational_details[$i][year]',
              result.data.educationalDetails[i].year.toString()),
          MapEntry('educational_details[$i][qualification]',
              result.data.educationalDetails[i].qualification.toString()),
          MapEntry('educational_details[$i][certificate_file]', ''),
        ]);
      }

      for(int i = 0; i < intrestedCatKey.length; i++){
        formDataI.fields.addAll([
          MapEntry('interested_category[$i]', intrestedCatKey[i].toString())
        ]);
        print('ICAT:::' + intrestedCatKey[i].toString());
      }

      //print('MAP:::' + educationDetailMap.toString());
      print('FORMDATA::: updateProfileWithImage()');
      //print(educationList);

      var response = await dio.post(
        Config.updateProfileUrl,
        data: 
         formDataI,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken}),
        // onSendProgress: (int sent, int total){
        //   print('SENT $sent + TOTAL $total');
        // }
      );
      if (response.statusCode == 200) {
        print(response.data);
        closeProgressDialog(context);
        update = ProfileUpdate.fromJson(response.data);
        print(update.data.name);
        //if(result.status == true){
        // print('ID ::: ' + result.data.userId.toString());
        // saveUserData(result.data.userId);

        if (update.status == true) {
          print('TRUE::');
          setState(() {
            preferences.setString("name", update.data.name);
            preferences.setString("imageUrl", update.data.imageUrl);
            preferences.setString("mobileNumber", update.data.mobileNumber);
          });
          Fluttertoast.showToast(
            msg: update.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
          // Close current screen after profile update
          //Navigator.of(context).pop();
           Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return bottomNavBar(4);
              },
             ),
             (_) => false,
            );
        } else {
          print('FALSE::');
          Fluttertoast.showToast(
            msg: update.message,
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
          msg: update.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
      print(update);
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        print("This is the error message::::"  +
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
    return update;
  }

//Update Profile API
  Future<ProfileUpdate> learnerUpdateProfile(String name, String mobileNumber,
      String registerAs, String deviceType, String deviceId) async {
    displayProgressDialog(context);
    var result = ProfileUpdate();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'name': name,
        'mobile_number': mobileNumber,
        'register_as': registerAs,
        'deviceType': deviceType,
        'deviceId': deviceId,
      });
      var response = await dio.post(Config.updateProfileUrl, data: formData);
      if (response.statusCode == 200) {
        print(response.data);
        closeProgressDialog(context);
        //result = SignUp.fromJson(response.data);
        //print(result.data.name);
        //if(result.status == true){
        // print('ID ::: ' + result.data.userId.toString());
        // saveUserData(result.data.userId);

        Fluttertoast.showToast(
          msg: 'result.message',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'result.message',
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

  displayProgressDialog(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) {

      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new ProgressDialog();
          }));
    //});
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
//}

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

// // class Hobbies extends Taggable {
// //   ///
// //   final String name;

// //   ///
// //   final int position;

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
