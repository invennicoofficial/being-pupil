// To parse this JSON data, do
//
//     final CancelBookoingReason = CancelBookoingReasonFromJson(jsonString);

import 'dart:convert';

CancelBookoingReason cancelBookoingReasonFromJson(String str) => CancelBookoingReason.fromJson(json.decode(str));

String cancelBookoingReasonToJson(CancelBookoingReason data) => json.encode(data.toJson());

class CancelBookoingReason {
    CancelBookoingReason({
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
    List<Datum> data;
    dynamic metaParams;

    factory CancelBookoingReason.fromJson(Map<String, dynamic> json) => CancelBookoingReason(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
    Datum({
        this.cancelId,
        this.name,
    });

    int cancelId;
    String name;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        cancelId: json["cancel_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "cancel_id": cancelId,
        "name": name,
    };
}
