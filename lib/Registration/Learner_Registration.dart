import 'dart:io';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/UpdateProfile_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:filter_list/filter_list.dart';

class LearnerRegistration extends StatefulWidget {
  String name, mobileNumber;
  LearnerRegistration(
      {Key key, @required this.name, @required this.mobileNumber})
      : super(key: key);

  @override
  _LearnerRegistrationState createState() => _LearnerRegistrationState();
}

class _LearnerRegistrationState extends State<LearnerRegistration> {
  File _image, _certificate, _document;
  String birthDateInString, selectedYearString;
  DateTime birthDate, selectedYear;
  bool isDateSelected = false;
  bool isYearSelected = false;
  String gender = 'Gender';
  String docType = 'DocType';
  String qualification = '0';
  String workExp = '0';
  String fileName;
  String address1, address2, city, country, pinCode;
  double lat, lng;
  bool isCat1 = false;
  int itemCount = 0;
  int educationId = 0;
  String authToken;
  List<String> skillList = [];
  List<String> hobbieList = [];
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
  List<String> selectedSkillList = [];
  List<String> selectedHobbiesList = [];

  Map<String, dynamic> skillMap = Map<String, dynamic>();
  List<dynamic> skillMapData = List();

  Map<String, dynamic> hobbieMap = Map<String, dynamic>();
  List<dynamic> hobbieMapData = List();

  Map<String, dynamic> categoryMap = Map<String, dynamic>();
  List<dynamic> categoryMapData = List();

  List<bool> intrestedCat = List<bool>();
  List<int> intrestedCatKey = List<int>();
  // List<Skills> _selectedSkills;
  // String _selectedSkillsJson = 'Nothing to show';

  // List<Hobbies> _selectedHobbies;
  // String _selectedHobbiesJson = 'Nothing to show';

  List<String> catList = List();
  String _certiName;
  List<dynamic> educationDetailMap = [];
  int userId;
  String registerAs;
  int totalWorkExp;

  @override
  void initState() {
    super.initState();
    // _selectedSkills = [];
    // _selectedHobbies = [];
    getToken();
    getData();
    _nameController.text = widget.name;
    _mobileController.text = widget.mobileNumber;
    educationDetailMap.add({
      'school_name': 'MSU',
      'year': 'Year',
      'qualification': 'BCA',
      'certificate': 'Upload Certificate/Degree'
    });
    print(educationDetailMap);
    catList = [
      'Category 1',
      'Category 2',
      'Category 3',
      'Category 4',
      'Category 5',
      'Category 6',
      'Category 7',
      'Category 8',
    ];
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

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getCatSkillHobbieList();
  }

  _imageFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imageFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

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

