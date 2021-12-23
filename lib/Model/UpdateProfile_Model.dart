// class ProfileUpdate {
//   bool status;
//   // Null errorCode;
//   // Null errorMsg;
//   String message;
//   Data data;
//   //Null metaParams;

//   ProfileUpdate(
//       {this.status,
//       // this.errorCode,
//       // this.errorMsg,
//       this.message,
//       this.data,
//       //this.metaParams
//       });

//   factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
//     status: json['status'],
//     // errorCode = json['error_code'];
//     // errorMsg = json['error_msg'];
//     message: json['message'],
//     data: json['status'] == true ? new Data.fromJson(json['data']) : new Data.toEmpty(json['data']),
//     //metaParams = json['meta_params'];
//   );
    
  

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     // data['error_code'] = this.errorCode;
//     // data['error_msg'] = this.errorMsg;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     //data['meta_params'] = this.metaParams;
//     return data;
//   }
// }

// class Data {
//   int userId;
//   String registerAs;
//   String imageFile;
//   String imageUrl;
//   String name;
//   String mobileNumber;
//   String email;
//   String gender;
//   String dob;
//   String documentType;
//   String documentFile;
//   String documentUrl;
//   String identificationDocumentNumber;
//   List<Location> location;
//   String achievements;
//   String skills;
//   String hobbies;
//   String facbookUrl;
//   String instaUrl;
//   String linkedinUrl;
//   String otherUrl;
//   List<EducationalDetails> educationalDetails;
//   String totalWorkExperience;
//   String totalTeachingExperience;
//   List<InterestedCategory> interestedCategory;

//   Data(
//       {this.userId,
//       this.registerAs,
//       this.imageFile,
//       this.imageUrl,
//       this.name,
//       this.mobileNumber,
//       this.email,
//       this.gender,
//       this.dob,
//       this.documentType,
//       this.documentFile,
//       this.documentUrl,
//       this.identificationDocumentNumber,
//       this.location,
//       this.achievements,
//       this.skills,
//       this.hobbies,
//       this.facbookUrl,
//       this.instaUrl,
//       this.linkedinUrl,
//       this.otherUrl,
//       this.educationalDetails,
//       this.totalWorkExperience,
//       this.totalTeachingExperience,
//       this.interestedCategory});

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//      userId: json['user_id'],
//     registerAs: json['register_as'],
//     imageFile: json['image_file'],
//     imageUrl: json['image_url'],
//     name: json['name'],
//     mobileNumber: json['mobile_number'],
//     email: json['email'],
//     gender: json['gender'],
//     dob: json['dob'],
//     documentType: json['document_type'],
//     documentFile: json['document_file'],
//     documentUrl: json['document_url'],
//     identificationDocumentNumber: json['identification_document_number'],
//     // if (json['location'] != null) {
//     //   location = new List<Location>();
//     //   json['location'].forEach((v) {
//     //     location.add(new Location.fromJson(v));
//     //   });
//     // }
//     achievements: json['achievements'],
//     skills: json['skills'],
//     hobbies: json['hobbies'],
//     facbookUrl: json['facbook_url'],
//     instaUrl: json['insta_url'],
//     linkedinUrl: json['linkedin_url'],
//     otherUrl: json['other_url'],
//     // if (json['educational_details'] != null) {
//     //   educationalDetails: new List<EducationalDetails>();
//     //   json['educational_details'].forEach((v) {
//     //     educationalDetails.add(new EducationalDetails.fromJson(v));
//     //   });
//     // }
//     totalWorkExperience: json['total_work_experience'],
//     totalTeachingExperience: json['total_teaching_experience'],
//     // if (json['interested_category'] != null) {
//     //   interestedCategory: new List<InterestedCategory>();
//     //   json['interested_category'].forEach((v) {
//     //     interestedCategory.add(new InterestedCategory.fromJson(v));
//     //   });
//     // }
//   );
   
  

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['register_as'] = this.registerAs;
//     data['image_file'] = this.imageFile;
//     data['image_url'] = this.imageUrl;
//     data['name'] = this.name;
//     data['mobile_number'] = this.mobileNumber;
//     data['email'] = this.email;
//     data['gender'] = this.gender;
//     data['dob'] = this.dob;
//     data['document_type'] = this.documentType;
//     data['document_file'] = this.documentFile;
//     data['document_url'] = this.documentUrl;
//     data['identification_document_number'] = this.identificationDocumentNumber;
//     if (this.location != null) {
//       data['location'] = this.location.map((v) => v.toJson()).toList();
//     }
//     data['achievements'] = this.achievements;
//     data['skills'] = this.skills;
//     data['hobbies'] = this.hobbies;
//     data['facbook_url'] = this.facbookUrl;
//     data['insta_url'] = this.instaUrl;
//     data['linkedin_url'] = this.linkedinUrl;
//     data['other_url'] = this.otherUrl;
//     if (this.educationalDetails != null) {
//       data['educational_details'] =
//           this.educationalDetails.map((v) => v.toJson()).toList();
//     }
//     data['total_work_experience'] = this.totalWorkExperience;
//     data['total_teaching_experience'] = this.totalTeachingExperience;
//     if (this.interestedCategory != null) {
//       data['interested_category'] =
//           this.interestedCategory.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// Data.toEmpty(List<dynamic> json) {
//     return;
//   }
  
// }

// class Location {
//   int id;
//   String addressLine1;
//   String addressLine2;
//   String city;
//   String country;
//   String pincode;
//   String latitude;
//   Null logitude;
//   String locationType;

