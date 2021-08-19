import 'dart:io';

import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({Key key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
   File _image;

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

  _videoFile() async {
    File image = (await ImagePicker.pickVideo(
        source: ImageSource.gallery));

    setState(() {
      _image = image;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Constants.bgColor,
        leading: 
        IconButton(
          icon: Icon(
            Icons.west_rounded,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: //null,
              () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 3.0.w),
            child: Center(
              child: Text(
                'Post',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.6)),
              ),
            ),
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
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLength: 500,
                decoration: InputDecoration(
                    //labelText: "Please mention your achivements...",
                    counterText: '',
                    fillColor: Colors.white,
                    hintText: "What's on your mind ?",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none),
                style: new TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 10.0.sp,
                    color: Color(0xFF6B737C)),
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
              height: 65.0.h,
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
                  SizedBox(
                    width: 2.5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Video');
                      _videoFile();
                    },
                    child: ImageIcon(
                      AssetImage('assets/icons/videoCam.png'),
                      size: 25.0,
                      color: Constants.formBorder,
                    ),
                  ),
                  SizedBox(
                    width: 2.5.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Gallery');
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
}