  _certificateFromCamera(int index) async {
    File doc = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _certificate = doc;
      _certiName = doc.path.split('/scaled_').last.substring(35);
      educationDetailMap[index]['certificate'] = _certificate.path;
    });
  }

  _certificateFromGallery(int index) async {
    File doc = (await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _certificate = doc;
      _certiName = doc.path.split('/scaled_image_picker').last;
      educationDetailMap[index]['certificate'] = _certificate.path;
      print(_certiName);
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
                                                    BorderRadius.circular(70),
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
                                                      color:
                                                          Constants.formBorder,
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
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.85.h),
                                                      child: Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              print(
                                                                  'Upload Pic!!!');
                                                              _showPicker(
                                                                  context);
                                                            },
                                                            child: ImageIcon(
                                                              AssetImage(
                                                                  'assets/icons/camera.png'),
                                                              size: 25,
                                                              color: Constants
                                                                  .formBorder,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Upload',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                fontSize:
                                                                    8.0.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Constants
                                                                    .formBorder),
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
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 3.2.w * 2.5,
                                                width: 3.2.w * 2.5,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Constants
                                                            .formBorder),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.0.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants.formBorder),
                                      borderRadius: BorderRadius.circular(5.0),
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
                                  _uploadDocument();
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
                                            color: Constants.formBorder),
                                        SizedBox(
                                          width: 1.0.w,
                                        ),
                                        Text(
                                          (fileName == null || fileName == '')
                                              ? 'Upload the file'
                                              : fileName,
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
                                  //_showLocation(context);
                                  showPlacePicker();
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
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            height: 2.5.h,
                                            //width: 70.0.w,
                                            child: Text(
                                              address1 == null
                                                  ? 'Location'
                                                  : address1,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Constants.bpSkipStyle),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.0.w),
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
                          itemCount: educationDetailMap.length,
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
                                    index == 0
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4.0.w),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        'Remove Education ${index + 1} Block');
                                                    setState(() {
                                                      //itemCount = itemCount - 1;
                                                      educationDetailMap
                                                          .removeAt(index);
                                                    });
                                                    print(educationDetailMap);
                                                  },
                                                  child: ImageIcon(
                                                    AssetImage(
                                                        'assets/icons/close_icon.png'),
                                                    color:
                                                        Constants.bpSkipStyle,
                                                    size: 22.0,
                                                  )),
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
                                            top: 1.0.h),
                                        child: Container(
                                          height: 7.0.h,
                                          width: 90.0.w,
                                          child: TextFormField(
                                            //controller: myControllers[index],
                                            onChanged: (value) {
                                              educationDetailMap[index]
                                                      ['school_name'] =
                                                  value.toString();
                                              print(
                                                  'SCHOOL### ${value.toString()}');
                                            },
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
                                                        "Select Qualification Year"),
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
                                                            // isYearSelected
                                                            //     ? selectedYear
                                                            //     :
                                                            DateTime(
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
                                                          educationDetailMap[
                                                                      index]
                                                                  ['year'] =
                                                              selectedYear.year
                                                                  .toString();

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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    isYearSelected
                                                        ? educationDetailMap[
                                                                index]['year']
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
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0.0),
                                                    child: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      size: 25,
                                                      color:
                                                          Constants.formBorder,
                                                    ),
                                                  )
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
                                            if (value == 1) {
                                              qualification = 'Graduate';
                                              educationDetailMap[index]
                                                      ['qualification'] =
                                                  'Graduate';
                                              print(qualification);
                                            } else if (value == 2) {
                                              qualification = 'Post-graduate';
                                              educationDetailMap[index]
                                                      ['qualification'] =
                                                  'Post-graduate';
                                              print(qualification);
                                            } else if (value == 3) {
                                              qualification =
                                                  'Chartered Accountant';
                                              educationDetailMap[index]
                                                      ['qualification'] =
                                                  'Chartered Accountant';
                                              print(qualification);
                                            } else {
                                              qualification = 'Others';
                                              educationDetailMap[index]
                                                  ['qualification'] = 'Others';
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
                                              _showCertificatePicker(
                                                  context, index);
                                            },
                                            child: Container(
                                              height: 6.0.h,
                                              width: 90.0.w,
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding: educationDetailMap[
                                                                    index][
                                                                'certificate'] ==
                                                            'path' ||
                                                        educationDetailMap[
                                                                    index][
                                                                'certificate'] ==
                                                            'Upload Certificate/Degree'
                                                    ? EdgeInsets.only(
                                                        left: 20.0)
                                                    : EdgeInsets.zero,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    educationDetailMap[index][
                                                                    'certificate'] ==
                                                                'path' ||
                                                            educationDetailMap[
                                                                        index][
                                                                    'certificate'] ==
                                                                'Upload Certificate/Degree'
                                                        ? ImageIcon(
                                                            AssetImage(
                                                                'assets/icons/upload.png'),
                                                            size: 25,
                                                            color: Constants
                                                                .formBorder)
                                                        : Container(
                                                            //height: 5.0.h,
                                                            width: 15.0.w,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        educationDetailMap[index]
                                                                            [
                                                                            'certificate']),
                                                                    fit: BoxFit
                                                                        .fill)),
                                                          ),
                                                    SizedBox(width: 2.0.w),
                                                    // ImageIcon(
                                                    //     AssetImage(
                                                    //       _certificate == null
                                                    //       ?  'assets/icons/upload.png'
                                                    //       :  educationDetailMap[index]['certificate']),
                                                    //     size: 25,
                                                    //     color: Constants
                                                    //         .formBorder),
                                                    // SizedBox(
                                                    //   width: 1.0.w,
                                                    // ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Container(
                                                          height: 3.0.h,
                                                          child: Text(
                                                            _certiName != null
                                                                ? educationDetailMap[
                                                                            index]
                                                                        [
                                                                        'certificate']
                                                                    .toString()
                                                                    .split('/')
                                                                    .last //_certiName
                                                                : 'Upload Certificate/Degree',
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
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                          ),
                                                        ),
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
                                  ],
                                ),
                              ),
                            );
                          },
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
                                  //print(myControllers[1].text.toString());
                                  print('Add more!!!');
                                  setState(() {
                                    educationId = educationId + 1;
                                  });
                                  educationDetailMap.add({
                                    'school_name': 'MSU',
                                    'year': 'Year',
                                    'qualification': 'BCA',
                                    'certificate': 'Upload Certificate/Degree'
                                  });
                                  print(educationDetailMap);
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
                                    crossAxisCount: 2, childAspectRatio: 5),
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(categoryMapData[index]['value'],
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
                                side: BorderSide(color: Constants.formBorder),
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
                            child: GestureDetector(
                              onTap: () {
                                _openFilterSkillsDialog();
                              },
                              child: Container(
                                height: 13.0.h,
                                width: 90.0.w,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 2.0.w),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Constants.formBorder),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Center(
                                  child: Text('gyusguysgysgugs',
                                  //  selectedSkillList == null ||
                                  //           selectedSkillList.length == 0
                                  //       ? "Please mention your skills example #skills1 #skills2..."
                                  //       : selectedSkillList
                                  //           .toString().replaceAll('[', '').replaceAll(']', '').
                                  //           replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.0.w),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants.formBorder),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Center(
                                    child: Text(
                                     selectedHobbiesList == null ||
                                            selectedHobbiesList.length == 0
                                        ? "Please mention your hobbies example #hobbie1 #hobbie2..."
                                        : selectedHobbiesList
                                            .toString().replaceAll('[', '').replaceAll(']', '').
                                            replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                      style: TextStyle(
                                          fontFamily: "Montserrat",
                                          fontSize: 10.0.sp,
                                          color: Constants.bpSkipStyle),
                                    ),
                                  ),
                                )
                                // height: 13.0.h,
                                // width: 90.0.w,
                                //     child: TextFieldTags(
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
                              } else if (_idNumController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Enter Valid ID Number",
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
                              } else if (fileName == null || fileName == '') {
                                Fluttertoast.showToast(
                                    msg: "Please Pick Selected Document",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else if(_image == null){
                                Fluttertoast.showToast(
                                    msg: "Please Pick Profile Image",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Constants.bgColor,
                                    textColor: Colors.white,
                                    fontSize: 10.0.sp);
                              } else {
                                addLearnerProfile(
                                  //userId,
                                    registerAs,
                                    _nameController.text,
                                    _mobileController.text,
                                    _emailController.text,
                                    gender,
                                    birthDateInString,
                                    docType,
                                    _document,
                                    _image,
                                    _idNumController.text,
                                    address1,
                                    address2,
                                    city,
                                    country,
                                    pinCode,
                                    lat,
                                    lng,
                                    _achivementController.text,
                                    selectedSkillList.toString().replaceAll('[', '').replaceAll(']', '')
                                            .replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                    selectedHobbiesList.toString().replaceAll('[', '').replaceAll(']', '')
                                           .replaceAll(new RegExp(r', '), ' #').replaceFirst('', '#'),
                                    _fbLinkController.text,
                                    _instagramLinkController.text,
                                    _linkedInLinkLinkController.text,
                                    _otherLinkLinkController.text,
                                    totalWorkExp);
                                // Navigator.of(context).push
                                //     //pushAndRemoveUntil
                                //     (MaterialPageRoute(
                                //         builder: (context) => bottomNavBar(0)));
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

  //Get Category, Skills, and Hobbies List
  getCatSkillHobbieList() async {
    //displayProgressDialog(context);
    //var result = CategoryList();
    try {
      Dio dio = Dio();
      var response = await Future.wait([
        dio.get(Config.categoryListUrl,
            options: Options(headers: {
              "Authorization": 'Bearer $authToken',
            })),
        dio.get(Config.skillListUrl),
        dio.get(Config.hobbieListUrl)
      ]);

      if (response[0].statusCode == 200 &&
          response[1].statusCode == 200 &&
          response[2].statusCode == 200) {
        //closeProgressDialog(context);
        //result = LearnerProfileDetails.fromJson(response[0].data);
        categoryMap = response[0].data;
        skillMap = response[1].data;
        hobbieMap = response[2].data;
        //saveImage();
        setState(() {
          categoryMapData = categoryMap['data'];
          skillMapData = skillMap['data'];
          hobbieMapData = hobbieMap['data'];
        });

        // if (result != null) {
        //   isLoading = false;
        // }

        for (int i = 0; i < categoryMapData.length; i++) {
          intrestedCat.add(categoryMapData[i]['selected']);
          // if(intrestedCat[i] == true){
          //   intrestedCatKey.add(categoryMapData[i]['key']);
          // } else{
          //   intrestedCatKey.removeAt(i);
          // }
        }
        // print(result.data.documentUrl);
        // debugPrint(result.data.skills);
        // debugPrint(result.data.hobbies);
        // print(intrestedCat);
        // print(intrestedCatKey);
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

  //Add profile for Educator
  Future<ProfileUpdate> addLearnerProfile(
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
    File documentFile,
    File imageFile,
    //File certificateFile,
    //String documentUrl,
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
    //List<InterestedCategory> interestedCategory,
  ) async {
    displayProgressDialog(context);
    String docname = documentFile.path.split('/').last;
    String imgname = imageFile.path.split('/').last;
    //String certiname = certificateFile.path.split('/').last;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = ProfileUpdate();
    // for (int i = 0; i <= myControllers.length; i++) {
    //   //education_details.add()
    // educationDetailMap = {
    //   //"id": 5,
    //   "school_name": ,
    //   "year": "",
    //   "qualification": "",
    //   "certificate_file": ""
    // };
    // }

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
        'document_file': await MultipartFile.fromFile(
          documentFile.path,
          filename: docname,
        ),
        'image_file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imgname,
        ),
        //'document_url': documentUrl,
        'identification_document_number': idNumber,
        //'location[0][id]': 54,
        'location[0][address_line_1]': addressLine1,
        'location[0][address_line_2]': addressLine2,
        'location[0][city]': city,
        'location[0][country]': country,
        'location[0][pincode]': pinCode,
        'location[0][latitude]': latitude,
        'location[0][longitude]': longitude,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills,
        'hobbies': hobbies,
        //'educational_details[0][id]': 25,
        // 'educational_details[0][school_name]': myControllers[0].text.toString(),
        // 'educational_details[0][year]': selectedYear.year,
        // 'educational_details[0][qualification]': qualification.toString(),
        // 'educational_details[0][certificate_file]':
        //     await MultipartFile.fromFile(
        //   certificateFile.path,
        //   filename: certiname,
        //   //contentType: new MediaType("jpg", "jpeg", "png", "pdf"),
        // ),
        'facebook_url': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
      });

      // print('MAP:::' + educationDetailMap[0]['school_name']);
      // print('MAP:::' + educationDetailMap[1]['school_name']);
      // print('MAP:::' + educationDetailMap[2]['school_name']);
      // print('MAP:::' + educationDetailMap[3]['school_name']);

      print('MAPO:::' + educationDetailMap.length.toString());

      for (int i = 0; i < educationDetailMap.length; i++) {
        //formData.fields.addAll(params.entries);
        //print('MAP:::' + educationDetailMap.length.toString());
        formData.fields.addAll([
          MapEntry('educational_details[$i][school_name]',
              educationDetailMap[i]['school_name'].toString()),
          MapEntry('educational_details[$i][year]',
              educationDetailMap[i]['year'].toString()),
          MapEntry('educational_details[$i][qualification]',
              educationDetailMap[i]['qualification'].toString()),
        ]);
        formData.files.addAll([
          MapEntry(
              'educational_details[$i][certificate_file]',
              await MultipartFile.fromFile(educationDetailMap[i]['certificate'],
                  filename: educationDetailMap[i]['certificate'])),
        ]);
      }
      print('MAP:::' + educationDetailMap.toString());

      for(int i = 0; i < intrestedCatKey.length; i++){
        formData.fields.addAll([
          MapEntry('interested_category[$i]', intrestedCatKey[i].toString())
        ]);
        print('ICAT:::' + intrestedCatKey[i].toString());
      }
      
      print(formData.fields);

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
        result = ProfileUpdate.fromJson(response.data);
        print(result.data.name);
        if (result.status == true) {
          print('TRUE::');
          preferences.setString("name", result.data.name);
          preferences.setString("imageUrl", result.data.imageUrl);
          preferences.setString("mobileNumber", result.data.mobileNumber);
          preferences.setString("gender", result.data.gender);
          preferences.setString("email", result.data.email);
          preferences.setString("qualification", result.data.educationalDetails[0].qualification.toString());
          preferences.setString("schoolName", result.data.educationalDetails[0].schoolName.toString());
          preferences.setString("address1", result.data.location.toString());
          preferences.setString("address2", result.data.location.toString());
          preferences.setString("facebookUrl", result.data.facbookUrl);
          preferences.setString("instaUrl", result.data.instaUrl);
          preferences.setString("linkedInUrl", result.data.linkedinUrl);
          preferences.setString("otherUrl", result.data.otherUrl);
          print('QUALIFICATION:::: ' +
              result.data.educationalDetails.last.qualification);
          print('LOCATION:::: ' + result.data.location[0].addressLine2);
          print('IMAGE:::: ' + result.data.imageUrl);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => bottomNavBar(4)),
              (Route<dynamic> route) => false);
        } else {
          print('FALSE::');
        }
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
