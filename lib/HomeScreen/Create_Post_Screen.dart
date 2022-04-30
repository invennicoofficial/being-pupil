import 'dart:io';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Post_Model/Create_Post_Model.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;
//import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
  //List<AssetEntity> assets = <AssetEntity>[];
  String? profilePic, name;
  final ImagePicker _picker = ImagePicker();
  //List<AssetEntity>? result;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    //print(authToken);
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
    //print('LENGTH::: ${fileList.length}');
  }

  _imageFromGallery() async {
    // XFile? image = (await _picker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 50));

    List<XFile>? images = await _picker.pickMultiImage(imageQuality: 50);

    setState(() {
      // _image = image;
      multiImages = images;
    });
    for (int i = 0; i < multiImages!.length; i++) {
      fileList.add(new File(multiImages![i].path));
    }
    //print(multiImages![0].path);
  }

  // getMultipleImage() async {
  //   result = await AssetPicker.pickAssets(
  //     context,
  //     maxAssets: 10,
  //     pageSize: 320,
  //     pathThumbSize: 80,
  //     gridCount: 4,
  //     requestType: RequestType.image,
  //     selectedAssets: assets,
  //     // themeColor: Colors.cyan,
  //     // pickerTheme: ThemeData
  //     //     .dark(), // This cannot be set when the `themeColor` was provided.
  //     textDelegate: EnglishTextDelegate(),
  //     sortPathDelegate: CommonSortPathDelegate(),
  //     routeCurve: Curves.easeIn,
  //     routeDuration: const Duration(milliseconds: 500),
  //   );

  //   setState(() {
  //     // _image = result.length.
  //   });
  //   print('ASSETS::: $assets');
  //   for (int i = 0; i < result!.length; i++) {
  //     print('$i : ' + result![i].title!);
  //     filePathList.add(result![i].relativePath! + result![i].title!);
  //     fileList.add(
  //         new File('${result![i].relativePath}' + '/' + '${result![i].title}'));
  //   }
  //   print(filePathList);
  //   print(fileList);
  //   print(result![0].relativePath! + result![0].title!);

  //   final File file =
  //       File('${result![0].relativePath}' + '/' + '${result![0].title}');
  //   print('FILE:::' + file.path);

  //   AssetPicker.registerObserve();
  // }

  // _videoFile() async {
  //   File image = (await ImagePicker.pickVideo(
  //       source: ImageSource.gallery));

  //   setState(() {
  //     _image = image;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var imageView = Container(
      height: 22.0.h,
      //width: 100.0.w,
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
                                  //AssetEntityImageProvider(assets[index], isOriginal: false),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w, top: 7.0.h),
                      child: GestureDetector(
                        onTap: () {
                          //print('Icon Pressssss.....');
                          //fileList[index].delete();
                          fileList.removeAt(index);
                          setState(() {});
                          //print(fileList);
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
                  //|| fileList.length == 0
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
                        //print(_image.path);
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
                          // || fileList.length == 0
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
                  child: Image.network(
                    profilePic!,
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
                //height: 70.0.h,
                width: 90.0.w,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  //maxLength: 500,
                  maxLines: 25,
                  controller: descriptionController,
                  onChanged: (value) {
                    setState(() {
                      //descriptionController.text = value;
                    });
                  },
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
            // SizedBox(
            //   height: 20.0.h,
            // ),
            imageView,
            //SizedBox(height: 7.0.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      //print('Camera');
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
                      //print('Gallery');
                      _imageFromGallery();
                      //getMultipleImage();
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
        //print(response.data);
        result = CreatePost.fromJson(response.data);
        if (result.status == true) {
          closeProgressDialog(context);
          //close after successful post creation
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
      //print(e.response);
      //print(stack);
      closeProgressDialog(context);
      if (e.response != null) {
        //print("This is the error message::::" +
          //  e.response!.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        //print(e.request);
        //print(e.message);
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
