import 'package:being_pupil/Model/Config.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:being_pupil/Constants/Const.dart';
import 'package:dio/dio.dart';

class TermsAndPolicyScreen extends StatefulWidget {
  const TermsAndPolicyScreen({
    Key? key,
  }) : super(key: key);
  @override
  _TermsAndPolicyScreenState createState() => _TermsAndPolicyScreenState();
}

class _TermsAndPolicyScreenState extends State<TermsAndPolicyScreen> {
  Map<String, dynamic> map = Map<String, dynamic>();
  String? link;
  bool isLinkLoading = true;
  final _key = UniqueKey();

  initState() {
    super.initState();
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
            'Terms & Policy',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12.0.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        body: WebView(
          key: _key,
          initialUrl: 'https://beingpupil.com/terms-and-conditions',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }

  Future<void> getTearmsLink() async {
    var dio = Dio();

    try {
      var response = await dio.get(Config.tearmsUrl);

      if (response.statusCode == 200) {
        map = response.data;
        if (map['status'] == true) {
          link = map['data']['link'];
          isLinkLoading = false;
          setState(() {});
        } else {
          isLinkLoading = false;
          link = 'https://beingpupil.com/terms-and-conditions';
          setState(() {});
        }
      } else {
        isLinkLoading = false;
        link = 'https://beingpupil.com/terms-and-conditions';
        setState(() {});
      }
    } on DioError catch (e, sacktrace) {
      isLinkLoading = false;
      link = 'https://beingpupil.com/terms-and-conditions';
      setState(() {});
    }
  }
}
