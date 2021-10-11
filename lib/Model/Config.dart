class Config{

  static const String baseUrl = "http://13.233.57.156/being-pupil-backend/public/api/";
  //TODO replace API Key
  static const String locationKey = "AIzaSyBdxRyXCjoupZOKXtv6_mjTOkpnqcSPstI";

  static const String signupUrl = baseUrl + "user/signup";
  static const String otpUrl = baseUrl + "user/verify_otp";
  static const String loginUrl = baseUrl + "user/login";
  static const String updateProfileUrl = baseUrl + "user/profile/update";
  static const String createPostUrl = baseUrl + "user/post/create";
  static const String getEducatorPostUrl = baseUrl + "user/post/get/";
  static const String getReportIssueListUrl = baseUrl + "user/report/getIssues";
  static const String reportIssueUrl = baseUrl + "user/report/post";
  static const String categoryListUrl = baseUrl + "user/category/get";
  static const String skillListUrl = baseUrl + "user/skills/get";
  static const String hobbieListUrl = baseUrl + "user/hobbies/get";
  static const String profileDetailsUrl = baseUrl + "user/get-profile-details";
  static const String postDeleteUrl = baseUrl + "user/post/delete";
  static const String myProfileUrl = baseUrl + "user/profile";
  static const String savePostUrl = baseUrl + "user/post/save";
  static const String getSavePostUrl = baseUrl + "post/saved/get/";
  static const String getAllPostUrl = baseUrl + "post/get";
  static const String getConnectionUrl = baseUrl + "user/connection/";
}






//? Shered Preffrence 
//RegisterAs = user role
//userId = user id for both user