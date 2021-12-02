// To parse this JSON data, do
//
//     final createCourse = createCourseFromJson(jsonString);

import 'dart:convert';

CreateCourse createCourseFromJson(String str) => CreateCourse.fromJson(json.decode(str));

String createCourseToJson(CreateCourse data) => json.encode(data.toJson());

class CreateCourse {
    CreateCourse({
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

    factory CreateCourse.fromJson(Map<String, dynamic> json) => CreateCourse(
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
    int courseId;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        courseId: json["course_id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "course_id": courseId,
    };
}
