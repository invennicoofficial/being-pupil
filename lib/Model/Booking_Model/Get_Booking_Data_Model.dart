// To parse this JSON data, do
//
//     final upComingBooking = upComingBookingFromJson(jsonString);

import 'dart:convert';

BookingDetails bookingDetailsFromJson(String str) => BookingDetails.fromJson(json.decode(str));

String bookingDetailsToJson(BookingDetails data) => json.encode(data.toJson());

class BookingDetails {
    BookingDetails({
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
    List<Data> data;
    dynamic metaParams;

    factory BookingDetails.fromJson(Map<String, dynamic> json) => BookingDetails(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["data"] != null ? List<Data>.from(json["data"].map((x) => Data.fromJson(x))) : null,
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

class Data {
    Data({
        this.propertyId,
        this.propertyImage,
        this.name,
        this.bookingId,
        this.roomType,
        this.checkInDate,
        this.checkOutDate,
        this.guestName,
        this.mobileNumber,
        this.meal,
        this.roomAmount,
        this.mealAmount,
        this.taxAmount,
        this.totalAmount,
    });

    String propertyId;
    String propertyImage;
    String name;
    String bookingId;
    String roomType;
    String checkInDate;
    String checkOutDate;
    String guestName;
    String mobileNumber;
    List<String> meal;
    int roomAmount;
    double mealAmount;
    double taxAmount;
    int totalAmount;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyId: json["property_id"],
        propertyImage: json["property_image"],
        name: json["name"],
        bookingId: json["booking_id"],
        roomType: json["room_type"],
        checkInDate: json["checkIn_date"],
        checkOutDate: json["checkOut_date"],
        guestName: json["guest_name"],
        mobileNumber: json["mobile_number"],
        meal: List<String>.from(json["meal"].map((x) => x)),
        roomAmount: json["room_amount"],
        mealAmount: json["meal_amount"].toDouble(),
        taxAmount: json["tax_amount"].toDouble(),
        totalAmount: json["total_amount"],
    );

    Map<String, dynamic> toJson() => {
        "property_id": propertyId,
        "property_image": propertyImage,
        "name": name,
        "booking_id": bookingId,
        "room_type": roomType,
        "checkIn_date": checkInDate,
        "checkOut_date": checkOutDate,
        "guest_name": guestName,
        "mobile_number": mobileNumber,
        "meal": List<dynamic>.from(meal.map((x) => x)),
        "room_amount": roomAmount,
        "meal_amount": mealAmount,
        "tax_amount": taxAmount,
        "total_amount": totalAmount,
    };
}