//   Location(
//       {this.id,
//       this.addressLine1,
//       this.addressLine2,
//       this.city,
//       this.country,
//       this.pincode,
//       this.latitude,
//       this.logitude,
//       this.locationType});

//   factory Location.fromJson(Map<String, dynamic> json) => Location(
//      id: json['id'],
//     addressLine1: json['address_line1'],
//     addressLine2: json['address_line2'],
//     city: json['city'],
//     country: json['country'],
//     pincode: json['pincode'],
//     latitude: json['latitude'],
//     logitude: json['logitude'],
//     locationType: json['location_type'],
//   );
   
  

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['address_line1'] = this.addressLine1;
//     data['address_line2'] = this.addressLine2;
//     data['city'] = this.city;
//     data['country'] = this.country;
//     data['pincode'] = this.pincode;
//     data['latitude'] = this.latitude;
//     data['logitude'] = this.logitude;
//     data['location_type'] = this.locationType;
//     return data;
//   }
// }

// class EducationalDetails {
//   int id;
//   String schoolName;
//   String year;
//   String qualification;
//   String certificateFile;

//   EducationalDetails(
//       {this.id,
//       this.schoolName,
//       this.year,
//       this.qualification,
//       this.certificateFile});

//   factory EducationalDetails.fromJson(Map<String, dynamic> json) => EducationalDetails(
//     id: json['id'],
//     schoolName: json['school_name'],
//     year: json['year'],
//     qualification: json['qualification'],
//     certificateFile: json['certificate_file'],
//   );
    

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['school_name'] = this.schoolName;
//     data['year'] = this.year;
//     data['qualification'] = this.qualification;
//     data['certificate_file'] = this.certificateFile;
//     return data;
//   }
// }

// class InterestedCategory {
//   int key;
//   String value;
//   bool selected;

//   InterestedCategory({this.key, this.value, this.selected});

//   factory InterestedCategory.fromJson(Map<String, dynamic> json) => InterestedCategory(
//     key: json['key'],
//     value: json['value'],
//     selected: json['selected'],
//   );
    
  

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['key'] = this.key;
//     data['value'] = this.value;
//     data['selected'] = this.selected;
//     return data;
//   }
// }



// To parse this JSON data, do
//
//     final updateProfile = updateProfileFromJson(jsonString);

import 'dart:convert';

ProfileUpdate updateProfileFromJson(String str) => ProfileUpdate.fromJson(json.decode(str));

String updateProfileToJson(ProfileUpdate data) => json.encode(data.toJson());

class ProfileUpdate {
    ProfileUpdate({
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

    factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
        status: json["status"],
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        message: json["message"],
        data: json['status'] == true ? new Data.fromJson(json['data']) : new Data.toEmpty(json['data']),//Data.fromJson(json["data"]),
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
        this.facbookUrl,
        this.instaUrl,
        this.linkedinUrl,
        this.otherUrl,
        this.educationalDetails,
        this.totalWorkExperience,
        this.totalTeachingExperience,
        this.interestedCategory,
    });

    int? userId;
    String? registerAs;
    String? imageFile;
    String? imageUrl;
    String? name;
    String? mobileNumber;
    String? email;
    String? gender;
    String? dob;
    String? documentType;
    String? documentFile;
    String? documentUrl;
    String? identificationDocumentNumber;
    List<Location>? location;
    String? achievements;
    String? skills;
    String? hobbies;
    dynamic facbookUrl;
    dynamic instaUrl;
    dynamic linkedinUrl;
    dynamic otherUrl;
    List<EducationalDetail>? educationalDetails;
    String? totalWorkExperience;
    String? totalTeachingExperience;
    List<InterestedCategory>? interestedCategory;

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
        facbookUrl: json["facbook_url"],
        instaUrl: json["insta_url"],
        linkedinUrl: json["linkedin_url"],
        otherUrl: json["other_url"],
        educationalDetails: List<EducationalDetail>.from(json["educational_details"].map((x) => EducationalDetail.fromJson(x))),
        totalWorkExperience: json["total_work_experience"],
        totalTeachingExperience: json["total_teaching_experience"],
        interestedCategory: json["interested_category"] != []
        ? List<InterestedCategory>.from(json["interested_category"].map((x) => InterestedCategory.fromJson(x)))
        : null,
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
        "location": List<dynamic>.from(location!.map((x) => x.toJson())),
        "achievements": achievements,
        "skills": skills,
        "hobbies": hobbies,
        "facbook_url": facbookUrl,
        "insta_url": instaUrl,
        "linkedin_url": linkedinUrl,
        "other_url": otherUrl,
        "educational_details": List<dynamic>.from(educationalDetails!.map((x) => x.toJson())),
        "total_work_experience": totalWorkExperience,
        "total_teaching_experience": totalTeachingExperience,
        "interested_category": List<dynamic>.from(interestedCategory!.map((x) => x.toJson())),
    };

    Data.toEmpty(List<dynamic>? json) {
    return;
  }
}

class InterestedCategory {
    InterestedCategory({
        this.key,
        this.value,
        this.selected,
    });

    int? key;
    String? value;
    bool? selected;

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

    int? id;
    String? schoolName;
    String? year;
    String? qualification;
    String? certificateFile;

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

    int? id;
    String? addressLine1;
    String? addressLine2;
    String? city;
    String? country;
    String? pincode;
    String? latitude;
    String? longitude;

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
