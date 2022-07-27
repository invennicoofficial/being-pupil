import 'dart:convert';

class CreateSubscription {
  CreateSubscription({
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

  factory CreateSubscription.fromRawJson(String str) =>
      CreateSubscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateSubscription.fromJson(Map<String, dynamic> json) =>
      CreateSubscription(
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
    this.subscriptionId,
    this.userName,
    this.userMobile,
    this.userEmail,
  });

  String? subscriptionId;
  String? userName;
  String? userMobile;
  String? userEmail;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        subscriptionId: json["subscription_id"],
        userName: json["user_name"],
        userMobile: json["user_mobile"],
        userEmail: json["user_email"],
      );

  Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "user_name": userName,
        "user_mobile": userMobile,
        "user_email": userEmail,
      };
}
