// To parse this JSON data, do
//
//     final cencelSubscription = cencelSubscriptionFromJson(jsonString);

import 'dart:convert';

class CancelSubscription {
    CancelSubscription({
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
    dynamic data;
    dynamic metaParams;

    factory CancelSubscription.fromRawJson(String str) => CancelSubscription.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CancelSubscription.fromJson(Map<String, dynamic> json) => CancelSubscription(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["data"],
        metaParams: json["meta_params"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "message": message,
        "data": data,
        "meta_params": metaParams,
    };
}
