// To parse this JSON data, do
//
//     final myProfile = myProfileFromJson(jsonString);

import 'dart:convert';

MyProfile myProfileFromJson(String str) => MyProfile.fromJson(json.decode(str));

String myProfileToJson(MyProfile data) => json.encode(data.toJson());

class MyProfile {
    MyProfile({
        this.status,
        this.errorCode,
        this.errorMsg,
        this.message,
        this.data,
        this.metaParams,
    });

    bool? status;
    dynamic errorCode;
    dynamic errorMsg;
    String? message;
    Data? data;
    dynamic metaParams;

    factory MyProfile.fromJson(Map<String, dynamic> json) => MyProfile(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["status"] == true ? Data.fromJson(json["data"]) : new Data.toEmpty(json["data"]),
        metaParams: json["meta_params"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "message": message,
        "data": data!.toJson(),
        "meta_params": metaParams,
    };
}

class Data {
    Data({
        this.userId,
        this.profileImage,
        this.role,
        this.name,
        this.lastDegree,
        this.schoolName,
        this.city,
        this.instagramLink,
        this.facebookLink,
        this.linkedinLink,
        this.otherLink,
        this.totalConnections,
        this.totalPost,
        this.totalExperience,
        this.posts,
    });

    int? userId;
    String? profileImage;
    String? role;
    String? name;
    String? lastDegree;
    String? schoolName;
    String? city;
    String? instagramLink;
    dynamic facebookLink;
    String? linkedinLink;
    String? otherLink;
    int? totalConnections;
    int? totalPost;
    int? totalExperience;
    List<Post>? posts;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        profileImage: json["profile_image"],
        role: json["role"],
        name: json["name"],
        lastDegree: json["last_degree"],
        schoolName: json["school_name"],
        city: json["city"],
        instagramLink: json["instagram_link"],
        facebookLink: json["facebook_link"],
        linkedinLink: json["linkedin_link"],
        otherLink: json["other_link"],
        totalConnections: json["total_connections"],
        totalPost: json["total_post"],
        totalExperience: json["total_experience"],
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_image": profileImage,
        "role": role,
        "name": name,
        "last_degree": lastDegree,
        "school_name": schoolName,
        "city": city,
        "instagram_link": instagramLink,
        "facebook_link": facebookLink,
        "linkedin_link": linkedinLink,
        "other_link": otherLink,
        "total_connections": totalConnections,
        "total_post": totalPost,
        "total_experience": totalExperience,
        "posts": List<dynamic>.from(posts!.map((x) => x.toJson())),
    };

    Data.toEmpty(List<dynamic>? json){
      return;
    }
}

class Post {
    Post({
        this.postId,
        this.postUserId,
        this.profileImage,
        this.name,
        this.lastDegree,
        this.schoolName,
        this.date,
        this.description,
        this.postMedia,
        this.totalLikes,
        this.totalComments,
        this.distance,
    });

    int? postId;
    int? postUserId;
    String? profileImage;
    String? name;
    String? lastDegree;
    String? schoolName;
    String? date;
    String? description;
    List<PostMedia>? postMedia;
    int? totalLikes;
    int? totalComments;
    String? distance;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
        postUserId: json["post_user_id"],
        profileImage: json["profile_image"],
        name: json["name"],
        lastDegree: json["last_degree"],
        schoolName: json["school_name"],
        date: json["date"],
        description: json["description"],
        postMedia: List<PostMedia>.from(json["post_media"].map((x) => PostMedia.fromJson(x))),
        totalLikes: json["total_likes"],
        totalComments: json["total_comments"],
        distance: json["distance"],
    );

    Map<String, dynamic> toJson() => {
        "post_id": postId,
        "post_user_id": postUserId,
        "profile_image": profileImage,
        "name": name,
        "last_degree": lastDegree,
        "school_name": schoolName,
        "date": date,
        "description": description,
        "post_media": List<dynamic>.from(postMedia!.map((x) => x.toJson())),
        "total_likes": totalLikes,
        "total_comments": totalComments,
        "distance": distance,
    };
}

class PostMedia {
    PostMedia({
        this.id,
        this.file,
    });

    int? id;
    String? file;

    factory PostMedia.fromJson(Map<String, dynamic> json) => PostMedia(
        id: json["id"],
        file: json["file"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
    };
}
