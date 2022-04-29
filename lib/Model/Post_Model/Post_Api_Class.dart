import 'dart:convert';

import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

class PostApi{
  //API for get All report list
  Map<String, dynamic>? reportMap = Map<String, dynamic>();
  List<dynamic>? reportMapData = [];//List<dynamic>();
  
   getReportIssueList() async{
    //displayProgressDialog(context);
    //var result = ReportIssue();
    try{
      Dio dio = Dio();
      var response = await dio.get(Config.getReportIssueListUrl);
      //print(response.statusCode);

      if(response.statusCode == 200){
        //closeProgressDialog(context);
        //result = reportIssueFromJson(response.data);
        reportMap = response.data;
        reportMapData = reportMap!['data'];
        //print(reportMap);
        //return ReportIssue.fromJson(json.decode(response.data));
      }else{
        //print('NOT OK');
      }
    } on DioError catch(e, stack){
      //print(e.response);
      //print(stack);
      if (e.response != null) {
        //print("This is the error message::::" +
            //e.response!.data['meta']['message']);
        Fluttertoast.showToast(
          msg: e.response!.data['meta']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Constants.bgColor,
          textColor: Colors.white,
          fontSize: 10.0.sp,
        );
      }
    }
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