// To parse this JSON data, do
//
//     final propertyReview = propertyReviewFromJson(jsonString);

import 'dart:convert';

PropertyReview propertyReviewFromJson(String str) => PropertyReview.fromJson(json.decode(str));

String propertyReviewToJson(PropertyReview data) => json.encode(data.toJson());

class PropertyReview {
    PropertyReview({
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

    factory PropertyReview.fromJson(Map<String, dynamic> json) => PropertyReview(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
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
        this.totalRating,
        this.totalReview,
        this.rating,
        this.review,
    });

    int? totalRating;
    int? totalReview;
    Rating? rating;
    List<Review>? review;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRating: json["total_rating"],
        totalReview: json["total_review"],
        rating: Rating.fromJson(json["rating"]),
        review: List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_rating": totalRating,
        "total_review": totalReview,
        "rating": rating!.toJson(),
        "review": List<dynamic>.from(review!.map((x) => x.toJson())),
    };
}

class Rating {
    Rating({
        this.the1,
        this.the2,
        this.the3,
        this.the4,
        this.the5,
        this.avgRating,
    });

    int? the1;
    int? the2;
    int? the3;
    int? the4;
    int? the5;
    double? avgRating;

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        the5: json["5"],
        avgRating: json["avg_rating"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "5": the5,
        "avg_rating": avgRating,
    };
}

class Review {
    Review({
        this.reviewId,
        this.reviewUserId,
        this.profileImage,
        this.date,
        this.headline,
        this.descreption,
        this.rating,
    });

    int? reviewId;
    int? reviewUserId;
    String? profileImage;
    String? date;
    String? headline;
    String? descreption;
    String? rating;

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json["review_id"],
        reviewUserId: json["review_user_id"],
        profileImage: json["profile_image"],
        date: json["date"],
        headline: json["headline"],
        descreption: json["descreption"],
        rating: json["rating"],
    );

    Map<String, dynamic> toJson() => {
        "review_id": reviewId,
        "review_user_id": reviewUserId,
        "profile_image": profileImage,
        "date": date,
        "headline": headline,
        "descreption": descreption,
        "rating": rating,
    };
}


// token
// property_id
// booking_id
// rating
// headline
// descreption