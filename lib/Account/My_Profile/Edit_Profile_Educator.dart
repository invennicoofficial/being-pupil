import 'dart:convert';
import 'dart:io';

import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/EducationListItemModel.dart';
import 'package:being_pupil/Model/Profile_Details_Model.dart';
import 'package:being_pupil/Model/UpdateProfile_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';

import 'package:image_picker/image_picker.dart';
import 'package:place_picker/entities/address_component.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

class EditEducatorProfile extends StatefulWidget {
  const EditEducatorProfile({Key? key}) : super(key: key);

  @override
  _EditEducatorProfileState createState() => _EditEducatorProfileState();
}

class _EditEducatorProfileState extends State<EditEducatorProfile> {
  XFile? _image, _certificate, _document;
  String? birthDateInString, selectedYearString;
  DateTime? birthDate, selectedYear;
  bool isDateSelected = false;
  bool isYearSelected = false;
  String? gender = 'Gender';
  String? docType = 'DocType';
  String qualification = '0';
  String workExp = '0';
  String teachExp = '0';
  String? fileName;
  String? _certiName;
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
  Map<int, dynamic> educationDetailMap = {};
  int educationId = 0;
  List controllersList = [];
  var certificate = [];
  List<File> certiList = [];
  String? registerAs;
  int? userId;
  String? authToken;
  List<String> education_details = [];
  List<String?> skillList = [];
  List<String?> hobbieList = [];
  List<String?> subjectList = [];
  int? totalWorkExp, totalTeachExp;
  Map<String, dynamic>? responseMap;
  String? address1, address2, city, country, pinCode;
  double? lat, lng;
  List<EducationListItemModel> educationList = [];

  List<String> selectedSkillList = [];
  List<String> selectedHobbiesList = [];
  List<String> selectedSubjectList = [];

  Map<String, dynamic>? skillMap = Map<String, dynamic>();
  List<dynamic>? skillMapData = [];

  Map<String, dynamic>? hobbieMap = Map<String, dynamic>();
  List<dynamic>? hobbieMapData = [];

  Map<String, dynamic>? profileMap;
  List<dynamic> profileMapData = [];

  Map<String, dynamic>? subjectMap = Map<String, dynamic>();
  List<dynamic>? subjectMapData = [];

  var result = EducatorProfileDetails();

  bool isLoading = true;
  String? imagePath, documentPath;

  List<int> educationListId = [];
  List<String> schoolNameList = [];
  List<String?> qualificationList = [];
  List<String> yearList = [];
  Map<int, dynamic>? certificateList;

  Map<String, dynamic>? eduMap;
  List<dynamic>? eduMapData;

  List<String?> netImage = [];
  List<XFile?> fileImage = [];
  final ImagePicker _picker = ImagePicker();
  int wordCount = 0;

  @override
  void initState() {
    itemCount = 1;

    getData();
    getToken();

    super.initState();
  }

