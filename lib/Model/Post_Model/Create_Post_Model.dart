import 'dart:convert';

// CreatePost welcomeFromJson(String str) => CreatePost.fromJson(json.decode(str));

// String welcomeToJson(CreatePost data) => json.encode(data.toJson());

class CreatePost {
    CreatePost({
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

    factory CreatePost.fromJson(Map<String, dynamic> json) => CreatePost(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["status"] == true ? Data.fromJson(json["data"]) : null,
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
        this.createdAt,
        this.postMedia,
    });

    int? postId;
    String? description;
    int? totalLikes;
    int? totalComments;
    DateTime? createdAt;
    List<dynamic>? postMedia;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        postId: json["post_id"],
        description: json["description"],
        totalLikes: json["total_likes"],
        totalComments: json["total_comments"],
        createdAt: DateTime.parse(json["created_at"]),
        postMedia: List<dynamic>.from(json["post_media"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "post_id": postId,
        "description": description,
        "total_likes": totalLikes,
        "total_comments": totalComments,
        "created_at": createdAt!.toIso8601String(),
        "post_media": List<dynamic>.from(postMedia!.map((x) => x)),
    };
}
