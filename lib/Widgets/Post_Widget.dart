import 'package:being_pupil/Constants/Const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import 'Shimmer_Widget.dart';

class PostWidget extends StatelessWidget {
  final int postId;
  void Function() profileTap;
  final String profileImage;
  final String profileName;
  final String profileSchool;
  final String postTime;
  Widget reportTap;
  String? description;
  Widget? imageListView;
  Widget? indicator;
  final int mutualLike;
  void Function() likeTap;
  final bool isLiked;
  final String totalLike;
  void Function() commentTap;
  final String totalComments;
  void Function() saveTap;
  final bool isSaved;
  void Function() shareTap;
  final bool isCommentScreen;
  bool? isMyProfile;
  bool? iscomment;
  String? commentText;
  String? mutualFriend;
  String? commentImage;
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
      this.indicator,
      required this.mutualLike,
      required this.likeTap,
      required this.isLiked,
      required this.totalLike,
      required this.commentTap,
      required this.totalComments,
      required this.saveTap,
      required this.isSaved,
      required this.shareTap,
      required this.isCommentScreen,
      this.isMyProfile,
      this.iscomment,
      this.commentText,
      this.mutualFriend,
      this.commentImage
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          width: 42.0,
                          height: 42.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ProfileLoadingWidget()
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
                                fontSize: 13.0,
                                color: Constants.bgColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 1.0),
                          Text(
                            profileSchool,
                            style: TextStyle(
                                fontSize: 9.0,
                                color: Constants.bgColor,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 1.0),
                          Row(
                            children: [
                              Text(
                                postTime,
                                style: TextStyle(
                                    fontSize: 9.0,
                                    color: Constants.bpOnBoardSubtitleStyle,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(width: 2.0,),
                              Image.asset('assets/icons/globe.png', height: 12.0, width: 12.0,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              trailing: reportTap,
               ),
        ),
        //Description
        Padding(
          padding: EdgeInsets.only(bottom: 8.0, right: 4.0.w, left: 4.0.w),
          child: Container(
            child: ReadMoreText(
              description ?? '',
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0),
          child: imageListView,
        ),

        //Indicator for images
        Container(
          child: indicator,
        ),

        //Mutual friends like
        int.parse(totalLike) >= 2 && mutualFriend != null
        ? Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0.w),
          child: Container(
            width: 100.0.w,
            child: Text(
              int.parse(totalLike) > 2
              ? '$mutualFriend & ${mutualLike.toString()} other people are liked this post.'
              : int.parse(totalLike) >= 2
              ? '$mutualFriend liked this post.' : '',
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF828282),
                fontFamily: 'Montserrat',
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ) : Padding(padding: EdgeInsets.symmetric(vertical: 2.0),),

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
              SizedBox(
                height: 8.0,
              ),
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
                                ? AssetImage(
                                    'assets/icons/likeNew.png',
                                  )
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
                          ImageIcon(
                            AssetImage('assets/icons/sharePost.png'),
                            color: Color(0xFF4F4F4F),
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Divider(
                height: 1.0,
                thickness: 0.5,
                color: Color(0xFFE0E0E0),
              ),
            ],
          ),
        ),

        //view all comments
        !isCommentScreen
        ? int.parse(totalComments) >= 1
        ? GestureDetector(
          onTap: commentTap,
          child: Padding(
            padding: EdgeInsets.only(top: 5.0, left: 4.0.w, right: 4.0.w),
            child: Container(
              child: Text(
                "View all $totalComments comments",
                style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF333333),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ): SizedBox() : SizedBox(),

        !isCommentScreen && iscomment!
        ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
          child: ListTile(
              contentPadding: EdgeInsets.all(0.0),
              title: GestureDetector(
                onTap: commentTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: commentImage ?? '',
                          width: 25.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ProfileLoadingWidget(),
                           errorWidget: (context, url, error) =>
                                            Material(
                                          child: Image.asset(
                                            'assets/images/studyBudyBg.png',
                                            width: 25.0,
                                            height: 25.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.0.w,
                    ),
                    Container(
                      width: 82.0.w,
                      child: Text(commentText ?? '',
                        style: TextStyle(
                            fontSize: 11.0,
                            color: Color(0xFF4F4F4F),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              )),
        ) : SizedBox()
      ],
    );
  }
}

class CreateDynamicLink{
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? _linkMessage;
    //create dynamic link
createDynamicLink(bool short, String id, int index, String title, String descriprion, String imageUrl) async {
    // setState(() {
     // _isCreatingLink = true;
    // });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bepshare.page.link',
      link: Uri.parse("https://beingpupil.com/public/api/post/$id"),
      androidParameters: const AndroidParameters(
        packageName: 'com.beingPupil',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.beingpupil',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: descriprion,
        imageUrl: Uri.parse(imageUrl)
        // imageListMap[index].isEmpty ? Uri.parse('') :
        // Uri.parse(imageListMap[index][0]['file'].toString()),
      )
    );
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
       url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }
    //setState(() {
      _linkMessage = url.toString();
     // _isCreatingLink = false;
    //});

    Share.share(
      'Check out this post on Being Pupil App! $_linkMessage',
       subject: 'Download Being Pupil App!');
}
}
