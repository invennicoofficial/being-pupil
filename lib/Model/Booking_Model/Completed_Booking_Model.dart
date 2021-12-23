// To parse this JSON data, do
//
//     final completedBooking = completedBookingFromJson(jsonString);

import 'dart:convert';

CompletedBooking completedBookingFromJson(String str) => CompletedBooking.fromJson(json.decode(str));

String completedBookingToJson(CompletedBooking data) => json.encode(data.toJson());

class CompletedBooking {
    CompletedBooking({
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

    factory CompletedBooking.fromJson(Map<String, dynamic> json) => CompletedBooking(
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
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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
        this.isReviewed,
        this.review,
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

    String? propertyId;
    String? propertyImage;
    String? name;
    String? bookingId;
    String? roomType;
    bool? isReviewed;
    Review? review;
    String? checkInDate;
    String? checkOutDate;
    String? guestName;
    String? mobileNumber;
    List<String>? meal;
    int? roomAmount;
    double? mealAmount;
    double? taxAmount;
    int? totalAmount;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyId: json["property_id"],
        propertyImage: json["property_image"],
        name: json["name"],
        bookingId: json["booking_id"],
        roomType: json["room_type"],
        isReviewed: json["isReviewed"],
        review: json["review"] == null ? null : Review.fromJson(json["review"]),
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
        "isReviewed": isReviewed,
        "review": review == null ? null : review!.toJson(),
        "checkIn_date": checkInDate,
        "checkOut_date": checkOutDate,
        "guest_name": guestName,
        "mobile_number": mobileNumber,
        "meal": List<dynamic>.from(meal!.map((x) => x)),
        "room_amount": roomAmount,
        "meal_amount": mealAmount,
        "tax_amount": taxAmount,
        "total_amount": totalAmount,
    };
}

class Review {
    Review({
        this.reviewId,
        this.rating,
        this.headline,
        this.descrieption,
    });

    int? reviewId;
    double? rating;
    String? headline;
    String? descrieption;

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json["review_id"],
        rating: json["rating"].toDouble(),
        headline: json["headline"],
        descrieption: json["descrieption"],
    );

    Map<String, dynamic> toJson() => {
        "review_id": reviewId,
        "rating": rating,
        "headline": headline,
        "descrieption": descrieption,
    };
}
