class Config{

  // static const String baseUrl = "http://13.233.57.156/being-pupil-backend/public/api/";
  //static const String baseUrl = "http://43.204.0.106/being-pupil-backend/public/api/";
  static const String baseUrl = "http://beingpupil.com/public/api/";
  //TODO replace API Key
  static const String locationKey = "AIzaSyCwOLCJW7tuZ6oRkXHuQaAnOeyQlpYIaQY";

  static const String signupUrl = baseUrl + "user/signup";
  static const String otpUrl = baseUrl + "user/verify_otp";
  static const String loginUrl = baseUrl + "user/login";
  static const String updateProfileUrl = baseUrl + "user/profile/update";
  static const String createPostUrl = baseUrl + "user/post/create";
  static const String getEducatorPostUrl = baseUrl + "user/post/get";
  static const String getReportIssueListUrl = baseUrl + "user/report/getIssues";
  static const String reportIssueUrl = baseUrl + "user/report/post";
  static const String categoryListUrl = baseUrl + "user/category/get";
  static const String skillListUrl = baseUrl + "user/skills/get";
  static const String hobbieListUrl = baseUrl + "user/hobbies/get";
  static const String profileDetailsUrl = baseUrl + "user/get-profile-details";
  static const String postDeleteUrl = baseUrl + "user/post/delete";
  static const String myProfileUrl = baseUrl + "user/profile";
  static const String savePostUrl = baseUrl + "user/post/save";
  static const String getSavePostUrl = baseUrl + "post/saved/get";
  static const String getAllPostUrl = baseUrl + "post/get";
  static const String getConnectionUrl = baseUrl + "user/connection/";
  static const String postLikeUrl = baseUrl + "user/post/like";
  static const String addCommentUrl = baseUrl + "user/post/addComment";
  static const String getRequestUrl = baseUrl + "user/request/";
  static const String getLearnerListUrl = baseUrl + "user/getLearners";
  static const String getEducatorListUrl = baseUrl + "user/getEducators";
  static const String requestActionUrl = baseUrl + "user/request/action";
  static const String connectionUrl = baseUrl + "user/connectUser";
  static const String searchUserUrl = baseUrl + "user/serach";
  static const String getCommentListUrl = baseUrl + "post/getComments/";
  static const String deleteCommentUrl = baseUrl + "user/post/comment/delete";
  static const String editCommentUrl = baseUrl + "user/post/comment/edit";
  static const String mobileCheckUrl = baseUrl + "user/check-mobile-number";
  static const String updatePostUrl = baseUrl + "user/post/update";
  static const String checkSocialLogin = baseUrl + "user/social-login-check";
  static const String createCourseUrl = baseUrl + "user/createCourse";
  static const String updateCourseUrl = baseUrl + "user/courseUpdate";
  static const String getMyCourseUrl = baseUrl + "user/getMyCourse";
  static const String getEducatorCourseUrl = baseUrl + "user/getCourse/";
  static const String enrollCourseUrl = baseUrl + "user/courseEnroll";
  static const String getEnrollCourseUrl = baseUrl + "user/enrolledCourse";
  static const String discontinueCourseUrl = baseUrl + "user/discontinueCourse";
  static const String getAllPropertyUrl = baseUrl + "property/getAll";
  static const String getPropertyUrl = baseUrl + "property/get";
  static const String bookingCheckUrl = baseUrl + "property/booking/check";
  static const String createBookingUrl = baseUrl + "property/book";
  static const String upComingBookingUrl = baseUrl + "property/booking/upcoming";
  static const String cancelledBookingUrl = baseUrl + "property/booking/cancelled";
  static const String completedBookingUrl = baseUrl + "property/booking/completed";
  static const String getOrderIdRP = baseUrl + "https://api.razorpay.com/v1/orders";
  static const String getCancelReasonList = baseUrl + "property/getCancelReasonList";
  static const String submitCancelReason = baseUrl + "property/booking/cancel";
  static const String addReviewUrl = baseUrl + "property/addReview";
  static const String getReviewUrl = baseUrl + "property/getReview";
  static const String refreshTokenUrl = baseUrl + "user/refreshToken";
  static const String unfollowUserUrl = baseUrl + "user/unfollow";
  static const String deviceTokenUrl = baseUrl + "user/send-device-token";
  static const String getAllSubjectUrl = baseUrl + "user/subjects/get";
  static const String getFilteredListUrl = baseUrl + "user/subjects/filter/get";
  static const String postFilteredListUrl = baseUrl + "user/subjects/select";
  static const String getAllPlanUrl = baseUrl + "user/plans/get";
  static const String getSelectedSubjectUrl = baseUrl + "user/subjects/selected/get";
  static const String createSubscription = baseUrl + "user/subscription/create";
  static const String verifySubscription = baseUrl + "user/subscription/verify-payment";
  static const String cencelSubscription = baseUrl + "user/plans/cancel-subscription";
  static const String currentSubscription = baseUrl + "user/plans/get/current";
  static const String updateSubscription = baseUrl + "user/subscription/update";
  static const String tearmsUrl = baseUrl + "terms";
  static const String faqUrl = baseUrl + "faqs";
  static const String privacyUrl = baseUrl + "privacy";
  static const String aboutUsUrl = baseUrl + "about-us";
}






//? Shered Preffrence 
//RegisterAs(String) = user role
//userId(int) = user id for both user
//isNew(String) = check for ew user
//isLoggedIn(bool) = check for login user