// To parse this JSON data, do
//
//     final learnerProfileDetails = learnerProfileDetailsFromJson(jsonString);

import 'dart:convert';

LearnerProfileDetails learnerProfileDetailsFromJson(String str) => LearnerProfileDetails.fromJson(json.decode(str));

String learnerProfileDetailsToJson(LearnerProfileDetails data) => json.encode(data.toJson());

class LearnerProfileDetails {
    LearnerProfileDetails({
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
    Data data;
    dynamic metaParams;

    factory LearnerProfileDetails.fromJson(Map<String, dynamic> json) => LearnerProfileDetails(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json["status"] == true ? Data.fromJson(json["data"]) : new Data.toEmpty(json['data']),
        metaParams: json["meta_params"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error_code": errorCode,
        "error_msg": errorMsg,
        "message": message,
        "data": data.toJson(),
        "meta_params": metaParams,
    };
}

class Data {
    Data({
        this.userId,
        this.registerAs,
        this.imageFile,
        this.imageUrl,
        this.name,
        this.mobileNumber,
        this.email,
        this.gender,
        this.dob,
        this.documentType,
        this.documentFile,
        this.documentUrl,
        this.identificationDocumentNumber,
        this.location,
        this.achievements,
        this.skills,
        this.hobbies,
        this.facebookUrl,
        this.instaUrl,
        this.linkedinUrl,
        this.otherUrl,
        this.educationalDetails,
        this.totalWorkExperience,
        this.totalTeachingExperience,
        this.interestedCategory,
    });

    int userId;
    String registerAs;
    String imageFile;
    String imageUrl;
    String name;
    String mobileNumber;
    String email;
    String gender;
    String dob;
    String documentType;
    String documentFile;
    String documentUrl;
    String identificationDocumentNumber;
    List<Location> location;
    String achievements;
    dynamic skills;
    String hobbies;
    dynamic facebookUrl;
    String instaUrl;
    dynamic linkedinUrl;
    dynamic otherUrl;
    List<dynamic> educationalDetails = [];
    String totalWorkExperience;
    String totalTeachingExperience;
    List<InterestedCategory> interestedCategory;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        registerAs: json["register_as"],
        imageFile: json["image_file"],
        imageUrl: json["image_url"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        email: json["email"],
        gender: json["gender"],
        dob: json["dob"],
        documentType: json["document_type"],
        documentFile: json["document_file"],
        documentUrl: json["document_url"],
        identificationDocumentNumber: json["identification_document_number"],
        location: List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
        achievements: json["achievements"],
        skills: json["skills"],
        hobbies: json["hobbies"],
        facebookUrl: json["facebook_url"],
        instaUrl: json["insta_url"],
        linkedinUrl: json["linkedin_url"],
        otherUrl: json["other_url"],
        educationalDetails: json["educational_details"],
        //educationalDetails: List<dynamic>.from(json["educational_details"].map((x) => x)),
        totalWorkExperience: json["total_work_experience"],
        totalTeachingExperience: json["total_teaching_experience"],
        interestedCategory: List<InterestedCategory>.from(json["interested_category"].map((x) => InterestedCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "register_as": registerAs,
        "image_file": imageFile,
        "image_url": imageUrl,
        "name": name,
        "mobile_number": mobileNumber,
        "email": email,
        "gender": gender,
        "dob": dob,
        "document_type": documentType,
        "document_file": documentFile,
        "document_url": documentUrl,
        "identification_document_number": identificationDocumentNumber,
        "location": List<dynamic>.from(location.map((x) => x.toJson())),
        "achievements": achievements,
        "skills": skills,
        "hobbies": hobbies,
        "facebook_url": facebookUrl,
        "insta_url": instaUrl,
        "linkedin_url": linkedinUrl,
        "other_url": otherUrl,
        "educational_details": List<dynamic>.from(educationalDetails.map((x) => x.toJson())),
        "total_work_experience": totalWorkExperience,
        "total_teaching_experience": totalTeachingExperience,
        "interested_category": List<dynamic>.from(interestedCategory.map((x) => x.toJson())),
    };

     Data.toEmpty(List<dynamic> json) {
    return;
  }
}

class InterestedCategory {
    InterestedCategory({
        this.key,
        this.value,
        this.selected,
    });

    int key;
    String value;
    bool selected;

    factory InterestedCategory.fromJson(Map<String, dynamic> json) => InterestedCategory(
        key: json["key"],
        value: json["value"],
        selected: json["selected"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "selected": selected,
    };
}

class EducationalDetail {
    EducationalDetail({
        this.id,
        this.schoolName,
        this.year,
        this.qualification,
        this.certificateFile,
    });

    int id;
    String schoolName;
    String year;
    String qualification;
    String certificateFile;

    factory EducationalDetail.fromJson(Map<String, dynamic> json) => EducationalDetail(
        id: json["id"],
        schoolName: json["school_name"],
        year: json["year"],
        qualification: json["qualification"],
        certificateFile: json["certificate_file"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "school_name": schoolName,
        "year": year,
        "qualification": qualification,
        "certificate_file": certificateFile,
    };
}

class Location {
    Location({
        this.id,
        this.addressLine1,
        this.addressLine2,
        this.city,
        this.country,
        this.pincode,
        this.latitude,
        this.longitude,
    });

    int id;
    String addressLine1;
    String addressLine2;
    String city;
    String country;
    String pincode;
    String latitude;
    String longitude;

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        addressLine1: json["address_line1"],
        addressLine2: json["address_line2"],
        city: json["city"],
        country: json["country"],
        pincode: json["pincode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "country": country,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
    };
}
