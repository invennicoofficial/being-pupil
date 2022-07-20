import 'package:being_pupil/Constants/Const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class PostWidget extends StatelessWidget {
  //final ScrollController scrollController;
  //final int postCount;
  final int postId;
  void Function() profileTap;
  final String profileImage;
  final String profileName;
  final String profileSchool;
  final String postTime;
  void Function() reportTap;
  String? description;
  Container? imageListView;
  final String mutualLike;
  void Function() likeTap;
  final bool isLiked;
  final String totalLike;
  void Function() commentTap;
  final String totalComments;
  void Function() saveTap;
  final bool isSaved;
  void Function() shareTap;
  PostWidget(
      {Key? key,
      required this.postId,
      required this.profileTap,
      required this.profileImage,
      required this.profileName,
      required this.profileSchool,
      required this.postTime,
      required this.reportTap,
      this.description,
      this.imageListView,
      required this.mutualLike,
      required this.likeTap,
      required this.isLiked,
      required this.totalLike,
      required this.commentTap,
      required this.totalComments,
      required this.saveTap,
      required this.isSaved,
      required this.shareTap
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
              child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  title: GestureDetector(
                    onTap: profileTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: profileImage,
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileName,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Constants.bgColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 1.0),
                              Text(
                                profileSchool,
                                //'${degreeList[index]} | ${schoolList[index]}',
                                style: TextStyle(
                                    fontSize: 9.0,
                                    color: Constants.bgColor,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 1.0),
                              Text(
                                postTime,
                                //dateList[index]!.substring(0, 11),
                                style: TextStyle(
                                    fontSize: 9.0,
                                    color: Constants.bpOnBoardSubtitleStyle,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_horiz_outlined, color: Color(0xFF828282),),
                    //SvgPicture.asset('assets/icons/reportSvg.svg'),
                    onPressed: reportTap,
                  )),
            ),
            //Description
            Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 4.0.w, left: 4.0.w),
              child: Container(
                child: ReadMoreText(description ?? '',
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'See More',
                  trimExpandedText: 'See Less',
                  colorClickableText: Color(0xFF828282),
                  moreStyle: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300),
                    lessStyle: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w300),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF4F4F4F),
                    fontFamily: 'Montserrat',
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            //Images
            SizedBox(
              child: imageListView,
            ),
            

            //Indicator for images

            //Mutual friends like
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0.w),
              child: Container(
                width: 100.0.w,
                child: Text(
                  mutualLike,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF828282),
                    fontFamily: 'Montserrat',
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            //Action row
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0.w),
              child: Column(
                children: [
                  Divider(
                height: 1.0,
                thickness: 0.5,
                color: Color(0xFFE0E0E0),
              ),
              SizedBox(height: 8.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: likeTap,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ImageIcon(
                            isLiked
                                ? AssetImage('assets/icons/likeNew.png',)
                                : AssetImage('assets/icons/likeThumb.png'),
                            color: isLiked
                                ? Constants.selectedIcon
                                : Constants.bpOnBoardSubtitleStyle,
                            size: 25.0,
                          ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Text(
                            totalLike,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF4F4F4F),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: commentTap,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ImageIcon(
                            AssetImage('assets/icons/commentNew.png'),
                            size: 21.0,
                            color: Color(0xFF4F4F4F),
                          ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Text(
                            totalComments,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF4F4F4F),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: saveTap,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ImageIcon(
                            isSaved
                                ? AssetImage('assets/icons/saveGreen.png')
                                : AssetImage('assets/icons/saveNew.png'),
                            color: isSaved
                                ? Constants.selectedIcon
                                : Color(0xFF4F4F4F),
                            size: 21.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: shareTap,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ImageIcon(AssetImage('assets/icons/sharePost.png'),
                            color:  Color(0xFF4F4F4F),
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0,),
              Divider(
                height: 1.0,
                thickness: 0.5,
                color: Color(0xFFE0E0E0),
              ),
                ],
              ),
            ),

            //view all comments
            GestureDetector(
              onTap: (){},
              child: Padding(
                padding: EdgeInsets.only(top: 5.0, left: 4.0.w, right: 4.0.w),
                child: Container(
                  child: Text(
                    "View all 12 comments",
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF333333),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  title: GestureDetector(
                    onTap: profileTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: profileImage,
                              width: 25.0,
                              height: 25.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 2.0.w,
                        ),
                        Container(
                          width: 80.0.w,
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cursus id luctus non feugiat',
                            style: TextStyle(
                                fontSize: 11.0,
                                color: Color(0xFF4F4F4F),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  )),)
          ],
        );
  }
}
