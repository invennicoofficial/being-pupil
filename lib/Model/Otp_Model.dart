//Model class for OTP
class OtpResponse {
  bool status;
  String message;
  OtpData data;

  OtpResponse({this.status, this.message, this.data});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status: json['status'],
      message: json['message'],
      data: json['status'] == true
          ? new OtpData.fromJson(json['data'])
          : new OtpData.toEmpty(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['status'] = this.status;
    data['message'] = this.message;

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OtpData {
  String token;
  UserObject userObject;

  OtpData({this.token, this.userObject});

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      token: json['access_token'],
      userObject: json['userObj'] != null || json['userObj'] != [] ? new UserObject.fromJson(json['userObj']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['access_token'] = this.token;
    data['userObj'] = this.userObject;
    return data;
  }
  OtpData.toEmpty(List<dynamic> json){
    return;
  }
}

class UserObject {
  String role;
  String isNew;

  UserObject({this.role, this.isNew});

  factory UserObject.fromJson(Map<String, dynamic> json){
    return UserObject(role: json['register_as'], isNew: json['isNew']);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['role'] = this.role;
    data['isNew'] = this.isNew;
    return data;
  }
}
