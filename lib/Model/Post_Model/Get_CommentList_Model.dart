// To parse this JSON data, do
//
//     final getCommentList = getCommentListFromJson(jsonString);

import 'dart:convert';

GetCommentList getCommentListFromJson(String str) => GetCommentList.fromJson(json.decode(str));

String getCommentListToJson(GetCommentList data) => json.encode(data.toJson());

class GetCommentList {
    GetCommentList({
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
    List<Data>? data;
    dynamic metaParams;

    factory GetCommentList.fromJson(Map<String, dynamic> json) => GetCommentList(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        metaParams: json["meta_params"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta_params": metaParams,
    };
}

class Data {
    Data({
        this.commentId,
        this.commentUserId,
        this.profileImage,
        this.name,
        this.date,
        this.comment,
        this.postId,
        this.totalComments,
    });

    int? commentId;
    String? commentUserId;
    String? profileImage;
    String? name;
    String? date;
    String? comment;
    int? postId;
    int? totalComments;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        commentId: json["comment_id"],
        commentUserId: json["comment_user_id"],
        profileImage: json["profile_image"],
        name: json["name"],
        date: json["date"],
        comment: json["comment"],
        postId: json["post_id"],
        totalComments: json["total_comments"],
    );

    Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "comment_user_id": commentUserId,
        "profile_image": profileImage,
        "name": name,
        "date": date,
        "comment": comment,
        "post_id": postId,
        "total_comments": totalComments,
    };
}
