import 'dart:io';
import 'dart:typed_data';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Create_Post_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File _image;
  String authToken;
  TextEditingController descriptionController = TextEditingController();
  List<String> filePathList = [];
  List<File> fileList = [];

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
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

  getMultipleImage() async {
    List<AssetEntity> assets = <AssetEntity>[];

    final List<AssetEntity> result = await AssetPicker.pickAssets(
      context,
      maxAssets: 10,
      pageSize: 320,
      pathThumbSize: 80,
      gridCount: 4,
      requestType: RequestType.image,
      selectedAssets: assets,
      // themeColor: Colors.cyan,
      // pickerTheme: ThemeData
      //     .dark(), // This cannot be set when the `themeColor` was provided.
      textDelegate: EnglishTextDelegate(),
      sortPathDelegate: CommonSortPathDelegate(),
      routeCurve: Curves.easeIn,
      routeDuration: const Duration(milliseconds: 500),
    );

    setState(() {
      // _image = result.length.
    });

    for (int i = 0; i < result.length; i++) {
      print('$i : ' + result[i].title);
      filePathList.add(result[i].relativePath + '/' + result[i].title);
      fileList.add(
          new File('${result[i].relativePath}' + '/' + '${result[i].title}'));
    }
    print(filePathList);
    print(fileList);
    print(result[0].relativePath + result[0].title);

    final File file =
        File('${result[0].relativePath}' + '/' + '${result[0].title}');
    print('FILE:::' + file.path);

    AssetPicker.registerObserve();
  }

  // _videoFile() async {
  //   File image = (await ImagePicker.pickVideo(
  //       source: ImageSource.gallery));

  //   setState(() {
  //     _image = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                createPostApi(descriptionController.text);
                //print(_image.path);
              },
              child: Text(
                'Post',
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
                  child: Image.asset(
                    'assets/images/educatorDP.png',
                    width: 8.5.w,
                    height: 5.0.h,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  "Marilyn Brewer",
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
                  //maxLength: 500,
                  maxLines: 5,
                  controller: descriptionController,
                  // decoration: InputDecoration(
                  //                   //labelText: "Please mention your achivements...",
                  //                   //counterText: '',
                  //                   fillColor: Colors.white,
                  //                   focusedBorder: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(5.0),
                  //                     borderSide: BorderSide(
                  //                       color: Constants.formBorder,
                  //                     ),
                  //                   ),
                  //                   enabledBorder: OutlineInputBorder(
                  //                     borderRadius: BorderRadius.circular(5.0),
                  //                     borderSide: BorderSide(
                  //                       color: Constants.formBorder,
                  //                       //width: 2.0,
                  //                     ),
                  //                   ),
                  //                   ),
                  decoration: InputDecoration(
                      counterText: '',
                      fillColor: Colors.white,
                      hintText: "What's on your mind ?",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.white12
                            //width: 2.0,
                            ),
                      ),
                      disabledBorder: InputBorder.none),
                  style: new TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 10.0.sp,
                      color: Color(0xFF6B737C)),
                ),
              ),
              //  Text(
              //   "What's on your mind ?",
              //   style: TextStyle(
              //       fontSize: 12.0.sp,
              //       color: Color(0xFF6B737C),
              //       fontFamily: 'Montserrat',
              //       fontWeight: FontWeight.w400),
              // ),
            ),
            SizedBox(
              height: 52.0.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print('Camera');
                      _imageFromCamera();
                    },
                    child: ImageIcon(
                      AssetImage('assets/icons/cameraIcon.png'),
                      size: 22.0,
                      color: Constants.formBorder,
                    ),
                  ),
                  // SizedBox(
                  //   width: 2.5.w,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     print('Video');
                  //     _videoFile();
                  //   },
                  //   child: ImageIcon(
                  //     AssetImage('assets/icons/videoCam.png'),
                  //     size: 25.0,
                  //     color: Constants.formBorder,
                  //   ),
                  // ),
                  SizedBox(
                    width: 2.5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Gallery');
                      //_imageFromGallery();
                      getMultipleImage();
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

  //Create Post API
  Future<CreatePost> createPostApi(String description) async {
    displayProgressDialog(context);
    var result = CreatePost();
    try {
      Dio dio = Dio();
      // for (int i = 0; i < fileList.length; i++) {
      //   MultipartFile.fromFile(filePathList[i],
      //       filename: filePathList[i].split('/').last);
      // }

    // List<MultipartFile> imageList = new List<MultipartFile>();

    //   for(File file in images) {
    //     Uint8List byteData = await file.readAsBytes();
    //     //AssetEntity imageEntity = await PhotoManager.editor.saveImage(byteData);
    //     List<int> imageData = byteData.buffer.asUint8List();
    //     MultipartFile multipartFile = new MultipartFile.fromBytes(
    //       imageData,
    //       filename: 'load_image',
    //       contentType: MediaType("image", "jpg"),
    //     );
    //     imageList.add(multipartFile);
    //   }

      //print(imageList[0].filename);

      FormData formData = FormData.fromMap({
        'description': description,
        //'post_media[]': imageList
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
        print(response.data);
        result = CreatePost.fromJson(response.data);
        if (result.status == true) {
          closeProgressDialog(context);
          //close after successful post creation
          Navigator.of(context).pop();
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
          closeProgressDialog(context);
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
