// To parse this JSON data, do
//
//     final verifySubscription = verifySubscriptionFromJson(jsonString);

import 'dart:convert';

class VerifySubscription {
  VerifySubscription({
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

  factory VerifySubscription.fromRawJson(String str) =>
      VerifySubscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifySubscription.fromJson(Map<String, dynamic> json) =>
      VerifySubscription(
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
    this.razorpayLink,
    this.status,
  });

  String? razorpayLink;
  String? status;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        razorpayLink: json["razorpay_link"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "razorpay_link": razorpayLink,
        "status": status,
      };
}