  populateEducationDetails() {
    if (result.data!.educationalDetails1 != null) {
      for (int i = 0; i < result.data!.educationalDetails1!.length; i++) {
        controllersList.add(TextEditingController());
        controllersList[i].text = eduMapData![i]['school_name'];
        result.data!.educationalDetails1![i]['year'] = eduMapData![i]['year'];
        result.data!.educationalDetails1![i]['qualification'] =
            eduMapData![i]['qualification'];
      }
    } else {
      if (eduMapData != null) {
        for (int i = 0; i < eduMapData!.length; i++) {
          controllersList.add(TextEditingController());
          controllersList[i].text = eduMapData![i]['school_name'];
        }
      } else {
        eduMapData = [];
      }
    }
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    getCatSkillHobbieList();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
      userId = preferences.getInt('userId');
    });
  }

  wordCountForDescription(String str) {
    setState(() {
      wordCount = str.split(" ").length;
    });
  }

  _imageFromCamera() async {
    XFile? image =
        (await _picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _image = image;
      imagePath = _image!.path;
    });
  }

  _imageFromGallery() async {
    XFile? image = (await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _image = image;
      imagePath = _image!.path;
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
                                  ),
                                ),
                                hintText: "Search for your location",
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: Constants.bpSkipStyle,
                                )),
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        fileName = file.name;
        _document = XFile(file.path!);
        documentPath = _document!.path;
      });
    } else {}
  }

  _certificateFromCamera(int index) async {
    XFile? doc =
        (await _picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _certificate = doc;
      fileImage[index] = _certificate;

      _certiName = doc!.path.split('/scaled_').last.substring(35);
    });
  }

  _certificateFromGallery(int index) async {
    XFile? doc = (await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _certificate = doc;
      fileImage[index] = _certificate;
      _certiName = doc!.path.split('/scaled_image_picker').last;
    });
  }

  void _showCertificatePicker(context, int index) {
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
                        _certificateFromGallery(index);
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
                      _certificateFromCamera(index);
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
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constants.bgColor)),
              )
            : Padding(
                padding:
                    EdgeInsets.only(bottom: 3.0.h, left: 5.0.w, right: 5.0.w),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: 100.0.w,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.0.h),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
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
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              70),
                                                      child: Image.file(
                                                        File(_image!.path),
                                                        height: 125.0,
                                                        width: 125.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      height: 3.2.w * 2.5,
                                                      width: 3.2.w * 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Constants
                                                                  .formBorder),
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                      child: Center(
                                                        heightFactor:
                                                            5.0.w * 1.5,
                                                        widthFactor:
                                                            5.0.w * 1.5,
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 20,
                                                          color: Constants
                                                              .formBorder,
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
                                                    radius: 70.0,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              70),
                                                      child: CachedNetworkImage(
                                                        imageUrl: result
                                                            .data!.imageUrl!,
                                                        height: 125.0,
                                                        width: 125.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Container(
                                                      height: 3.2.w * 2.5,
                                                      width: 3.2.w * 2.5,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Constants
                                                                .formBorder,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                      child: Center(
                                                        heightFactor:
                                                            5.0.w * 1.5,
                                                        widthFactor:
                                                            5.0.w * 1.5,
                                                        child: Icon(
                                                          Icons.edit,
                                                          size: 20,
                                                          color: Constants
                                                              .formBorder,
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
                              TextInputWidget(
                                  textEditingController: _nameController,
                                  lable: 'Name',
                                  isReadOnly: true),
                              NumberInputWidget(
                                  textEditingController: _mobileController,
                                  lable: 'Mobile Number',
                                  isReadOnly: true),
                              TextInputWidget(
                                  textEditingController: _emailController,
                                  lable: 'Email',
                                  isReadOnly: true),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 3.0.w, right: 3.0.w, top: 3.0.h),
                                    child: Container(
                                      height: Constants.constHeight,
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
                                                result.data!.gender == 'M'
                                                    ? 'Male'
                                                    : result.data!.gender == 'F'
                                                        ? 'Female'
                                                        : 'Other',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 10.0.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Constants.bpSkipStyle),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onChange:
                                            (String value, int index) async {
                                          if (value != '1' ||
                                              value != '2' ||
                                              value != '3') {
                                            setState(() {
                                              gender = 'GenderSelected';
                                            });
                                          }
                                          if (value == '1') {
                                            gender = 'M';
                                          } else if (value == '2') {
                                            gender = 'F';
                                          } else {
                                            gender = 'O';
                                          }
                                        },
                                        dropdownButtonStyle:
                                            DropdownButtonStyle(
                                          height: Constants.constHeight,
                                          width: 90.0.w,
                                          elevation: 0,
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
                                        left: 3.0.w, right: 3.0.w, top: 3.0.h),
                                    child: GestureDetector(
                                      onTap: () async {
                                        int year = DateTime.now().year - 15;
                                        final datePick = await showDatePicker(
                                            context: context,
                                            initialDate: new DateTime(1960),
                                            firstDate: new DateTime(1900),
                                            lastDate: new DateTime(year),
                                            helpText: 'Select Birth Date');
                                        if (datePick != null &&
                                            datePick != birthDate) {
                                          setState(() {
                                            birthDate = datePick;
                                            isDateSelected = true;
                                            if (birthDate!.day
                                                        .toString()
                                                        .length ==
                                                    1 &&
                                                birthDate!.month
                                                        .toString()
                                                        .length ==
                                                    1) {
                                              setState(() {
                                                birthDateInString =
                                                    "0${birthDate!.day.toString()}/0${birthDate!.month}/${birthDate!.year}";
                                              });
                                            } else if (birthDate!.day
                                                    .toString()
                                                    .length ==
                                                1) {
                                              setState(() {
                                                birthDateInString =
                                                    "0${birthDate!.day}/${birthDate!.month}/${birthDate!.year}";
                                              });
                                            } else if (birthDate!.month
                                                    .toString()
                                                    .length ==
                                                1) {
                                              birthDateInString =
                                                  "${birthDate!.day}/0${birthDate!.month}/${birthDate!.year}";
                                            } else {
                                              birthDateInString =
                                                  "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}";
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: Constants.constHeight,
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
                                                  ? birthDateInString!
                                                  : result.data!.dob!,
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
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 3.0.w,
                                  right: 3.0.w,
                                  top: 3.0.h,
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
                                          result.data!.documentType == 'A'
                                              ? 'Aadhaar'
                                              : result.data!.documentType ==
                                                      'PN'
                                                  ? 'PAN'
                                                  : result.data!.documentType ==
                                                          'PAS'
                                                      ? 'Passport'
                                                      : result.data!
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
                                    ],
                                  ),
                                  onChange: (String value, int index) async {
                                    if (value != '1' ||
                                        value != '2' ||
                                        value != '3' ||
                                        value != '4' ||
                                        value != '5') {
                                      setState(() {
                                        docType = 'DocSelected';
                                      });
                                    }
                                    if (value == 1) {
                                      docType = 'A';
                                    } else if (value == 2) {
                                      docType = 'PN';
                                    } else if (value == 3) {
                                      docType = 'PAS';
                                    } else if (value == 4) {
                                      docType = 'VI';
                                    } else {
                                      docType = 'DL';
                                    }
                                  },
                                  dropdownButtonStyle: DropdownButtonStyle(
                                    height: Constants.constHeight,
                                    width: 90.0.w,
                                    elevation: 0,
                                    primaryColor: Constants.bpSkipStyle,
                                    side:
                                        BorderSide(color: Constants.formBorder),
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants
                                                          .bpSkipStyle),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
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
                                    child: Container(
                                      height: 6.0.h,
                                      width: 90.0.w,
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            width: 15.0.w,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: (_document == null
                                                            ? NetworkImage(
                                                                result.data!
                                                                    .documentUrl!)
                                                            : FileImage(File(
                                                                _document!
                                                                    .path)))
                                                        as ImageProvider<
                                                            Object>,
                                                    fit: BoxFit.fill)),
                                          ),
                                          SizedBox(width: 2.0.w),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                height: 3.0.h,
                                                child: Text(
                                                  result.data!.documentFile!
                                                      .split('/')
                                                      .last,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants
                                                          .bpSkipStyle),
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
                              TextInputWidget(
                                textEditingController: _idNumController,
                                lable: 'Identification Document Number',
                                isIdField: true,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 3.0.w,
                                    right: 3.0.w,
                                    top: 3.0.h,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showPlacePicker();
                                    },
                                    child: Container(
                                      height: Constants.constHeight,
                                      width: 90.0.w,
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
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                height: 2.5.h,
                                                child: Text(
                                                  address1 != null
                                                      ? address1!
                                                      : result
                                                          .data!
                                                          .location![0]
                                                          .addressLine1!,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
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
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.0.h, left: 3.0.w, right: 3.0.w),
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
                                itemCount:
                                    result.data!.educationalDetails1!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 3.0.w, right: 3.0.w, top: 1.5.h),
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(5),
                                      padding: EdgeInsets.all(12),
                                      color:
                                          Constants.formBorder.withOpacity(0.7),
                                      strokeWidth: 1.8,
                                      strokeCap: StrokeCap.butt,
                                      dashPattern: [4, 3],
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 1.0.w,
                                                right: 1.0.w,
                                                top: 1.0.h),
                                            child: Container(
                                              height: Constants.constHeight,
                                              width: 90.0.w,
                                              child: TextFormField(
                                                readOnly: true,
                                                controller:
                                                    controllersList[index],
                                                decoration: InputDecoration(
                                                  labelText: "Name of School",
                                                  labelStyle: TextStyle(
                                                      color:
                                                          Constants.bpSkipStyle,
                                                      fontFamily: "Montserrat",
                                                      fontSize: 10.0.sp),
                                                  fillColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Constants.formBorder,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    borderSide: BorderSide(
                                                      color:
                                                          Constants.formBorder,
                                                    ),
                                                  ),
                                                ),
                                                style: new TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 10.0.sp),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 1.0.w,
                                                  right: 1.0.w,
                                                  top: 3.0.h),
                                              child: Container(
                                                height: Constants.constHeight,
                                                width: 90.0.w,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0.w),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Constants.formBorder),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      result.data!
                                                              .educationalDetails1![
                                                          index]['year'],
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
                                                      padding: EdgeInsets.only(
                                                          left: 0.0),
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 25,
                                                        color: Constants
                                                            .formBorder,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 1.0.w,
                                                  right: 1.0.w,
                                                  top: 3.0.h),
                                              child: Container(
                                                height: Constants.constHeight,
                                                width: 90.0.w,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.0.w),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          Constants.formBorder),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      result.data!
                                                              .educationalDetails1![
                                                          index]['qualification'],
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
                                                      padding: EdgeInsets.only(
                                                          left: 0.0),
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 25,
                                                        color: Constants
                                                            .formBorder,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
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
                                                        width: 15.0.w,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(result
                                                                        .data!
                                                                        .educationalDetails1![index]
                                                                    [
                                                                    'certificate_file']),
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
                                                            child: Text(
                                                              'Certificate ${index + 1}',
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
                                        top: 3.0.h, left: 3.0.w, right: 3.0.w),
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
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 3.0.w,
                                  right: 3.0.w,
                                  top: 1.5.h,
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
                                          result.data!.totalWorkExperience!,
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
                                    totalWorkExp = int.parse(value);

                                    if (int.parse(value) > 0) {
                                      setState(() {
                                        workExp = '1';
                                      });
                                    }
                                  },
                                  dropdownButtonStyle: DropdownButtonStyle(
                                    height: Constants.constHeight,
                                    width: 90.0.w,
                                    elevation: 0,
                                    primaryColor: Constants.bpSkipStyle,
                                    side:
                                        BorderSide(color: Constants.formBorder),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  item.value,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants
                                                          .bpSkipStyle),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.0.h, left: 3.0.w, right: 3.0.w),
                                    child: Text(
                                      'Teaching Experience',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12.0.sp,
                                          color: Constants.bgColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 3.0.w,
                                  right: 3.0.w,
                                  top: 1.5.h,
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
                                          result.data!.totalTeachingExperience!,
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
                                    totalTeachExp = int.parse(value);

                                    if (int.parse(value) > 0) {
                                      setState(() {
                                        teachExp = '1';
                                      });
                                    }
                                  },
                                  dropdownButtonStyle: DropdownButtonStyle(
                                    height: Constants.constHeight,
                                    width: 90.0.w,
                                    elevation: 0,
                                    primaryColor: Constants.bpSkipStyle,
                                    side:
                                        BorderSide(color: Constants.formBorder),
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  item.value,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 10.0.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Constants
                                                          .bpSkipStyle),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.0.h, left: 3.0.w, right: 3.0.w),
                                    child: Text(
                                      'Subjects of Expertise',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12.0.sp,
                                          color: Constants.bgColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 1.5.h),
                                child: GestureDetector(
                                  onTap: () {
                                    _openFilterSubjectDialog();
                                  },
                                  child: Container(
                                    height: 13.0.h,
                                    width: 90.0.w,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.w, vertical: 1.5.h),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Constants.formBorder),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Center(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: SingleChildScrollView(
                                          child: Text(
                                            result.data!.subjects != null
                                                ? result.data!.subjects
                                                : selectedSubjectList
                                                    .toString()
                                                    .replaceAll('[', '')
                                                    .replaceAll(']', '')
                                                    .replaceAll(
                                                        new RegExp(r', '), ' #')
                                                    .replaceFirst('', '#'),
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 10.0.sp,
                                                color: Constants.bpSkipStyle),
                                          ),
                                        ),
                                      ),
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
                                      'Maximum 25 subjects',
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
                                        top: 3.0.h, left: 3.0.w, right: 2.0.w),
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 1.5.h),
                                child: Container(
                                  height: 13.0.h,
                                  width: 90.0.w,
                                  child: TextFormField(
                                    controller: _achivementController,
                                    maxLines: 5,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
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
                                          ),
                                        ),
                                        hintText:
                                            "Please mention your achivements..."),
                                    style: new TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 10.0.sp),
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
                                        top: 3.0.h, left: 3.0.w, right: 2.0.w),
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 1.5.h),
                                child: GestureDetector(
                                  onTap: () {
                                    _openFilterSkillsDialog();
                                  },
                                  child: Container(
                                    height: 13.0.h,
                                    width: 90.0.w,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.0.w, vertical: 1.5.h),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Constants.formBorder),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        selectedSkillList == null ||
                                                selectedSkillList.length == 0
                                            ? result.data!.skills!
                                            : selectedSkillList
                                                .toString()
                                                .replaceAll('[', '')
                                                .replaceAll(']', '')
                                                .replaceAll(
                                                    new RegExp(r', '), ' #')
                                                .replaceFirst('', '#'),
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 10.0.sp,
                                            color: Constants.bpSkipStyle),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.0.h, left: 3.0.w, right: 2.0.w),
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 3.0.w, right: 3.0.w, top: 1.5.h),
                                child: GestureDetector(
                                  onTap: () {
                                    _openFilterHobbiesDialog();
                                  },
                                  child: Container(
                                    height: 13.0.h,
                                    width: 90.0.w,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.0.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Constants.formBorder),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        selectedHobbiesList == null ||
                                                selectedHobbiesList.length == 0
                                            ? result.data!.hobbies!
                                            : selectedHobbiesList
                                                .toString()
                                                .replaceAll('[', '')
                                                .replaceAll(']', '')
                                                .replaceAll(
                                                    new RegExp(r', '), ' #')
                                                .replaceFirst('', '#'),
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 10.0.sp,
                                            color: Constants.bpSkipStyle),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3.0.h, left: 3.0.w, right: 2.0.w),
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
                              LinkInputWidget(
                                  textEditingController: _fbLinkController,
                                  lable: 'Facebook'),
                              LinkInputWidget(
                                  textEditingController:
                                      _instagramLinkController,
                                  lable: 'Instagram'),
                              LinkInputWidget(
                                  textEditingController:
                                      _linkedInLinkLinkController,
                                  lable: 'LinkedIn'),
                              LinkInputWidget(
                                  textEditingController:
                                      _otherLinkLinkController,
                                  lable: 'Other'),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 3.0.w,
                                    left: 3.0.w,
                                    top: 6.0.h,
                                    bottom: 3.0.h),
                                child: GestureDetector(
                                    onTap: () async {
                                      wordCountForDescription(
                                          _achivementController.text);
                                      bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9."
                                              r"!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(
                                              _emailController.text.trim());
                                      bool fbLinkCheck = RegExp(
                                              r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")
                                          .hasMatch(
                                              _fbLinkController.text.trim());
                                      bool instaLinkCheck = RegExp(
                                              r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")
                                          .hasMatch(_instagramLinkController
                                              .text
                                              .trim());
                                      bool liLinkCheck = RegExp(
                                              r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")
                                          .hasMatch(_linkedInLinkLinkController
                                              .text
                                              .trim());
                                      bool otLinkCheck = RegExp(
                                              r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")
                                          .hasMatch(_otherLinkLinkController
                                              .text
                                              .trim());
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
                                      } else if (_idNumController
                                          .text.isEmpty) {
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
                                            msg:
                                                "Please Select Work Experience",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (totalWorkExp == null) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Select Teaching Experience",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (fileName == null &&
                                          result.data!.imageUrl!
                                                  .split("/")
                                                  .last ==
                                              'default.jpg') {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Pick Selected Document",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (_certiName == null &&
                                          result.data!.educationalDetails!
                                              .isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "Please Pick Certificate",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (wordCount > 100) {
                                        Fluttertoast.showToast(
                                          msg:
                                              'Please Use 100 Words in Achivement Description',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp,
                                        );
                                      } else if (_fbLinkController
                                              .text.isNotEmpty &&
                                          fbLinkCheck == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Enter Valid Facebook Link",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (_instagramLinkController
                                              .text.isNotEmpty &&
                                          instaLinkCheck == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Enter Valid Instagram Link",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (_linkedInLinkLinkController
                                              .text.isNotEmpty &&
                                          liLinkCheck == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Enter Valid LinkedIn Link",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (_otherLinkLinkController
                                              .text.isNotEmpty &&
                                          otLinkCheck == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Enter Valid Other Link",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else {
                                        _image == null
                                            ? updateProfile(
                                                registerAs,
                                                _nameController.text,
                                                _mobileController.text,
                                                _emailController.text,
                                                gender,
                                                birthDateInString,
                                                docType,
                                                _idNumController.text,
                                                address1,
                                                address2,
                                                city,
                                                country,
                                                pinCode,
                                                lat,
                                                lng,
                                                _achivementController.text,
                                                selectedSkillList.length == 0
                                                    ? skillList
                                                        .toString()
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceFirst('#', '')
                                                        .replaceAll(' #', ',')
                                                    : selectedSkillList
                                                        .toString(),
                                                selectedHobbiesList.length == 0
                                                    ? hobbieList
                                                        .toString()
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceFirst('#', '')
                                                        .replaceAll(' #', ',')
                                                    : selectedHobbiesList
                                                        .toString(),
                                                selectedSubjectList.length == 0
                                                    ? subjectList
                                                        .toString()
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceFirst('#', '')
                                                        .replaceAll(' #', ',')
                                                    : selectedSubjectList
                                                        .toString(),
                                                _fbLinkController.text,
                                                _instagramLinkController.text,
                                                _linkedInLinkLinkController
                                                    .text,
                                                _otherLinkLinkController.text,
                                                totalWorkExp,
                                                totalTeachExp)
                                            : updateProfileWithImage(
                                                registerAs,
                                                _nameController.text,
                                                _mobileController.text,
                                                _emailController.text,
                                                gender,
                                                birthDateInString,
                                                docType,
                                                _idNumController.text,
                                                address1,
                                                address2,
                                                city,
                                                country,
                                                pinCode,
                                                lat,
                                                lng,
                                                _achivementController.text,
                                                selectedSkillList.length == 0
                                                    ? skillList
                                                        .toString()
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceFirst('#', '')
                                                        .replaceAll(' #', ',')
                                                    : selectedSkillList
                                                        .toString(),
                                                selectedHobbiesList.length == 0
                                                    ? hobbieList
                                                        .toString()
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceFirst('#', '')
                                                        .replaceAll(' #', ',')
                                                    : selectedHobbiesList
                                                        .toString(),
                                                selectedSubjectList.length == 0
                                                    ? subjectList
                                                        .toString()
                                                        .replaceAll('[', '')
                                                        .replaceAll(']', '')
                                                        .replaceFirst('#', '')
                                                        .replaceAll(' #', ',')
                                                    : selectedSubjectList
                                                        .toString(),
                                                _fbLinkController.text,
                                                _instagramLinkController.text,
                                                _linkedInLinkLinkController
                                                    .text,
                                                _otherLinkLinkController.text,
                                                totalWorkExp,
                                                totalTeachExp);

                                        updateUserPicCC();
                                      }
                                    },
                                    child: ButtonWidget(
                                        btnName: 'SUBMIT',
                                        isActive: true,
                                        fontWeight: FontWeight.w500)),
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

  updateUserPicCC() async {
    SharedPrefs sharedPrefs = await SharedPrefs.instance.init();

    File file = File(_image!.path);
    CubeUser? user = sharedPrefs.getUser();
    user!.password = '12345678';
    uploadFile(file, isPublic: false).then((cubeFile) {
      user.avatar = cubeFile.uid;
      return updateUser(user);
    }).catchError((error) {
    });
    String? avatarUrl = getPrivateUrlForUid(user.id.toString());
  }

  void showPlacePicker() async {
    AddressComponent addressLine;
    LocationResult result = await (Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              Config.locationKey,
            ))));

    setState(() {
      address1 = result.formattedAddress;
      address2 = result.subLocalityLevel1!.name;
      city = result.locality;
      country = address1!.substring(address1!.lastIndexOf(" ") + 1);
      lat = result.latLng!.latitude;
      lng = result.latLng!.longitude;
      pinCode = result.postalCode;
    });
  }

  void _openFilterSubjectDialog() async {
    await FilterListDialog.display(context,
        listData: subjectMapData!,
        selectedListData: selectedSubjectList,
        height: 480,
        headlineText: "Select or Search Subjects",
        searchFieldHintText: "Search Subjects Here",
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
        choiceChipLabel: (dynamic item) {
          return item;
        },
        validateSelectedItem: (list, dynamic val) {
          return list!.contains(val);
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
        onItemSearch: (list, text) {
          if (list!.any((element) =>
              element.toString().toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) => element
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()))
                .toList();
          }
          return list;
        },
        onApplyButtonClick: (list) {
          if (list != null) {
            if (list.length > 25) {
              Fluttertoast.showToast(
                msg: 'Subject reaches the maximum limit',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Constants.bgColor,
                textColor: Colors.white,
                fontSize: 10.0.sp,
              );
            } else {
              setState(() {
                selectedSubjectList = List.from(list);
              });
            }
          }
          Navigator.pop(context);
        });
  }

  void _openFilterSkillsDialog() async {
    await FilterListDialog.display(context,
        listData: skillMapData!,
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
        choiceChipLabel: (dynamic item) {
          return item;
        },
        validateSelectedItem: (list, dynamic val) {
          return list!.contains(val);
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
        onItemSearch: (list, text) {
          if (list!.any((element) =>
              element.toString().toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) => element
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()))
                .toList();
          }
          return list;
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

  void _openFilterHobbiesDialog() async {
    await FilterListDialog.display(context,
        listData: hobbieMapData!,
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
        choiceChipLabel: (dynamic item) {
          return item;
        },
        validateSelectedItem: (list, dynamic val) {
          return list!.contains(val);
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
        onItemSearch: (list, text) {
          if (list!.any((element) =>
              element.toString().toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) => element
                    .toString()
                    .toLowerCase()
                    .contains(text.toLowerCase()))
                .toList();
          }
          return list;
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

  getCatSkillHobbieList() async {
    try {
      Dio dio = Dio();
      var option = Options(headers: {"Authorization": 'Bearer $authToken'});
      var response = await Future.wait([
        dio.get(Config.profileDetailsUrl, options: option),
        dio.get(Config.skillListUrl, options: option),
        dio.get(Config.hobbieListUrl, options: option),
        dio.get(Config.getAllSubjectUrl, options: option),
      ]);

      if (response[0].statusCode == 200 &&
          response[1].statusCode == 200 &&
          response[2].statusCode == 200 &&
          response[3].statusCode == 200) {
        result = EducatorProfileDetails.fromJson(response[0].data);

        skillMap = response[1].data;
        hobbieMap = response[2].data;
        subjectMap = response[3].data;

        eduMap = response[0].data;
        eduMapData = eduMap!['data']['educational_details'];

        populateEducationDetails();
        setState(() {
          skillMapData = skillMap!['data'];
          hobbieMapData = hobbieMap!['data'];
          subjectMapData = subjectMap!['data'];
          _nameController.text = result.data!.name!;
          _mobileController.text = result.data!.mobileNumber!;
          _emailController.text = result.data!.email!;
          gender = result.data!.gender;
          birthDateInString = result.data!.dob;
          docType = result.data!.documentType;
          totalWorkExp = int.parse(result.data!.totalWorkExperience!);
          totalTeachExp = int.parse(result.data!.totalTeachingExperience!);
          for (int i = 0; i < eduMapData!.length; i++) {
            qualificationList
                .add(result.data!.educationalDetails1![i]['qualification']);

            netImage
                .add(result.data!.educationalDetails1![i]['certificate_file']);
            fileImage.add(_certificate);
          }

          _idNumController.text = result.data!.identificationDocumentNumber!;
          _achivementController.text = result.data!.achievements!;
          skillList.add(result.data!.skills);
          hobbieList.add(result.data!.hobbies);
          subjectList.add(result.data!.subjects);

          _fbLinkController.text = result.data!.facebookUrl ?? '';
          _instagramLinkController.text = result.data!.instaUrl ?? '';
          _linkedInLinkLinkController.text = result.data!.linkedinUrl ?? '';
          _otherLinkLinkController.text = result.data!.otherUrl ?? '';
        });
        if (result != null) {
          isLoading = false;
        }
      } else {
        if (skillMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: skillMap!['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else if (hobbieMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: hobbieMap!['error_msg'],
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
  }

  Future<ProfileUpdate> updateProfile(
    String? registerAs,
    String name,
    String mobileNumber,
    String email,
    String? gender,
    String? dob,
    String? documentType,
    String idNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? country,
    String? pinCode,
    double? latitude,
    double? longitude,
    String achievements,
    String? skills,
    String? hobbies,
    String? subjects,
    String facbookUrl,
    String instaUrl,
    String linkedinUrl,
    String otherUrl,
    int? totalWorkExp,
    int? totalTeachExp,
  ) async {
    displayProgressDialog(context);

    var update = ProfileUpdate();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_url': result.data!.documentUrl,
        'image_url': result.data!.imageUrl,
        'identification_document_number': idNumber,
        'location[0][id]': result.data!.location![0].id,
        'location[0][address_line_1]': addressLine1 == null
            ? result.data!.location![0].addressLine1
            : addressLine1,
        'location[0][city]':
            city == null ? result.data!.location![0].city : city,
        'location[0][country]':
            country == null ? result.data!.location![0].country : country,
        'location[0][pincode]':
            pinCode == null ? result.data!.location![0].pincode : pinCode,
        'location[0][latitude]':
            latitude == null ? result.data!.location![0].latitude : latitude,
        'location[0][longitude]':
            longitude == null ? result.data!.location![0].longitude : longitude,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills.toString().replaceAll('[', '').replaceAll(']', ''),
        'hobbies': hobbies.toString().replaceAll('[', '').replaceAll(']', ''),
        'subjects': subjects.toString().replaceAll('[', '').replaceAll(']', ''),
        'facebook_url': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
        'total_teaching_experience': totalTeachExp,
      });

      for (int i = 0; i < result.data!.educationalDetails1!.length; i++) {
        if (result.data!.educationalDetails1![i]['id'] != null) {
          formData.fields.addAll([
            MapEntry('educational_details[$i][id]',
                result.data!.educationalDetails1![i]['id'].toString()),
            MapEntry('educational_details[$i][school_name]',
                controllersList[i].text),
            MapEntry('educational_details[$i][year]',
                result.data!.educationalDetails1![i]['year'].toString()),
            MapEntry('educational_details[$i][qualification]',
                result.data!.educationalDetails1![i]['qualification']),
            MapEntry('educational_details[$i][certificate_file]', ''),
          ]);
        } else {
          formData.fields.addAll([
            MapEntry('educational_details[$i][id]',
                result.data!.educationalDetails1![i]['id'].toString()),
            MapEntry('educational_details[$i][school_name]',
                controllersList[i].text),
            MapEntry('educational_details[$i][year]',
                result.data!.educationalDetails1![i]['year'].toString()),
            MapEntry('educational_details[$i][qualification]',
                result.data!.educationalDetails1![i]['qualification']),
            MapEntry('educational_details[$i][certificate_file]', ''),
          ]);
        }
      }

      var response = await dio.post(
        Config.updateProfileUrl,
        data: formData,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken!}),
      );
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        update = ProfileUpdate.fromJson(response.data);

        if (update.status == true) {
          setState(() {
            preferences.setString("name", update.data!.name!);
            preferences.setString("mobileNumber", update.data!.mobileNumber!);
          });

          Fluttertoast.showToast(
            msg: update.message!,
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
          Fluttertoast.showToast(
            msg: update.message == null ? update.errorMsg : update.message!,
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
          msg: update.message!,
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
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {}
    }
    return update;
  }

  Future<ProfileUpdate> updateProfileWithDocument(
    String registerAs,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String dob,
    String documentType,
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
    int totalWorkExp,
    int totalTeachExp,
  ) async {
    displayProgressDialog(context);

    var update = ProfileUpdate();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      Dio dio = Dio();

      FormData formDataD = FormData.fromMap({
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_file': await MultipartFile.fromFile(
          _document!.path,
          filename: _document!.path.split("/").last,
        ),
        'image_file': null,
        'image_url': result.data!.imageUrl,
        'identification_document_number': idNumber,
        'location[0][id]': result.data!.location![0].id,
        'location[0][address_line_1]': addressLine1 == null
            ? result.data!.location![0].addressLine1
            : addressLine1,
        'location[0][city]':
            city == null ? result.data!.location![0].city : city,
        'location[0][country]':
            country == null ? result.data!.location![0].country : country,
        'location[0][pincode]':
            pinCode == null ? result.data!.location![0].pincode : pinCode,
        'location[0][latitude]':
            latitude == null ? result.data!.location![0].latitude : latitude,
        'location[0][longitude]':
            longitude == null ? result.data!.location![0].longitude : longitude,
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

      for (int i = 0; i < result.data!.educationalDetails!.length; i++) {
        formDataD.fields.addAll([
          MapEntry('educational_details[$i][id]',
              result.data!.educationalDetails![i].id.toString()),
          MapEntry('educational_details[$i][school_name]',
              result.data!.educationalDetails![i].schoolName.toString()),
          MapEntry('educational_details[$i][year]',
              result.data!.educationalDetails![i].year.toString()),
          MapEntry('educational_details[$i][qualification]',
              result.data!.educationalDetails![i].qualification.toString()),
          MapEntry('educational_details[$i][certificate_file]', ''),
        ]);
      }

      var response = await dio.post(
        Config.updateProfileUrl,
        data: formDataD,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken!}),
      );
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        update = ProfileUpdate.fromJson(response.data);

        if (update.status == true) {
          setState(() {
            preferences.setString("name", update.data!.name!);
            preferences.setString("imageUrl", update.data!.imageUrl!);
            preferences.setString("mobileNumber", update.data!.mobileNumber!);
          });
          Fluttertoast.showToast(
            msg: update.message!,
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
          Fluttertoast.showToast(
            msg: update.message!,
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
          msg: update.message!,
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
      } else {}
    }
    return update;
  }

  Future<ProfileUpdate> updateProfileWithImage(
    String? registerAs,
    String name,
    String mobileNumber,
    String email,
    String? gender,
    String? dob,
    String? documentType,
    String idNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? country,
    String? pinCode,
    double? latitude,
    double? longitude,
    String achievements,
    String? skills,
    String? hobbies,
    String? subjects,
    String facbookUrl,
    String instaUrl,
    String linkedinUrl,
    String otherUrl,
    int? totalWorkExp,
    int? totalTeachExp,
  ) async {
    displayProgressDialog(context);

    var update = ProfileUpdate();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      Dio dio = Dio();

      FormData formDataI = FormData.fromMap({
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_url': result.data!.documentUrl,
        'image_file': await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.path.split("/").last,
        ),
        'identification_document_number': idNumber,
        'location[0][id]': result.data!.location![0].id,
        'location[0][address_line_1]': addressLine1 == null
            ? result.data!.location![0].addressLine1
            : addressLine1,
        'location[0][city]':
            city == null ? result.data!.location![0].city : city,
        'location[0][country]':
            country == null ? result.data!.location![0].country : country,
        'location[0][pincode]':
            pinCode == null ? result.data!.location![0].pincode : pinCode,
        'location[0][latitude]':
            latitude == null ? result.data!.location![0].latitude : latitude,
        'location[0][longitude]':
            longitude == null ? result.data!.location![0].longitude : longitude,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills.toString().replaceAll('[', '').replaceAll(']', ''),
        'hobbies': hobbies.toString().replaceAll('[', '').replaceAll(']', ''),
        'subjects': subjects.toString().replaceAll('[', '').replaceAll(']', ''),
        'facebook_url': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
        'total_teaching_experience': totalTeachExp,
      });

      for (int i = 0; i < result.data!.educationalDetails!.length; i++) {
        formDataI.fields.addAll([
          MapEntry('educational_details[$i][id]',
              result.data!.educationalDetails![i].id.toString()),
          MapEntry('educational_details[$i][school_name]',
              result.data!.educationalDetails![i].schoolName.toString()),
          MapEntry('educational_details[$i][year]',
              result.data!.educationalDetails![i].year.toString()),
          MapEntry('educational_details[$i][qualification]',
              result.data!.educationalDetails![i].qualification.toString()),
          MapEntry('educational_details[$i][certificate_file]', ''),
        ]);
      }

      var response = await dio.post(
        Config.updateProfileUrl,
        data: formDataI,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken!}),
      );
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        update = ProfileUpdate.fromJson(response.data);

        if (update.status == true) {
          setState(() {
            preferences.setString("name", update.data!.name!);
            preferences.setString("imageUrl", update.data!.imageUrl!);
            preferences.setString("mobileNumber", update.data!.mobileNumber!);
          });
          Fluttertoast.showToast(
            msg: update.message!,
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
          Fluttertoast.showToast(
            msg: update.errorMsg!,
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
          msg: update.message!,
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
      } else {}
    }
    return update;
  }

  Future<ProfileUpdate> updateProfileWithBoth(
    String registerAs,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String dob,
    String documentType,
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
    int totalWorkExp,
    int totalTeachExp,
  ) async {
    displayProgressDialog(context);

    var update = ProfileUpdate();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      Dio dio = Dio();

      FormData formDataID = FormData.fromMap({
        'register_as': registerAs,
        'name': name,
        'mobile_number': mobileNumber,
        'email': email,
        'gender': gender,
        'dob': dob,
        'document_type': documentType,
        'document_file': await MultipartFile.fromFile(
          _document!.path,
          filename: _document!.path.split("/").last,
        ),
        'image_file': await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.path.split("/").last,
        ),
        'identification_document_number': idNumber,
        'location[0][id]': result.data!.location![0].id,
        'location[0][address_line_1]': addressLine1 == null
            ? result.data!.location![0].addressLine1
            : addressLine1,
        'location[0][city]':
            city == null ? result.data!.location![0].city : city,
        'location[0][country]':
            country == null ? result.data!.location![0].country : country,
        'location[0][pincode]':
            pinCode == null ? result.data!.location![0].pincode : pinCode,
        'location[0][latitude]':
            latitude == null ? result.data!.location![0].latitude : latitude,
        'location[0][longitude]':
            longitude == null ? result.data!.location![0].longitude : longitude,
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

      for (int i = 0; i < result.data!.educationalDetails!.length; i++) {
        formDataID.fields.addAll([
          MapEntry('educational_details[$i][id]',
              result.data!.educationalDetails![i].id.toString()),
          MapEntry('educational_details[$i][school_name]',
              result.data!.educationalDetails![i].schoolName.toString()),
          MapEntry('educational_details[$i][year]',
              result.data!.educationalDetails![i].year.toString()),
          MapEntry('educational_details[$i][qualification]',
              result.data!.educationalDetails![i].qualification.toString()),
          MapEntry('educational_details[$i][certificate_file]', ''),
        ]);
      }

      var response = await dio.post(
        Config.updateProfileUrl,
        data: formDataID,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken!}),
      );
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        update = ProfileUpdate.fromJson(response.data);

        if (update.status == true) {
          setState(() {
            preferences.setString("name", update.data!.name!);
            preferences.setString("imageUrl", update.data!.imageUrl!);
            preferences.setString("mobileNumber", update.data!.mobileNumber!);
          });
          Fluttertoast.showToast(
            msg: update.message!,
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
          Fluttertoast.showToast(
            msg: update.message!,
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
          msg: update.message!,
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
      } else {}
    }
    return update;
  }

  Future<void> apiCall(
    int userId,
    String registerAs,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String dob,
    String documentType,
    File documentFile,
    File imageFile,
    String idNumber,
    String achievements,
    String skills,
    String hobbies,
    String facbookUrl,
    String instaUrl,
    String linkedinUrl,
    String otherUrl,
    int totalWorkExp,
    int totalTeachExp,
  ) async {
    displayProgressDialog(context);

    String docname = documentFile.path.split('/').last;
    String imgname = imageFile.path.split('/').last;

    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $authToken'
    };

    var request =
        http.MultipartRequest('POST', Uri.parse(Config.updateProfileUrl));
    request.headers.addAll(headers);

    Map<String, String> params = new Map<String, String>();

    if (educationList.length != 0) {
      for (int i = 0; i < educationList.length; i++) {
        params['educational_details[$i][school_name]'] =
            educationDetailMap[i]['school_name'].toString();

        params['educational_details[$i][year]'] =
            educationDetailMap[i]['year'].toString();

        params['educational_details[$i][qualification]'] =
            educationDetailMap[i]['qualification'].toString();

        String fileStringPath = educationList[i].file!.path;
        if (!fileStringPath.contains('.pdf')) {
          var files = await http.MultipartFile.fromPath(
              "educationDetailMap[$i]['certificate']",
              educationList[i].file!.path,
              contentType: MediaType('image', 'png'));
          request.files.add(files);
        } else {
          var files = await http.MultipartFile.fromPath(
              "educationDetailMap[$i]['certificate']",
              educationList[i].file!.path,
              contentType: MediaType('application', 'pdf'));
          request.files.add(files);
        }
      }
    } else {
      params['educational_details[]'] = '';
    }

    params['user_id'] = userId.toString();
    params['register_as'] = registerAs;
    params['name'] = name;
    params['mobile_number'] = mobileNumber;
    params['email'] = email;
    params['gender'] = gender;
    params['dob'] = dob;
    params['document_type'] = documentType;
    var document = await http.MultipartFile.fromPath(
        params['document_file']!, documentFile.path,
        filename: documentFile.path, contentType: MediaType('image', 'png'));
    var docstream = http.ByteStream(documentFile.openRead());
    final doclength = await documentFile.length();
    request.files.add(http.MultipartFile(
        params['document_file'].toString(), docstream, doclength,
        filename: docname));
    var imgstream = http.ByteStream(imageFile.openRead());
    final imglength = await documentFile.length();
    var image = await http.MultipartFile.fromPath(
        params['image_file']!, imageFile.path,
        filename: imageFile.path, contentType: MediaType('image', 'png'));
    request.files.add(http.MultipartFile(
        params['image_file'].toString(), imgstream, imglength,
        filename: imgname));

    params['location[0][address_line_1]'] = 'abc';

    params['location[0][city]'] = 'Gujarat';
    params['location[0][country]'] = 'India';
    params['location[0][pincode]'] = '390006';
    params['location[0][latitude]'] = '123.00';
    params['location[0][longitude]'] = '456.00';
    params['location[0][location_type]'] = 'work';
    params['identification_document_number'] = idNumber;
    params['achievements'] = achievements;
    params['skills'] = skills;
    params['hobbies'] = hobbies;

    params['facbook_link'] = facbookUrl;
    params['insta_url'] = instaUrl;
    params['linkedin_url'] = linkedinUrl;
    params['other_url'] = otherUrl;
    params['total_work_experience'] = totalWorkExp.toString();
    params['total_teaching_experience'] = totalTeachExp.toString();

    request.fields.addAll(params);
    log(jsonEncode(params));

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((event) {});

    if (response.statusCode == 200) {
      closeProgressDialog(context);

      var responseData = response.stream.bytesToString();

      responseMap = jsonDecode(responseData.toString());
      Fluttertoast.showToast(
        msg: responseMap!['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.bgColor,
        textColor: Colors.white,
        fontSize: 10.0.sp,
      );
    } else {
      closeProgressDialog(context);
      Fluttertoast.showToast(
        msg: responseMap!['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Constants.bgColor,
        textColor: Colors.white,
        fontSize: 10.0.sp,
      );
    }
  }

  Future<File?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75,
    );

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
