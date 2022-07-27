class SignUp {
  bool? status;
  String? errorCode;
  String? errorMsg;
  String? message;
  Data? data;

  SignUp({this.status, this.errorCode, this.errorMsg, this.message, this.data});

  SignUp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['error_code'];
    errorMsg = json['error_msg'];
    message = json['message'];
    data = json['status'] == true
        ? new Data.fromJson(json['data'])
        : new Data.toEmpty(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error_code'] = this.errorCode;
    data['error_msg'] = this.errorMsg;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? mobileNumber;
  String? isNew;

  Data({this.userId, this.name, this.mobileNumber, this.isNew});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    mobileNumber = json['mobile_number'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['isNew'] = this.isNew;
    return data;
  }

  Data.toEmpty(List<dynamic>? json) {
    return;
  }
}
