import 'dart:io';

import 'package:being_pupil/Widgets/Bottom_Nav_Bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Update_Post_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';

class UpdatePostScreen extends StatefulWidget {
  String? description;
  Map<int, dynamic>? images;
  int? index, postId;
  UpdatePostScreen(
      {Key? key, this.description, this.postId, this.images, this.index})
      : super(key: key);

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  XFile? _image, _camImage;
  List<XFile>? multiImages;
  String? authToken;
  TextEditingController descriptionController = TextEditingController();
  List<String> filePathList = [];
  List<File> fileList = [];

  String? profilePic, name;
  List<int?> delMedia = [];
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
    descriptionController.text = widget.description!;
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
        children: <ListView>[
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.images![widget.index!].length == 0
                  ? 0
                  : widget.images![widget.index!].length,
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
                                  image: NetworkImage(
                                    widget.images![widget.index!][index]
                                        ['file'],
                                  ),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w, top: 7.0.h),
                      child: GestureDetector(
                        onTap: () {
                          delMedia
                              .add(widget.images![widget.index!][index]['id']);
                          widget.images![widget.index!].removeAt(index);

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
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: fileList.length == 0 ? 0 : fileList.length,
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
                child: FlatButton(
              onPressed: () {
                updatePostApi(descriptionController.text);
              },
              child: Text(
                'Save',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.6)),
              ),
            )),
          ),
        ],
        title: Text(
          'Update Post',
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
                height: 20.0.h,
                width: 90.0.w,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  controller: descriptionController,
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
            SizedBox(
              height: 25.0.h,
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

  Future<UpdatePost> updatePostApi(String description) async {
    displayProgressDialog(context);
    var result = UpdatePost();
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({
        'description': description,
        'post_id': widget.postId,
      });

      for (int i = 0; i < delMedia.length; i++) {
        formData.fields
            .addAll([MapEntry('delete_media[$i]', delMedia[i].toString())]);
      }
      for (int i = 0; i < fileList.length; i++) {
        formData.files.addAll([
          MapEntry(
              "new_media[$i]",
              await MultipartFile.fromFile(fileList[i].path,
                  filename: fileList[i].path.split('/').last)),
        ]);
      }

      var response = await dio.post(Config.updatePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer $authToken'}));

      if (response.statusCode == 200) {
        result = UpdatePost.fromJson(response.data);
        if (result.status == true) {
          closeProgressDialog(context);

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return bottomNavBar(4);
              },
            ),
            (_) => false,
          );
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
