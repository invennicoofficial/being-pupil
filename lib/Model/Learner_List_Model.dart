import 'dart:convert';

LearnerListModel learnerListFromJson(String str) =>
    LearnerListModel.fromJson(json.decode(str));

String learnerListToJson(LearnerListModel data) => json.encode(data.toJson());

class LearnerListModel {
  LearnerListModel({
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

  factory LearnerListModel.fromJson(Map<String, dynamic> json) =>
      LearnerListModel(
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
    this.userId,
    this.profileImage,
    this.name,
    this.lastDegree,
    this.schoolName,
    this.date,
    this.distance,
  });

  int? userId;
  String? profileImage;
  String? name;
  dynamic lastDegree;
  dynamic schoolName;
  String? date;
  String? distance;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        profileImage: json["profile_image"],
        name: json["name"],
        lastDegree: json["last_degree"],
        schoolName: json["school_name"],
        date: json["date"],
        distance: json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_image": profileImage,
        "name": name,
        "last_degree": lastDegree,
        "school_name": schoolName,
        "date": date,
        "distance": distance,
      };

  Data.toEmpty(List<dynamic> json) {
    return;
  }
}
