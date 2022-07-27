import 'dart:convert';

CheckBooking checkBookingFromJson(String str) => CheckBooking.fromJson(json.decode(str));

String checkBookingToJson(CheckBooking data) => json.encode(data.toJson());

class CheckBooking {
    CheckBooking({
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

    factory CheckBooking.fromJson(Map<String, dynamic> json) => CheckBooking(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["data"] == null
         ? null : Data.fromJson(json["data"]),
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
        this.dataContinue,
    });

    bool? dataContinue;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataContinue: json["continue"],
    );

    Map<String, dynamic> toJson() => {
        "continue": dataContinue,
    };
}
