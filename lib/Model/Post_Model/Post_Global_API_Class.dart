
import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Post_Model/Get_CommentList_Model.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../Config.dart';

class SavePostAPI {

  Map<String, dynamic>? saveMap;
   //For save, unsave post API
  Future<void> savePostApi(int? postID, String authToken) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.savePostUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        saveMap = response.data;
        //saveMapData = map['data']['status'];

        //print(saveMapData);
        // setState(() {
        //   isLoading = false;
        // });
        if (saveMap!['status'] == true) {
          print('true');
          // map.clear();
          // getSavedPostApi(page);
          Fluttertoast.showToast(
              msg: saveMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
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
        //getEducatorPostApi(page);
        print(saveMap);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }
}

class LikePostAPI{
   Map<String, dynamic>? likeMap;
   bool? isLiked;
   //int likeCounter;
   //For save, unsave post API
  Future<void> likePostApi(int? postID, String authToken) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID});
      var response = await dio.post(Config.postLikeUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        likeMap = response.data;
        //saveMapData = map['data']['status'];

        //print(saveMapData);
        // setState(() {
        //   isLoading = false;
        // });
        if (likeMap!['status'] == true) {
          print('true');
          print(likeMap);
          if(likeMap!['data']['Status'] == 0){
                isLiked = false;
                //likeCounter = likeCounter + 1;
                //print('LIKE:::' + likeCounter.toString());
              }else if(likeMap!['data']['Status'] == 1){
                isLiked = true;
                // likeCounter = likeCounter - 1;
                // print('LIKE:::' + likeCounter.toString());
              }else{}
          // map.clear();
          // getSavedPostApi(page);
          // Fluttertoast.showToast(
          //     msg: likeMap['message'],
          //     backgroundColor: Constants.bgColor,
          //     gravity: ToastGravity.BOTTOM,
          //     fontSize: 10.0.sp,
          //     toastLength: Toast.LENGTH_SHORT,
          //     textColor: Colors.white);
              
        } else {
          print('false');
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
        //getEducatorPostApi(page);
        print(likeMap);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }
}


//API for Add Comment on Post
class CommentAPI{
   Map<String, dynamic>? commentMap;
   GetCommentList commentList = GetCommentList();
   bool isLoading = true;

  Future<void> addCommentApi(int? postID, String comment, String authToken) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'post_id': postID , 'comment': comment});
      var response = await dio.post(Config.addCommentUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {

        commentMap = response.data;
 
        if (commentMap!['status'] == true) {
          print('true');
          print(commentMap);
         
         
          Fluttertoast.showToast(
              msg: commentMap!['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
              
        } else {
          print('false');
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
        //getEducatorPostApi(page);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }

  
}