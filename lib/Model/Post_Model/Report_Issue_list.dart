import 'dart:convert';

ReportIssueList reportIssueFromJson(String str) => ReportIssueList.fromJson(json.decode(str));

String reportIssueToJson(ReportIssueList data) => json.encode(data.toJson());

class ReportIssueList {
    ReportIssueList({
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

    factory ReportIssueList.fromJson(Map<String, dynamic> json) => ReportIssueList(
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
        this.issueId,
        this.name,
    });

    int? issueId;
    String? name;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        issueId: json["issue_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "issue_id": issueId,
        "name": name,
    };
}
