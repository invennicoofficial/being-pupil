class ProfileUpdate {
  bool status;
  // Null errorCode;
  // Null errorMsg;
  String message;
  Data data;
  //Null metaParams;

  ProfileUpdate(
      {this.status,
      // this.errorCode,
      // this.errorMsg,
      this.message,
      this.data,
      //this.metaParams
      });

  ProfileUpdate.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    // errorCode = json['error_code'];
    // errorMsg = json['error_msg'];
    message = json['message'];
    data = json['status'] == true ? new Data.fromJson(json['data']) : new Data.toEmpty(json['data']);
    //metaParams = json['meta_params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    // data['error_code'] = this.errorCode;
    // data['error_msg'] = this.errorMsg;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    //data['meta_params'] = this.metaParams;
    return data;
  }
}

class Data {
  int userId;
  String registerAs;
  String imageFile;
  String imageUrl;
  String name;
  String mobileNumber;
  String email;
  String gender;
  String dob;
  Null documentType;
  String documentFile;
  String documentUrl;
  String identificationDocumentNumber;
  List<Location> location;
  String achievements;
  String skills;
  String hobbies;
  Null facbookUrl;
  Null instaUrl;
  Null linkedinUrl;
  Null otherUrl;
  List<EducationalDetails> educationalDetails;
  String totalWorkExperience;
  String totalTeachingExperience;
  List<InterestedCategory> interestedCategory;

  Data(
      {this.userId,
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
      this.interestedCategory});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    registerAs = json['register_as'];
    imageFile = json['image_file'];
    imageUrl = json['image_url'];
    name = json['name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
    documentType = json['document_type'];
    documentFile = json['document_file'];
    documentUrl = json['document_url'];
    identificationDocumentNumber = json['identification_document_number'];
    if (json['location'] != null) {
      location = new List<Location>();
      json['location'].forEach((v) {
        location.add(new Location.fromJson(v));
      });
    }
    achievements = json['achievements'];
    skills = json['skills'];
    hobbies = json['hobbies'];
    facbookUrl = json['facbook_url'];
    instaUrl = json['insta_url'];
    linkedinUrl = json['linkedin_url'];
    otherUrl = json['other_url'];
    if (json['educational_details'] != null) {
      educationalDetails = new List<EducationalDetails>();
      json['educational_details'].forEach((v) {
        educationalDetails.add(new EducationalDetails.fromJson(v));
      });
    }
    totalWorkExperience = json['total_work_experience'];
    totalTeachingExperience = json['total_teaching_experience'];
    if (json['interested_category'] != null) {
      interestedCategory = new List<InterestedCategory>();
      json['interested_category'].forEach((v) {
        interestedCategory.add(new InterestedCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['register_as'] = this.registerAs;
    data['image_file'] = this.imageFile;
    data['image_url'] = this.imageUrl;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['document_type'] = this.documentType;
    data['document_file'] = this.documentFile;
    data['document_url'] = this.documentUrl;
    data['identification_document_number'] = this.identificationDocumentNumber;
    if (this.location != null) {
      data['location'] = this.location.map((v) => v.toJson()).toList();
    }
    data['achievements'] = this.achievements;
    data['skills'] = this.skills;
    data['hobbies'] = this.hobbies;
    data['facbook_url'] = this.facbookUrl;
    data['insta_url'] = this.instaUrl;
    data['linkedin_url'] = this.linkedinUrl;
    data['other_url'] = this.otherUrl;
    if (this.educationalDetails != null) {
      data['educational_details'] =
          this.educationalDetails.map((v) => v.toJson()).toList();
    }
    data['total_work_experience'] = this.totalWorkExperience;
    data['total_teaching_experience'] = this.totalTeachingExperience;
    if (this.interestedCategory != null) {
      data['interested_category'] =
          this.interestedCategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
Data.toEmpty(List<dynamic> json) {
    return;
  }
  
}

class Location {
  int id;
  String addressLine1;
  String addressLine2;
  String city;
  String country;
  String pincode;
  String latitude;
  Null logitude;
  String locationType;

  Location(
      {this.id,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.country,
      this.pincode,
      this.latitude,
      this.logitude,
      this.locationType});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    city = json['city'];
    country = json['country'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    logitude = json['logitude'];
    locationType = json['location_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_line1'] = this.addressLine1;
    data['address_line2'] = this.addressLine2;
    data['city'] = this.city;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['logitude'] = this.logitude;
    data['location_type'] = this.locationType;
    return data;
  }
}

class EducationalDetails {
  int id;
  String schoolName;
  String year;
  String qualification;
  String certificateFile;

  EducationalDetails(
      {this.id,
      this.schoolName,
      this.year,
      this.qualification,
      this.certificateFile});

  EducationalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schoolName = json['school_name'];
    year = json['year'];
    qualification = json['qualification'];
    certificateFile = json['certificate_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['school_name'] = this.schoolName;
    data['year'] = this.year;
    data['qualification'] = this.qualification;
    data['certificate_file'] = this.certificateFile;
    return data;
  }
}

class InterestedCategory {
  int key;
  String value;
  bool selected;

  InterestedCategory({this.key, this.value, this.selected});

  InterestedCategory.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['selected'] = this.selected;
    return data;
  }
}
