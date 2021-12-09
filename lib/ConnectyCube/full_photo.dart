
import 'package:being_pupil/ConnectyCube/consts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({Key key, @required this.url}) : super(key: key);

  @override
  State createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key key, @required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/studyBudyBg.png'),
              fit: BoxFit.cover)),
      child:  CachedNetworkImage(
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(
              themeColor),
        ),
        width: 200.0,
        height: 200.0,
        padding: EdgeInsets.all(70.0),
        decoration: BoxDecoration(
          color: greyColor2,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          Material(
            child: Image.asset(
              'assets/images/studyBudyBg.png',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            clipBehavior: Clip.hardEdge,
          ),
      imageUrl: url,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.fitWidth,
    ),);
  }
}
