import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class FullScreenSlider extends StatefulWidget {
  List<dynamic> imageList;
  int index;
  String name;

  FullScreenSlider(
      {required this.imageList, required this.index, required this.name});

  @override
  _FullScreenSliderState createState() => _FullScreenSliderState();
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0xFF1E2026),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF1E2026),
        appBar: AppBar(
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
            widget.name,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: "Sofia"),
          ),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Builder(
          builder: (context) {
            final double height = MediaQuery.of(context).size.height;
            return CarouselSlider(
              options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  initialPage: widget.index,
                  enableInfiniteScroll: false),
              items: widget.imageList
                  .map((item) => Container(
                        child: Center(
                          child: PinchZoom(
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      item,
                                      errorListener: () =>
                                          new Icon(Icons.error),
                                    ),
                                    fit: BoxFit.fitWidth),
                              ),
                            ),
                            zoomEnabled: true,
                            resetDuration: const Duration(milliseconds: 150),
                            maxScale: 2.5,
                            onZoomStart: () {},
                            onZoomEnd: () {},
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
