import 'dart:convert';

//EducatorPost educatorPostFromJson(String str) => EducatorPost.fromJson(json.decode(str));

//String educatorPostToJson(EducatorPost data) => json.encode(data.toJson());

class EducatorPost {
    EducatorPost({
        this.status,
        this.errorCode,
        this.errorMsg,
        this.message,
        this.data,
        this.metaParams,
    });

    bool status;
    dynamic errorCode;
    dynamic errorMsg;
    String message;
    Map<dynamic, dynamic> data;
    dynamic metaParams;

    factory EducatorPost.fromJson(Map<String, dynamic> json) => EducatorPost(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["status"] == true ? Map<dynamic, dynamic>.from(json["data"].map((x) => Data.fromJson(x))) : null,
        metaParams: json["meta_params"],
    );

    // _parseData(List<dynamic> data){
    //   List<Data> result = new List<Data>();
    //   data.forEach((element) {result.add(Data.fromJson(element));
    //   });
    //   return result;

    // }

    Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "message": message,
        "data": Map<dynamic, dynamic>.from(data.map((x,_) => x.toJson())),
        "meta_params": metaParams,
    };
}

class Data {
    Data({
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
    });

    int postId;
    int postUserId;
    String profileImage;
    String name;
    String lastDegree;
    String schoolName;
    String date;
    String description;
    List<PostMedia> postMedia;
    int totalLikes;
    int totalComments;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        "post_media": List<dynamic>.from(postMedia.map((x) => x.toJson())),
        "total_likes": totalLikes,
        "total_comments": totalComments,
    };
}

class PostMedia {
    PostMedia({
        this.id,
        this.file,
    });

    int id;
    String file;

    factory PostMedia.fromJson(Map<String, dynamic> json) => PostMedia(
        id: json["id"],
        file: json["file"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file": file,
    };
}
