import 'dart:io';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Create_Post_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  XFile? _image, _camImage;
  List<XFile>? multiImages;
  String? authToken;
  TextEditingController descriptionController = TextEditingController();
  List<String> filePathList = [];
  List<File> fileList = [];

  String? profilePic, name;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      profilePic = preferences.getString('imageUrl');
      name = preferences.getString('name');
    });
  }

  _imageFromCamera() async {
    XFile? image =
        (await _picker.pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _camImage = image;
      fileList.add(new File(_camImage!.path));
    });
  }

  _imageFromGallery() async {
    List<XFile>? images = await _picker.pickMultiImage(imageQuality: 50);

    setState(() {
      multiImages = images;
    });
    for (int i = 0; i < multiImages!.length; i++) {
      fileList.add(new File(multiImages![i].path));
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageView = Container(
      height: 22.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: fileList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                      child: Center(
                        child: Container(
                          height: 8.0.h,
                          width: 15.0.w,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(fileList[index]),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w, top: 7.0.h),
                      child: GestureDetector(
                        onTap: () {
                          fileList.removeAt(index);
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 10.0,
                          backgroundColor: Constants.bgColor,
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 0.0.w),
            child: Center(
                child: TextButton(
              onPressed: descriptionController.text == ''
                  ? null
                  : () {
                      if (fileList.length > 10) {
                        Fluttertoast.showToast(
                          msg: 'Media should be less then 10',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Constants.bgColor,
                          textColor: Colors.white,
                          fontSize: 10.0.sp,
                        );
                      } else {
                        createPostApi(descriptionController.text);
                      }
                    },
              child: Text('Post',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0.sp,
                      fontWeight: FontWeight.w500,
                      color: descriptionController.text == ''
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white)),
            )),
          ),
        ],
        title: Text(
          'Create Post',
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
              child: ListTile(
                contentPadding: EdgeInsets.all(0.0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: profilePic!,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  name!,
                  style: TextStyle(
                      fontSize: 9.0.sp,
                      color: Constants.bgColor,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.0.w,
              ),
              child: Container(
                width: 90.0.w,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 25,
                  controller: descriptionController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      counterText: '',
                      fillColor: Colors.white,
                      hintText: "What's on your mind ?",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.white12),
                      ),
                      disabledBorder: InputBorder.none),
                  style: new TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 10.0.sp,
                      color: Color(0xFF6B737C)),
                ),
              ),
            ),
            imageView,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _imageFromCamera();
                    },
                    child: ImageIcon(
                      AssetImage('assets/icons/cameraIcon.png'),
                      size: 22.0,
                      color: Constants.formBorder,
                    ),
                  ),
                  SizedBox(
                    width: 2.5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      _imageFromGallery();
                    },
                    child: ImageIcon(
                      AssetImage('assets/icons/galleryIcon.png'),
                      size: 22.0,
                      color: Constants.formBorder,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<CreatePost> createPostApi(String description) async {
    displayProgressDialog(context);
    var result = CreatePost();
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'description': description,
      });

      for (int i = 0; i < fileList.length; i++) {
        formData.files.addAll([
          MapEntry(
              "post_media[$i]",
              await MultipartFile.fromFile(fileList[i].path,
                  filename: fileList[i].path.split('/').last)),
        ]);
      }

      var response = await dio.post(Config.createPostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer $authToken'}));

      if (response.statusCode == 200) {
        result = CreatePost.fromJson(response.data);
        if (result.status == true) {
          closeProgressDialog(context);

          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: result.message!,
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
            msg: result.message == null ? result.errorMsg : result.message!,
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
