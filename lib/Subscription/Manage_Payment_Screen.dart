import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ManagePaymentScreen extends StatefulWidget {
  String razorpayLink;
  ManagePaymentScreen({Key? key, required this.razorpayLink}) : super(key: key);

  @override
  State<ManagePaymentScreen> createState() => _ManagePaymentScreenState();
}

class _ManagePaymentScreenState extends State<ManagePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.razorpayLink,
      javascriptMode: JavascriptMode.unrestricted,
      //gestureNavigationEnabled: true,
    );
  }
}
