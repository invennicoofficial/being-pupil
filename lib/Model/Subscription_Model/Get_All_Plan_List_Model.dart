import 'dart:convert';

class GetAllPlanList {
    GetAllPlanList({
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

    factory GetAllPlanList.fromRawJson(String str) => GetAllPlanList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GetAllPlanList.fromJson(Map<String, dynamic> json) => GetAllPlanList(
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
        this.feature,
        this.plan,
    });

    List<String>? feature;
    List<Plan>? plan;

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        feature: List<String>.from(json["feature"].map((x) => x)),
        plan: List<Plan>.from(json["plan"].map((x) => Plan.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "feature": List<dynamic>.from(feature!.map((x) => x)),
        "plan": List<dynamic>.from(plan!.map((x) => x.toJson())),
    };
}

class Plan {
    Plan({
        this.planId,
        this.planName,
        this.planPrice,
        this.isRecommended,
    });

    int? planId;
    String? planName;
    String? planPrice;
    bool? isRecommended;

    factory Plan.fromRawJson(String str) => Plan.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        planId: json["plan_id"],
        planName: json["plan_name"],
        planPrice: json["plan_price"],
        isRecommended: json["isRecommended"],
    );

    Map<String, dynamic> toJson() => {
        "plan_id": planId,
        "plan_name": planName,
        "plan_price": planPrice,
        "isRecommended": isRecommended,
    };
}
