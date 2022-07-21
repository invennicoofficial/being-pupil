import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class PhotoLoadingWidget extends StatelessWidget {
  const PhotoLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
      width: 100.0.w,
      height: 25.0.h,
      child: Icon(Icons.photo, size: 200, color: Colors.grey,),
      )
    );
  }
}

class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Icon(Icons.person, size: 35, color: Colors.black,),)
    );
  }
}
