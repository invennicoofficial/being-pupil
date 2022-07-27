import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Widgets/Common_Widgets.dart';

import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class ReportFeed extends StatefulWidget {
  final int? postId;
  const ReportFeed({Key? key, required this.postId}) : super(key: key);

  @override
  _ReportFeedState createState() => _ReportFeedState();
}

class _ReportFeedState extends State<ReportFeed> {
  bool isOther = false;
  TextEditingController _detailController = TextEditingController();
  Map<String, dynamic>? reportMap = Map<String, dynamic>();
  List<dynamic>? reportMapData = [];
  int? selectedIssue;
  String? authToken;
  int? issueId;
  bool isLoading = true;
  bool isButtonActive = false;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');

    getReportIssueList();
  }

  Widget detailedBox() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.0.h, left: 3.0.w, right: 3.0.w),
              child: Text(
                'Detailed Description',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0.sp,
                    color: Constants.bgColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        MultilineTextInput(
          textEditingController: _detailController,
          hint: 'Add Detailed Description',
          onChange: (val) {
            isEmpty();
          },
        )
      ],
    );
  }

  bool isEmpty() {
    if ((selectedIssue != null) && (!isOther)) {
      setState(() {
        isButtonActive = true;
      });
    } else if ((selectedIssue != null) &&
        (isOther) &&
        (_detailController.text.isNotEmpty)) {
      setState(() {
        isButtonActive = true;
      });
    } else {
      setState(() {
        isButtonActive = false;
      });
    }
    return isButtonActive;
  }

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
        title: Text(
          'Report Issue',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constants.bgColor),
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.separated(
                      itemCount: reportMapData!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 4.0.w),
                          groupValue: selectedIssue == index ? 1 : 0,
                          value: 1,
                          controlAffinity: ListTileControlAffinity.trailing,
                          selected: false,
                          activeColor: Constants.selectedIcon,
                          onChanged: (val) {
                            setState(() {
                              selectedIssue = index;
                              issueId = index + 1;
                              reportMapData![index]['name'] == 'Others'
                                  ? isOther = true
                                  : isOther = false;
                            });
                            isEmpty();
                          },
                          title: Text(
                            '${reportMapData![index]['name']}',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Constants.bgColor),
                          ),
                          subtitle: Text(
                            'Ex: includes racist, homophobic or sexist slurs',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF828282)),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1.0,
                          color: Color(0xFFE0E0E0),
                          thickness: 0.5,
                        );
                      }),
                  isOther ? detailedBox() : Container(),
                  SizedBox(
                    height: 3.0.h,
                  ),
                  InkWell(
                      onTap: () {
                        if (selectedIssue == null) {
                          Fluttertoast.showToast(
                            msg: "Select Issue for Report",
                            fontSize: 10.0.sp,
                            backgroundColor: Constants.bgColor,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        } else {
                          reportIssueOnPost(widget.postId, issueId);
                        }
                      },
                      child: ButtonWidget(
                          btnName: 'SUBMIT',
                          isActive: isButtonActive,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
    );
  }

  getReportIssueList() async {
    try {
      Dio dio = Dio();
      var response = await dio.get(Config.getReportIssueListUrl);

      if (response.statusCode == 200) {
        reportMap = response.data;
        setState(() {
          reportMapData = reportMap!['data'];
        });

        isLoading = false;
        setState(() {});
      } else {}
    } on DioError catch (e, stack) {
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
      }
    }
  }

  reportIssueOnPost(int? postId, int? issueId) async {
    displayProgressDialog(context);

    Map<String, dynamic>? map = Map<String, dynamic>();
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'post_id': postId,
        'issue_id': issueId,
        'description': reportMapData![selectedIssue!]['name'] == 'Others'
            ? _detailController.text
            : null
      });

      var response = await dio.post(Config.reportIssueUrl,
          data: formData,
          options: Options(headers: {
            "Authorization": 'Bearer $authToken',
          }));

      if (response.statusCode == 200) {
        closeProgressDialog(context);

        map = response.data;

        if (map!['status'] == true) {
          Fluttertoast.showToast(
            msg: map['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );

          Navigator.pop(context, true);
        } else {
          Fluttertoast.showToast(
            msg: map['message'] == null ? map['error_msg'] : map['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      } else {}
    } on DioError catch (e, stack) {
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
  }

  displayProgressDialog(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).push(new PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return new ProgressDialog();
          }));
    });
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
