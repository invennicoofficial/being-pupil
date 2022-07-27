import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Post_Model/Get_CommentList_Model.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../Config.dart';

class SavePostAPI {
  Map<String, dynamic>? saveMap;

  Future<void> savePostApi(int? postID, String authToken) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.savePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        saveMap = response.data;

        if (saveMap!['status'] == true) {
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          if (saveMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: saveMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: saveMap!['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
      } else {}
    } on DioError catch (e, stack) {}
  }
}

class LikePostAPI {
  Map<String, dynamic>? likeMap;
  bool? isLiked;
  int likeCount = 0;

  Future<void> likePostApi(int? postID, String authToken) async {
    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.postLikeUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        likeMap = response.data;

        if (likeMap!['status'] == true) {
          likeCount = likeMap!['data']['Status'];

          if (likeMap!['data']['message'] == 'post unliked.') {
            isLiked = false;
          } else if (likeMap!['data']['message'] == 'post liked.') {
            isLiked = true;
          } else {}
        } else {
          if (likeMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: likeMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: likeMap!['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
      } else {}
    } on DioError catch (e, stack) {}
  }
}

class CommentAPI {
  Map<String, dynamic>? commentMap;
  GetCommentList commentList = GetCommentList();
  bool isLoading = true;
  int commentCount = 0;

  Future<void> addCommentApi(
      int? postID, String comment, String authToken) async {
    try {
      Dio dio = Dio();

      FormData formData =
          FormData.fromMap({'post_id': postID, 'comment': comment});
      var response = await dio.post(Config.addCommentUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        commentMap = response.data;

        if (commentMap!['status'] == true) {
          commentCount = commentMap!['data']['total_comments'];

          Fluttertoast.showToast(
              msg: commentMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          if (commentMap!['message'] == null) {
            Fluttertoast.showToast(
                msg: commentMap!['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: commentMap!['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
      } else {}
    } on DioError catch (e, stack) {}
  }
}
