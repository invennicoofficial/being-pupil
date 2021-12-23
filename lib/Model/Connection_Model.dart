// To parse this JSON data, do
//
//     final connection = connectionFromJson(jsonString);

import 'dart:convert';

Connection connectionFromJson(String str) => Connection.fromJson(json.decode(str));

String connectionToJson(Connection data) => json.encode(data.toJson());

class Connection {
    Connection({
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

    factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["status"] == true ? List<Data>.from(json["data"].map((x) => Data.fromJson(x))) : new Data.toEmpty(json['data']) as List<Data>?,
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
        this.userId,
        this.profileImage,
        this.name,
        this.email,
        this.lastDegree,
        this.schoolName,
        this.date,
        this.status,
    });

    int? userId;
    String? profileImage;
    String? name;
    String? email;
    String? lastDegree;
    String? schoolName;
    String? date;
    String? status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        profileImage: json["profile_image"],
        name: json["name"],
        email: json["email"],
        lastDegree: json["last_degree"],
        schoolName: json["school_name"],
        date: json["date"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_image": profileImage,
        "name": name,
        "email": email,
        "last_degree": lastDegree,
        "school_name": schoolName,
        "date": date,
        "status": status,
    };

    Data.toEmpty(Map<String, dynamic>? json){
      return;
    }
}
