// To parse this JSON data, do
//
//     final DiscontinueCourse = enrollCourseFromJson(jsonString);

import 'dart:convert';

DiscontinueCourse enrollCourseFromJson(String str) => DiscontinueCourse.fromJson(json.decode(str));

String enrollCourseToJson(DiscontinueCourse data) => json.encode(data.toJson());

class DiscontinueCourse {
    DiscontinueCourse({
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

    factory DiscontinueCourse.fromJson(Map<String, dynamic> json) => DiscontinueCourse(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["data"] != null
        ? Data.fromJson(json["data"])
        : null,
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
        this.status,
        this.courseId,
    });

    int? status;
    String? courseId;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        courseId: json["course_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "course_id": courseId,
    };
}
