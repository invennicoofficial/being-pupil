import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConnectionAPI {
  Map<String, dynamic> map;
  bool status;

  //For save, unsave post API
  Future<void> connectionApi(int userId, String authToken) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData = FormData.fromMap({'request_to_id': userId});
      var response = await dio.post(Config.connectionUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        map = response.data;
        //saveMapData = map['data']['status'];

        //print(saveMapData);
        // setState(() {
        //   isLoading = false;
        // });
        if (map['status'] == true) {
          print('true');
          print(map);
          if (map['data']['Status'] == 1) {
            status = true;
          } else {
            status = false;
          }
          // getSavedPostApi(page);
          Fluttertoast.showToast(
              msg: map['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
          if (map['message'] == null) {
            Fluttertoast.showToast(
                msg: map['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: map['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
        //getEducatorPostApi(page);
        print(map);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }
}
