// To parse this JSON data, do
//
//     final profileDetails = profileDetailsFromJson(jsonString);

import 'dart:convert';

EducatorProfileDetails profileDetailsFromJson(String str) => EducatorProfileDetails.fromJson(json.decode(str));

String profileDetailsToJson(EducatorProfileDetails data) => json.encode(data.toJson());

class EducatorProfileDetails {
    EducatorProfileDetails({
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

    factory EducatorProfileDetails.fromJson(Map<String, dynamic> json) => EducatorProfileDetails(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json['status'] == true ? Data.fromJson(json["data"]) : new Data.toEmpty(json['data']),
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
        this.name,
        this.mobileNumber,
        this.imageFile,
        this.imageUrl,
        this.email,
        this.gender,
        this.dob,
        this.documentType,
        this.documentFile,
        this.documentUrl,
        this.identificationDocumentNumber,
        this.educationalDetails,
        this.educationalDetails1,
        this.totalWorkExperience,
        this.totalTeachingExperience,
        this.achievements,
        this.skills,
        this.hobbies,
        this.facebookUrl,
        this.instaUrl,
        this.linkedinUrl,
        this.otherUrl,
        this.location,
        this.isNew,
        //this.interestedCategory,
    });

    int userId;
    String registerAs;
    String name;
    String mobileNumber;
    String imageFile;
    String imageUrl;
    String email;
    String gender;
    String dob;
    String documentType;
    String documentFile;
    String documentUrl;
    String identificationDocumentNumber;
    List<EducationalDetail> educationalDetails;
    List<dynamic> educationalDetails1 = [];
    String totalWorkExperience;
    String totalTeachingExperience;
    String achievements;
    String skills;
    String hobbies;
    dynamic facebookUrl;
    String instaUrl;
    String linkedinUrl;
    String otherUrl;
    List<Location> location;
    String isNew;
    //List<InterestedCategory> interestedCategory = [];

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        registerAs: json["register_as"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        imageFile: json["image_file"],
        imageUrl: json["image_url"],
        email: json["email"],
        gender: json["gender"],
        dob: json["dob"],
        documentType: json["document_type"],
        documentFile: json["document_file"],
        documentUrl: json["document_url"],
        identificationDocumentNumber: json["identification_document_number"],
        educationalDetails: List<EducationalDetail>.from(json["educational_details"].map((x) => EducationalDetail.fromJson(x))),
        educationalDetails1: json["educational_details"],
        totalWorkExperience: json["total_work_experience"],
        totalTeachingExperience: json["total_teaching_experience"],
        achievements: json["achievements"],
        skills: json["skills"],
        hobbies: json["hobbies"],
        facebookUrl: json["facebook_url"],
        instaUrl: json["insta_url"],
        linkedinUrl: json["linkedin_url"],
        otherUrl: json["other_url"],
        location: List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
        isNew: json["isNew"],
        // interestedCategory: json["interested_category"] != []
        // ? List<InterestedCategory>.from(json["interested_category"].map((x) => InterestedCategory.fromJson(x)))
        // : null,
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "register_as": registerAs,
        "name": name,
        "mobile_number": mobileNumber,
        "image_file": imageFile,
        "image_url": imageUrl,
        "email": email,
        "gender": gender,
        "dob": dob,
        "document_type": documentType,
        "document_file": documentFile,
        "document_url": documentUrl,
        "identification_document_number": identificationDocumentNumber,
        "educational_details": List<dynamic>.from(educationalDetails1.map((x) => x.toJson())),
        "total_work_experience": totalWorkExperience,
        "total_teaching_experience": totalTeachingExperience,
        "achievements": achievements,
        "skills": skills,
        "hobbies": hobbies,
        "facebook_url": facebookUrl,
        "insta_url": instaUrl,
        "linkedin_url": linkedinUrl,
        "other_url": otherUrl,
        "location": List<dynamic>.from(location.map((x) => x.toJson())),
        "isNew": isNew,
        //"interested_category": List<dynamic>.from(interestedCategory.map((x) => x.toJson())),
    };

    Data.toEmpty(List<dynamic> json) {
    return;
  }
}

// class InterestedCategory {
//     InterestedCategory({
//         this.key,
//         this.value,
//         this.selected,
//     });

//     int key;
//     String value;
//     bool selected;

//     factory InterestedCategory.fromJson(Map<String, dynamic> json) => InterestedCategory(
//         key: json["key"],
//         value: json["value"],
//         selected: json["selected"],
//     );

//     Map<String, dynamic> toJson() => {
//         "key": key,
//         "value": value,
//         "selected": selected,
//     };
// }


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
