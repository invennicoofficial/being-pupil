//Model Class for SocialLoginCheck
class SocialLoginCheck {
  bool status;
  String errorCode;
  String errorMsg;
  String message;
  Data data;

  SocialLoginCheck({this.status, this.errorCode, this.errorMsg, this.message, this.data});

  factory SocialLoginCheck.fromJson(Map<String, dynamic> json) {
    return SocialLoginCheck(
        status: json['status'],
        errorCode: json['error_code'],
        errorMsg: json['error_msg'],
        message: json['message'],
        data: json['status'] == true
            ? new Data.fromJson(json['data'])
            : new Data.toEmpty(json['data']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error_code'] = this.errorCode;
    data['error_msg'] = this.errorMsg;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int userId;
  String name;
  String mobileNumber;
  String isNew;
  UserObject userObject;


  Data({this.userId, this.name, this.mobileNumber, this.isNew, this.userObject});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['user_id'],
      name: json['name'],
      mobileNumber: json['mobile_number'],
      isNew: json['isNew'],
      userObject: json['userObj'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['isNew'] = this.isNew;
    return data;
  }

  Data.toEmpty(List<dynamic> json) {
    return;
  }
}

class UserObject {
  String role;
  String isNew;
  String name;
  String mobileNumber;
  String gender;
  String imageUrl;
  Location location;
  EducationalDetails educationalDetail;
  String fbUrl;
  String instaUrl;
  String liUrl;
  String otherUrl;

  UserObject(
      {this.role,
        this.isNew,
        this.name,
        this.mobileNumber,
        this.gender,
        this.imageUrl,
        this.location,
        this.educationalDetail,
        this.fbUrl,
        this.instaUrl,
        this.liUrl,
        this.otherUrl
      });

  factory UserObject.fromJson(Map<String, dynamic> json) {
    return UserObject(
      role: json['register_as'],
      isNew: json['isNew'],
      name: json['name'],
      mobileNumber: json['mobile_number'],
      gender: json['gender'],
      imageUrl: json['image_url'],
      location: json['location'].length > 0
          ? new Location.fromJson(json['location'][0])
          : null,
      educationalDetail: json['educational_details'].length > 0
          ? new EducationalDetails.fromJson(json['educational_details'][0])
          : null,
      fbUrl: json['facebook_url'],
      instaUrl: json['insta_url'],
      liUrl: json['linkedin_url'],
      otherUrl: json['other_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['role'] = this.role;
    data['isNew'] = this.isNew;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['location'] = this.location;
    data['educational_details'] = this.educationalDetail;
    data['facebook_url'] = this.fbUrl;
    data['insta_url'] = this.instaUrl;
    data['linkedin_url'] = this.liUrl;
    data['other_url'] = this.otherUrl;
    return data;
  }
}

class EducationalDetails {
  EducationalDetails({
    this.id,
    this.schoolName,
    this.qualification,
  });

  int id;
  String schoolName;
  String qualification;

  factory EducationalDetails.fromJson(Map<String, dynamic> json) =>
      EducationalDetails(
        id: json["id"],
        schoolName: json["school_name"],
        qualification: json["qualification"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['school_name'] = this.schoolName;
    data['qualification'] = this.qualification;
    return data;
  }
}

class Location {
  Location({
    this.id,
    this.addressLine2,
    this.city,
  });

  int id;
  String addressLine2;
  String city;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    addressLine2: json["address_line2"],
    city: json["city"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['address_line2'] = this.addressLine2;
    data['city'] = this.city;
    return data;
  }
}
