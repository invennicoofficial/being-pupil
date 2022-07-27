import 'dart:convert';

GetAllProperty getAllPropertyFromJson(String str) => GetAllProperty.fromJson(json.decode(str));

String getAllPropertyToJson(GetAllProperty data) => json.encode(data.toJson());

class GetAllProperty {
    GetAllProperty({
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

    factory GetAllProperty.fromJson(Map<String, dynamic> json) => GetAllProperty(
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
        this.propertyId,
        this.name,
        this.description,
        this.location,
        this.featuredImage,
        this.rating,
        this.review,
        this.amenities,
        this.room,
        this.meal,
    });

    int? propertyId;
    String? name;
    String? description;
    Location? location;
    List<String>? featuredImage;
    double? rating;
    int? review;
    List<Amenity>? amenities;
    List<Room>? room;
    List<Meal>? meal;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyId: json["property_id"],
        name: json["name"],
        description: json["description"],
        location: Location.fromJson(json["location"]),
        featuredImage: List<String>.from(json["featured_image"].map((x) => x)),
        rating: json["rating"].toDouble(),
        review: json["review"],
        amenities: List<Amenity>.from(json["amenities"].map((x) => Amenity.fromJson(x))),
        room: List<Room>.from(json["room"].map((x) => Room.fromJson(x))),
        meal: List<Meal>.from(json["meal"].map((x) => Meal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "property_id": propertyId,
        "name": name,
        "description": description,
        "location": location!.toJson(),
        "featured_image": List<dynamic>.from(featuredImage!.map((x) => x)),
        "rating": rating,
        "review": review,
        "amenities": List<dynamic>.from(amenities!.map((x) => x.toJson())),
        "room": List<dynamic>.from(room!.map((x) => x.toJson())),
        "meal": List<dynamic>.from(meal!.map((x) => x.toJson())),
    };
}

class Amenity {
    Amenity({
        this.amenitiesId,
        this.amenitiesName,
        this.amenitiesImage,
    });

    int? amenitiesId;
    String? amenitiesName;
    String? amenitiesImage;

    factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        amenitiesId: json["amenities_id"],
        amenitiesName: json["amenities_name"],
        amenitiesImage: json["amenities_image"],
    );

    Map<String, dynamic> toJson() => {
        "amenities_id": amenitiesId,
        "amenities_name": amenitiesName,
        "amenities_image": amenitiesImage,
    };
}

class Location {
    Location({
        this.address,
        this.lat,
        this.lng,
    });

    String? address;
    String? lat;
    String? lng;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        address: json["address"],
        lat: json["lat"],
        lng: json["lng"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "lat": lat,
        "lng": lng,
    };
}

class Meal {
    Meal({
        this.mealId,
        this.mealType,
        this.mealAmount,
    });

    int? mealId;
    String? mealType;
    String? mealAmount;

    factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        mealId: json["meal_id"],
        mealType: json["meal_type"],
        mealAmount: json["meal_amount"],
    );

    Map<String, dynamic> toJson() => {
        "meal_id": mealId,
        "meal_type": mealType,
        "meal_amount": mealAmount,
    };
}

class Room {
    Room({
        this.roomId,
        this.roomType,
        this.roomAmount,
    });

    int? roomId;
    String? roomType;
    String? roomAmount;

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomId: json["room_id"],
        roomType: json["room_type"],
        roomAmount: json["room_amount"],
    );

    Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "room_type": roomType,
        "room_amount": roomAmount,
    };
}
