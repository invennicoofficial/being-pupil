// To parse this JSON data, do
//
//     final createBooking = createBookingFromJson(jsonString);

import 'dart:convert';

CreateBooking createBookingFromJson(String str) => CreateBooking.fromJson(json.decode(str));

String createBookingToJson(CreateBooking data) => json.encode(data.toJson());

class CreateBooking {
    CreateBooking({
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

    factory CreateBooking.fromJson(Map<String, dynamic> json) => CreateBooking(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
        this.userId,
        this.bookingId,
        this.guestName,
        this.mobileNumber,
    });

    int? userId;
    String? bookingId;
    String? guestName;
    String? mobileNumber;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        bookingId: json["booking_id"],
        guestName: json["guest_name"],
        mobileNumber: json["mobile_number"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "booking_id": bookingId,
        "guest_name": guestName,
        "mobile_number": mobileNumber,
    };
}
