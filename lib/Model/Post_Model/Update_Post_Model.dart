// To parse this JSON data, do
//
//     final updatePost = updatePostFromJson(jsonString);

import 'dart:convert';

UpdatePost updatePostFromJson(String str) => UpdatePost.fromJson(json.decode(str));

String updatePostToJson(UpdatePost data) => json.encode(data.toJson());

class UpdatePost {
    UpdatePost({
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

    factory UpdatePost.fromJson(Map<String, dynamic> json) => UpdatePost(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
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
        this.postId,
        this.description,
        this.totalLikes,
        this.totalComments,
        this.updatedAt,
        this.postMedia,
    });

    int? postId;
    String? description;
    int? totalLikes;
    int? totalComments;
    DateTime? updatedAt;
    List<PostMedia>? postMedia;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        postId: json["post_id"],
        description: json["description"],
        totalLikes: json["total_likes"],
        totalComments: json["total_comments"],
        updatedAt: DateTime.parse(json["updated_at"]),
        postMedia: List<PostMedia>.from(json["post_media"].map((x) => PostMedia.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "post_id": postId,
        "description": description,
        "total_likes": totalLikes,
        "total_comments": totalComments,
        "updated_at": updatedAt!.toIso8601String(),
        "post_media": List<dynamic>.from(postMedia!.map((x) => x.toJson())),
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
