// // To parse this JSON data, do
// //
// //     final updateSubscription = updateSubscriptionFromJson(jsonString);

// import 'dart:convert';

// class UpdateSubscription {
//     UpdateSubscription({
//         this.status,
//         this.errorCode,
//         this.errorMsg,
//         this.message,
//         this.data,
//         this.metaParams,
//     });

//     bool? status;
//     dynamic errorCode;
//     dynamic errorMsg;
//     String? message;
//     Data? data;
//     dynamic metaParams;

//     factory UpdateSubscription.fromRawJson(String str) => UpdateSubscription.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory UpdateSubscription.fromJson(Map<String, dynamic> json) => UpdateSubscription(
//         status: json["status"],
//         errorCode: json["error_code"],
//         errorMsg: json["error_msg"],
//         message: json["message"],
//         data: json["status"] == true ? Data.fromJson(json["data"]) : null,
//         metaParams: json["meta_params"],
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "error_code": errorCode,
//         "error_msg": errorMsg,
//         "message": message,
//         "data": data!.toJson(),
//         "meta_params": metaParams,
//     };
// }

// class Data {
//     Data({
//         this.updatedPlanSubscriptionId,
//         this.userName,
//         this.userMobile,
//         this.userEmail,
//     });

//     String? updatedPlanSubscriptionId;
//     String? userName;
//     String? userMobile;
//     String? userEmail;

//     factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//     String toRawJson() => json.encode(toJson());

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         updatedPlanSubscriptionId: json["updated_plan_subscription_id"],
//         userName: json["user_name"],
//         userMobile: json["user_mobile"],
//         userEmail: json["user_email"],
//     );

//     Map<String, dynamic> toJson() => {
//         "updated_plan_subscription_id": updatedPlanSubscriptionId,
//         "user_name": userName,
//         "user_mobile": userMobile,
//         "user_email": userEmail,
//     };
// }

import 'dart:convert';

// To parse this JSON data, do
//
//     final updateSubscription = updateSubscriptionFromJson(jsonString);

import 'dart:convert';

class UpdateSubscription {
    UpdateSubscription({
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

    factory UpdateSubscription.fromRawJson(String str) => UpdateSubscription.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UpdateSubscription.fromJson(Map<String, dynamic> json) => UpdateSubscription(
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
        this.plan,
    });

    String? subscriptionId;
    String? userName;
    String? userMobile;
    String? userEmail;
    Plan? plan;

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        subscriptionId: json["subscription_id"],
        userName: json["user_name"],
        userMobile: json["user_mobile"],
        userEmail: json["user_email"],
        plan: Plan.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "user_name": userName,
        "user_mobile": userMobile,
        "user_email": userEmail,
        "plan": plan!.toJson(),
    };
}

class Plan {
    Plan({
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
    String? planAmount;
    String? planType;
    String? nextBillDate;
    dynamic subscriptionEndDate;
    String? subscriptionStatus;

    factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
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
