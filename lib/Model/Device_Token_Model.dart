// To parse this JSON data, do
//
//     final deviceToken = deviceTokenFromJson(jsonString);

import 'dart:convert';

DeviceToken deviceTokenFromJson(String str) => DeviceToken.fromJson(json.decode(str));

String deviceTokenToJson(DeviceToken data) => json.encode(data.toJson());

class DeviceToken {
    DeviceToken({
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

    factory DeviceToken.fromJson(Map<String, dynamic> json) => DeviceToken(
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
