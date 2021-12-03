// To parse this JSON data, do
//
//     final GetEducatorCourse = GetEducatorCourseFromJson(jsonString);

import 'dart:convert';

GetEducatorCourse getEducatorCourseFromJson(String str) => GetEducatorCourse.fromJson(json.decode(str));

String getEducatorCourseToJson(GetEducatorCourse data) => json.encode(data.toJson());

class GetEducatorCourse {
    GetEducatorCourse({
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
    List<Data> data;
    dynamic metaParams;

    factory GetEducatorCourse.fromJson(Map<String, dynamic> json) => GetEducatorCourse(
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
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta_params": metaParams,
    };
}

class Data {
    Data({
        this.courseId,
        this.courseName,
        this.courseDescription,
        this.startDate,
        this.endDate,
        this.courseLink,
        this.status,
    });

    int courseId;
    String courseName;
    String courseDescription;
    String startDate;
    String endDate;
    List<String> courseLink;
    int status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        courseId: json["course_id"],
        courseName: json["course_name"],
        courseDescription: json["course_description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        courseLink: List<String>.from(json["course_link"].map((x) => x)),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "course_id": courseId,
        "course_name": courseName,
        "course_description": courseDescription,
        "start_date": startDate,
        "end_date": endDate,
        "course_link": List<dynamic>.from(courseLink.map((x) => x)),
        "status": status,
    };
}
