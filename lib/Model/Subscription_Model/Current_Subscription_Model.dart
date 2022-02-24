// To parse this JSON data, do
//
//     final updateSubscription = updateSubscriptionFromJson(jsonString);

import 'dart:convert';

class CurrentSubscription {
  CurrentSubscription({
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

  factory CurrentSubscription.fromRawJson(String str) =>
      CurrentSubscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) =>
      CurrentSubscription(
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
    this.planId,
    this.planName,
    this.planAmount,
    this.planType,
    this.nextBillDate,
    this.subscriptionEndDate,
    this.subscriptionStatus,
  });

  int? planId;
  String? planName;
  String? planType;
  String? planAmount;
  dynamic nextBillDate;
  String? subscriptionEndDate;
  String? subscriptionStatus;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        planId: json["plan_id"],
        planName: json["plan_name"],
        planAmount: json["plan_amount"],
        planType: json["plan_type"],
        nextBillDate: json["next_bill_date"],
        subscriptionEndDate: json["subscription_end_date"],
        subscriptionStatus: json["subscription_status"],
      );

  Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "plan_name": planName,
        "plan_amount": planAmount,
        "plan_type": planType,
        "next_bill_date": nextBillDate,
        "subscription_end_date": subscriptionEndDate,
        "subscription_status": subscriptionStatus,
      };
}
