import 'dart:io';

import 'package:being_pupil/ConnectyCube/api_utils.dart';
import 'package:being_pupil/ConnectyCube/pref_util.dart';
import 'package:being_pupil/Login/Verification_Screen.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/EducationListItemModel.dart';
import 'package:being_pupil/Model/UpdateProfile_Model.dart';
import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:being_pupil/Widgets/Custom_Dropdown.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';

import 'package:image_picker/image_picker.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class EducatorRegistration extends StatefulWidget {
  String? name, mobileNumber, email;
  EducatorRegistration(
      {Key? key,
      required this.name,
      required this.mobileNumber,
      required this.email})
      : super(key: key);

  @override
  _EducatorRegistrationState createState() => _EducatorRegistrationState();
}

class _EducatorRegistrationState extends State<EducatorRegistration> {
  XFile? _image, _certificate, _document;
  File? ccFile;
  String? birthDateInString, selectedYearString;
  DateTime? birthDate, selectedYear;
  bool isDateSelected = false;
  bool isYearSelected = false;
  String gender = 'Gender';
  String docType = 'DocType';
  String qualification = '0';
  String workExp = '0';
  String teachExp = '0';
  String? fileName;
  String? _certiName;
  String? address1, address2, city, country, pinCode;
  double? lat, lng;
  int itemCount = 0;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _idNumController = TextEditingController();
  TextEditingController _scoolNameController = TextEditingController();
  TextEditingController _achivementController = TextEditingController();
  TextEditingController _fbLinkController = TextEditingController();
  TextEditingController _instagramLinkController = TextEditingController();
  TextEditingController _linkedInLinkLinkController = TextEditingController();
  TextEditingController _otherLinkLinkController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  var myControllers = [];
  String? authToken;
  List<EducationListItemModel> educationList = [];
  List<dynamic> educationDetailMap = [];
  int educationId = 0;
  int? userId;
  String? registerAs;
  List<String> skillList = [];
  List<String> hobbieList = [];

  int? totalWorkExp, totalTeachExp;

  List<String> selectedSkillList = [];
  List<String> selectedHobbiesList = [];
  List<String> selectedSubjectList = [];

  Map<String, dynamic>? skillMap = Map<String, dynamic>();
  List<dynamic>? skillMapData = [];

  Map<String, dynamic>? hobbieMap = Map<String, dynamic>();
  List<dynamic>? hobbieMapData = [];

  Map<String, dynamic>? subjectMap = Map<String, dynamic>();
  List<dynamic>? subjectMapData = [];

  final ImagePicker _picker = ImagePicker();

  static const String TAG = "_LoginPageState";
  CubeUser? user;

  File? ccfile;
  CubeUser ccuser = CubeUser();
  int wordCount = 0;
  bool isButtonEnabled = false;

  @override
  void initState() {
    itemCount = 1;
    _nameController.text = widget.name!;
    _mobileController.text = widget.mobileNumber!;
    _emailController.text = widget.email!;
    createControllers();
    getToken();
    getData();

    educationDetailMap.add({
      'school_name': 'MSU',
      'year': 'Year',
      'qualification': 'BCA',
      'certificate': 'Upload Certificate/Degree'
    });

    super.initState();
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

    SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
    user = sharedPrefs.getUser();

    if (user != null) {
      user!.password = '12345678';
      createSession(user).then((cubeSession) {
        preferences.setString('ccToken', cubeSession.token!);

        signIn(user!).then((cubeUser) async {
          _loginToCubeChat(context, user!);
          sharedPrefs.saveNewUser(user!);
        }).catchError((error) {});
      }).catchError((error) {});
    }
  }

  _loginToCubeChat(BuildContext context, CubeUser user) {
    user.password = '12345678';

    CubeChatConnectionSettings.instance.totalReconnections = 0;
    CubeChatConnection.instance
        .login(user)
        .then((cubeUser) {})
        .catchError((error) {
      _processLoginError(error);
    });
  }

  void _processLoginError(exception) {
    //log("Login error $exception", TAG);
    setState(() {});
    showDialogError(exception, context);
  }

