import 'dart:convert';

ReportIssue reportIssueFromJson(String str) => ReportIssue.fromJson(json.decode(str));

String reportIssueToJson(ReportIssue data) => json.encode(data.toJson());

class ReportIssue {
    ReportIssue({
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

    factory ReportIssue.fromJson(Map<String, dynamic> json) => ReportIssue(
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
        this.status,
    });

    int? status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
    };
}
