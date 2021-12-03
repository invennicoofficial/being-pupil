// To parse this JSON data, do
//
//     final enrollCourse = enrollCourseFromJson(jsonString);

import 'dart:convert';

EnrollCourse enrollCourseFromJson(String str) => EnrollCourse.fromJson(json.decode(str));

String enrollCourseToJson(EnrollCourse data) => json.encode(data.toJson());

class EnrollCourse {
    EnrollCourse({
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
    Data data;
    dynamic metaParams;

    factory EnrollCourse.fromJson(Map<String, dynamic> json) => EnrollCourse(
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
        "data": data.toJson(),
        "meta_params": metaParams,
    };
}

class Data {
    Data({
        this.status,
        this.courseId,
    });

    int status;
    String courseId;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        courseId: json["course_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "course_id": courseId,
    };
}