  wordCountForDescription(String str) {
    setState(() {
      wordCount = str.split(" ").length;
    });
  }

  createControllers() {
    myControllers = [];
    for (var i = 0; i < 5; i++) {
      myControllers.add(TextEditingController());
    }
  }

  _imageFromCamera() async {
    XFile? image =
        (await _picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _image = image;
    });
    ccfile = File(image!.path);
    isEmpty();
  }

  _imageFromGallery() async {
    XFile? image = (await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _image = image;
    });
    ccfile = File(image!.path);
    isEmpty();
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
      });
      isEmpty();
    } else {}
  }

  _certificateFromCamera(int index) async {
    XFile? doc =
        (await _picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _certificate = doc;
      _certiName = doc!.path.split('/scaled_').last.substring(35);
      educationDetailMap[index]['certificate'] = _certificate!.path;
    });
    isEmpty();
  }

  _certificateFromGallery(int index) async {
    XFile? doc = (await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _certificate = doc;
      _certiName = doc!.path.split('/scaled_image_picker').last;
      educationDetailMap[index]['certificate'] = _certificate!.path;
    });
    isEmpty();
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
                                                    BorderRadius.circular(70),
                                                child: Image.file(
                                                  File(_image!.path),
                                                  height: 125.0,
                                                  width: 125.0,
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
                                              radius: 70.0,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
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
                          isReadOnly: true,
                          onChanged: (val) {
                            isEmpty();
                          },
                        ),
                        NumberInputWidget(
                          textEditingController: _mobileController,
                          lable: 'Mobile Number',
                          isReadOnly: true,
                          onChanged: (val) {
                            isEmpty();
                          },
                        ),
                        TextInputWidget(
                          textEditingController: _emailController,
                          lable: 'Email',
                          isReadOnly: true,
                          onChanged: (val) {
                            isEmpty();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            horizontal: 1.0.w),
                                        child: Text(
                                          'Gender',
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
                                    isEmpty();
                                  },
                                  dropdownButtonStyle: DropdownButtonStyle(
                                    height: 7.0.h,
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
                                  items: ['Male', 'Female', 'Other']
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

                                      if (birthDate!.day.toString().length ==
                                              1 &&
                                          birthDate!.month.toString().length ==
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
                                    isEmpty();
                                  }
                                },
                                child: Container(
                                  height: Constants.constHeight,
                                  width: 40.0.w,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 3.0.w),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Constants.formBorder),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isDateSelected
                                            ? birthDateInString!
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.0.w),
                                  child: Text(
                                    'Select Document Type',
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
                              isEmpty();
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: Constants.constHeight,
                              width: 90.0.w,
                              elevation: 0,
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
                              child: GestureDetector(
                                onTap: () {
                                  _uploadDocument();
                                },
                                child: Container(
                                  height: Constants.constHeight,
                                  width: 90.0.w,
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: fileName == null
                                        ? EdgeInsets.only(left: 22.0.w)
                                        : EdgeInsets.zero,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ImageIcon(
                                              AssetImage(
                                                  'assets/icons/upload.png'),
                                              size: 25,
                                              color: Constants.formBorder),
                                          SizedBox(
                                            width: 2.0.w,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                height: 2.5.h,
                                                child: Text(
                                                  (fileName == null ||
                                                          fileName == '')
                                                      ? 'Upload the file'
                                                      : fileName!,
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
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          fileName != null
                                              ? Icon(
                                                  Icons.close,
                                                  size: 22.0,
                                                  color: Constants.formBorder,
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextInputWidget(
                            textEditingController: _idNumController,
                            lable: 'Identification Document Number',
                            isIdField: true,
                            onChanged: (val) {
                              isEmpty();
                            }),
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.0.w),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Constants.formBorder),
                                  borderRadius: BorderRadius.circular(5.0),
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
                                            address1 == null
                                                ? 'Location'
                                                : address1!,
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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 3.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Educational Details*',
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
                                  left: 3.0.w, right: 3.0.w, top: 1.5.h),
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
                                                    setState(() {
                                                      educationDetailMap
                                                          .removeAt(index);
                                                    });
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 1.0.w,
                                          right: 1.0.w,
                                          top: 1.0.h),
                                      child: Container(
                                        height: Constants.constHeight,
                                        width: 90.0.w,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            educationDetailMap[index]
                                                    ['school_name'] =
                                                value.toString();
                                            isEmpty();
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Name of School",
                                            labelStyle: TextStyle(
                                                color: Constants.bpSkipStyle,
                                                fontFamily: "Montserrat",
                                                fontSize: 10.0.sp),
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
                                        child: GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      "Select Qualification Year"),
                                                  content: Container(
                                                    width: 75.0.w,
                                                    height: 50.0.h,
                                                    child: YearPicker(
                                                      firstDate: DateTime(
                                                          DateTime(1960).year,
                                                          1),
                                                      lastDate: DateTime(
                                                          DateTime.now().year,
                                                          1),
                                                      selectedDate: DateTime(
                                                          DateTime.now().year),
                                                      onChanged:
                                                          (DateTime dateTime) {
                                                        setState(() {
                                                          isYearSelected = true;
                                                          selectedYear =
                                                              dateTime;
                                                        });
                                                        educationDetailMap[
                                                                index]['year'] =
                                                            selectedYear!.year
                                                                .toString();
                                                        isEmpty();

                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
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
                                                      fontFamily: 'Montserrat',
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
                                                    color: Constants.formBorder,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                    Padding(
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
                                                  horizontal: 1.0.w),
                                              child: Text(
                                                'Qualification',
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
                                            (String value, int dindex) async {
                                          if (int.parse(value) > 0) {
                                            setState(() {
                                              qualification = '1';
                                            });
                                          }
                                          if (value == '1') {
                                            qualification = 'Graduate';
                                            educationDetailMap[index]
                                                ['qualification'] = 'Graduate';
                                          } else if (value == '2') {
                                            qualification = 'Post-graduate';
                                            educationDetailMap[index]
                                                    ['qualification'] =
                                                'Post-graduate';
                                          } else if (value == '3') {
                                            qualification =
                                                'Chartered Accountant';
                                            educationDetailMap[index]
                                                    ['qualification'] =
                                                'Chartered Accountant';
                                          } else {
                                            qualification = 'Others';
                                            educationDetailMap[index]
                                                ['qualification'] = 'Others';
                                          }
                                          isEmpty();
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
                                              _showCertificatePicker(
                                                  context, index);
                                            },
                                            child: Container(
                                              height: Constants.constHeight,
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
                                                        left: 30.0)
                                                    : EdgeInsets.zero,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        _certiName != null
                                                            ? CrossAxisAlignment
                                                                .center
                                                            : CrossAxisAlignment
                                                                .end,
                                                    children: [
                                                      educationDetailMap[index][
                                                                      'certificate'] ==
                                                                  'path' ||
                                                              educationDetailMap[
                                                                          index]
                                                                      [
                                                                      'certificate'] ==
                                                                  'Upload Certificate/Degree'
                                                          ? ImageIcon(
                                                              AssetImage(
                                                                  'assets/icons/upload.png'),
                                                              size: 25,
                                                              color: Constants
                                                                  .formBorder)
                                                          : Container(
                                                              width: 15.0.w,
                                                              decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                      image: FileImage(File(
                                                                          educationDetailMap[index]
                                                                              [
                                                                              'certificate'])),
                                                                      fit: BoxFit
                                                                          .fill)),
                                                            ),
                                                      SizedBox(width: 2.0.w),
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
                                                                      .split(
                                                                          '/')
                                                                      .last
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
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              left: 3.0.w,
                              right: 3.0.w,
                              top: 3.0.h,
                            ),
                            child: GestureDetector(
                              onTap: itemCount >= 5
                                  ? () {
                                      Fluttertoast.showToast(
                                          msg: "You can add only 5 degree",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Constants.bgColor,
                                          textColor: Colors.white,
                                          fontSize: 10.0.sp);
                                    }
                                  : () {
                                      setState(() {
                                        itemCount = itemCount + 1;
                                      });

                                      setState(() {
                                        educationId = educationId + 1;
                                      });
                                      educationDetailMap.add({
                                        'school_name': 'MSU',
                                        'year': 'Year',
                                        'qualification': 'BCA',
                                        'certificate':
                                            'Upload Certificate/Degree'
                                      });
                                    },
                              child: Container(
                                height: Constants.constHeight,
                                width: 90.0.w,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 3.0.w),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Constants.formBorder),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 3.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Work Experience*',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              ],
                            ),
                            onChange: (String value, int index) async {
                              totalWorkExp = int.parse(value);

                              if (int.parse(value) > 0) {
                                setState(() {
                                  workExp = '1';
                                });
                                isEmpty();
                              }
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: Constants.constHeight,
                              width: 90.0.w,
                              elevation: 0,
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
                            left: 3.0.w,
                            right: 3.0.w,
                            top: 3.0.h,
                          ),
                          child: CustomDropdown<int>(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              ],
                            ),
                            onChange: (String value, int index) async {
                              totalTeachExp = int.parse(value);

                              if (int.parse(value) > 0) {
                                setState(() {
                                  teachExp = '1';
                                });
                                isEmpty();
                              }
                            },
                            dropdownButtonStyle: DropdownButtonStyle(
                              height: Constants.constHeight,
                              width: 90.0.w,
                              elevation: 0,
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
                                'Subjects of Expertise*',
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
                                  border:
                                      Border.all(color: Constants.formBorder),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      selectedSubjectList == null ||
                                              selectedSubjectList.length == 0
                                          ? "Please mention your subjects example #subject1 #subject2..."
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
                                  top: 3.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Achievements*',
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
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
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
                                  hintText:
                                      "Please mention your achivements..."),
                              style: new TextStyle(
                                  fontFamily: "Montserrat", fontSize: 10.0.sp),
                              onChanged: (val) {
                                isEmpty();
                              },
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
                                  top: 3.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Skills*',
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
                                    border:
                                        Border.all(color: Constants.formBorder),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    selectedSkillList == null ||
                                            selectedSkillList.length == 0
                                        ? "Please mention your skills example #skills1 #skills2..."
                                        : selectedSkillList
                                            .toString()
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                            .replaceAll(new RegExp(r', '), ' #')
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
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 3.0.h, left: 3.0.w, right: 3.0.w),
                              child: Text(
                                'Hobbies*',
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0.w, vertical: 1.5.h),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Constants.formBorder),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  selectedHobbiesList == null ||
                                          selectedHobbiesList.length == 0
                                      ? "Please mention your hobbies example #hobbie1 #hobbie2..."
                                      : selectedHobbiesList
                                          .toString()
                                          .replaceAll('[', '')
                                          .replaceAll(']', '')
                                          .replaceAll(new RegExp(r', '), ' #')
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
                                  top: 3.0.h, left: 3.0.w, right: 3.0.w),
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
                            textEditingController: _instagramLinkController,
                            lable: 'Instagram'),
                        LinkInputWidget(
                            textEditingController: _linkedInLinkLinkController,
                            lable: 'LinkedIn'),
                        LinkInputWidget(
                            textEditingController: _otherLinkLinkController,
                            lable: 'Other'),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 3.0.w,
                              left: 3.0.w,
                              top: 6.0.h,
                              bottom: 3.0.h),
                          child: GestureDetector(
                              onTap: isButtonEnabled
                                  ? () async {
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
                                      } else if (_image == null) {
                                        Fluttertoast.showToast(
                                            msg: "Please upload profile image",
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
                                            msg:
                                                "Please Select Work Experience",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (teachExp == '0') {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Select Teaching Experience",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (fileName == null ||
                                          fileName == '') {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Pick Selected Document",
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
                                      } else if (selectedSubjectList.length ==
                                          0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please Select Subject Expertise",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else if (selectedSubjectList.length >
                                          25) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "You Can Select Only 25 Subjects",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Constants.bgColor,
                                            textColor: Colors.white,
                                            fontSize: 10.0.sp);
                                      } else {
                                        addEducatorProfile(
                                            registerAs,
                                            _nameController.text,
                                            _mobileController.text,
                                            _emailController.text,
                                            gender,
                                            birthDateInString,
                                            docType,
                                            _document!,
                                            _image!,
                                            _idNumController.text,
                                            address1,
                                            address2,
                                            city,
                                            country,
                                            pinCode,
                                            lat,
                                            lng,
                                            _achivementController.text,
                                            selectedSkillList.toString(),
                                            selectedHobbiesList.toString(),
                                            selectedSubjectList.toString(),
                                            _fbLinkController.text,
                                            _instagramLinkController.text,
                                            _linkedInLinkLinkController.text,
                                            _otherLinkLinkController.text,
                                            totalWorkExp,
                                            totalTeachExp);
                                        updateUserPicCC();
                                      }
                                    }
                                  : null,
                              child: ButtonWidget(
                                  btnName: 'SUBMIT',
                                  isActive: isButtonEnabled,
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

  bool isEmpty() {
    if ((_image != null) &&
        (_nameController.text.isNotEmpty) &&
        (_mobileController.text.isNotEmpty) &&
        (_emailController.text.isNotEmpty) &&
        (gender != 'Gender') &&
        (isDateSelected) &&
        (docType != 'DocType') &&
        (_document != null) &&
        (_idNumController.text.isNotEmpty) &&
        (address1 != null) &&
        (workExp != '0') &&
        (teachExp != '0') &&
        (selectedSubjectList.length != 0) &&
        (educationDetailMap[0]['school_name'] != 'MSU') &&
        (educationDetailMap[0]['year'] != 'Year') &&
        (qualification != '0') &&
        (educationDetailMap[0]['certificate'] != 'Upload Certificate/Degre') &&
        (_achivementController.text.isNotEmpty) &&
        (selectedSkillList.length != 0) &&
        (selectedHobbiesList.length != 0)) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }

    return isButtonEnabled;
  }

  _signInCC(BuildContext context, CubeUser user) async {
    if (!CubeSessionManager.instance.isActiveSessionValid()) {
      try {
        await createSession();
      } catch (error) {
        _processLoginError(error);
      }
    }
    signUp(user).then((newUser) async {
      user.id = newUser.id;
      SharedPrefs sharedPrefs = await SharedPrefs.instance.init();
      sharedPrefs.saveNewUser(user);
      addEducatorProfile(
          registerAs,
          _nameController.text,
          _mobileController.text,
          _emailController.text,
          gender,
          birthDateInString,
          docType,
          _document!,
          _image!,
          _idNumController.text,
          address1,
          address2,
          city,
          country,
          pinCode,
          lat,
          lng,
          _achivementController.text,
          selectedSkillList.toString().replaceAll('[', '').replaceAll(']', ''),
          selectedHobbiesList
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', ''),
          selectedSubjectList
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', ''),
          _fbLinkController.text,
          _instagramLinkController.text,
          _linkedInLinkLinkController.text,
          _otherLinkLinkController.text,
          totalWorkExp,
          totalTeachExp);
    }).catchError((exception) {
      _processLoginError(exception);
    });
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  updateUserPicCC() async {
    File file = File(_image!.path);

    user!.password = '12345678';
    uploadFile(file, isPublic: false).then((cubeFile) {
      user!.avatar = cubeFile.uid;
      return updateUser(user!);
    }).catchError((error) {
    });
    String? avatarUrl = getPrivateUrlForUid(user!.id.toString());
  }

  saveEducationDetails() async {
    final newList = EducationListItemModel(
      file: _certificate,
      school_name: myControllers[0].text.toString(),
      year: selectedYear!.year.toString(),
      qualification: qualification.toString(),
    );
    educationList.add(newList);
  }

  void showPlacePicker() async {
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
    isEmpty();
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
              isEmpty();
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
            isEmpty();
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
            isEmpty();
          }
          Navigator.pop(context);
        });
  }

  getCatSkillHobbieList() async {
    displayProgressDialog(context);

    try {
      Dio dio = Dio();
      var option = Options(headers: {"Authorization": 'Bearer ' + authToken!});
      var response = await Future.wait([
        dio.get(Config.skillListUrl, options: option),
        dio.get(Config.hobbieListUrl, options: option),
        dio.get(Config.getAllSubjectUrl, options: option)
      ]);

      if (response[0].statusCode == 200 &&
          response[1].statusCode == 200 &&
          response[2].statusCode == 200) {
        closeProgressDialog(context);
        skillMap = response[0].data;
        hobbieMap = response[1].data;
        subjectMap = response[2].data;
        setState(() {
          skillMapData = skillMap!['data'];
          hobbieMapData = hobbieMap!['data'];
          subjectMapData = subjectMap!['data'];
        });
      } else {
        closeProgressDialog(context);
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
        } else if (subjectMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: subjectMap!['error_msg'],
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
      if (e.response != null) {}
    }
  }

  Future<ProfileUpdate> addEducatorProfile(
    String? registerAs,
    String name,
    String mobileNumber,
    String email,
    String gender,
    String? dob,
    String documentType,
    XFile documentFile,
    XFile imageFile,
    String idNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? country,
    String? pinCode,
    double? latitude,
    double? longitude,
    String achievements,
    String skills,
    String hobbies,
    String subjects,
    String facbookUrl,
    String instaUrl,
    String linkedinUrl,
    String otherUrl,
    int? totalWorkExp,
    int? totalTeachExp,
  ) async {
    displayProgressDialog(context);
    String docname = documentFile.path.split('/').last;
    String imgname = imageFile.path.split('/').last;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = ProfileUpdate();

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
        'document_file': await MultipartFile.fromFile(
          documentFile.path,
          filename: docname,
        ),
        'image_file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imgname,
        ),
        'identification_document_number': idNumber,
        'location[0][address_line_1]': addressLine1,
        'location[0][city]': city,
        'location[0][country]': country,
        'location[0][pincode]': pinCode,
        'location[0][latitude]': latitude,
        'location[0][longitude]': longitude,
        'location[0][location_type]': 'work',
        'achievements': achievements,
        'skills': skills.replaceAll('[', '').replaceAll(']', ''),
        'hobbies': hobbies.replaceAll('[', '').replaceAll(']', ''),
        'subjects': subjects.replaceAll('[', '').replaceAll(']', ''),
        'facebook_url': facbookUrl,
        'insta_url': instaUrl,
        'linkedin_url': linkedinUrl,
        'other_url': otherUrl,
        'total_work_experience': totalWorkExp,
        'total_teaching_experience': totalTeachExp,
      });

      for (int i = 0; i < educationDetailMap.length; i++) {
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

      var response = await dio.post(
        Config.updateProfileUrl,
        data: formData,
        options: Options(headers: {"Authorization": 'Bearer ' + authToken!}),
      );
      if (response.statusCode == 200) {
        closeProgressDialog(context);
        result = ProfileUpdate.fromJson(response.data);

        if (result.status == true) {
          if (result.data!.isVerified == 'P') {
            closeProgressDialog(context);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VerificationScreen()));
          } else {
            preferences.setString("name", result.data!.name!);
            preferences.setString("imageUrl", result.data!.imageUrl!);
            preferences.setString("mobileNumber", result.data!.mobileNumber!);
            preferences.setString("gender", result.data!.gender!);
            preferences.setString("email", result.data!.email!);
            preferences.setString("qualification",
                result.data!.educationalDetails![0].qualification.toString());
            preferences.setString("schoolName",
                result.data!.educationalDetails![0].schoolName.toString());
            preferences.setString("address1", result.data!.location.toString());
            preferences.setString("address2", result.data!.location.toString());
            preferences.setString(
                "facebookUrl", result.data!.facbookUrl.toString());
            preferences.setString("instaUrl", result.data!.instaUrl.toString());
            preferences.setString(
                "linkedInUrl", result.data!.linkedinUrl.toString());
            preferences.setString("otherUrl", result.data!.otherUrl.toString());

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => bottomNavBar(4)),
                (Route<dynamic> route) => false);
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
            msg: result.errorMsg!,
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
