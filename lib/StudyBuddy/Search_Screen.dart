import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Learner/Connection_API.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class SearchScreen extends StatefulWidget {
  String searchIn;
  SearchScreen({Key key, this.searchIn}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> map;
  List<dynamic> mapData;
  ScrollController _scrollController = ScrollController();
  ConnectionAPI connect = ConnectionAPI();
  int page = 1;
  int k = 0;
  bool isLoading = false;
  String authToken;

  List<int> _userId = [];
  List<String> _profileImage = [];
  List<String> _name = [];
  List<String> _lastDegree = [];
  List<String> _schoolName = [];
  List<String> _date = [];
  List<String> _distance = [];
  List<String> _status = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map<String, dynamic> actionMap;
  
   @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    // getLearnerListApi(page);
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     if (page > 1) {
    //       if (learner.data.length > 0) {
    //         page++;
    //         getLearnerListApi(page);
    //         //print(_name);
    //         print(page);
    //       }
    //     } else {
    //       page++;
    //       getLearnerListApi(page);
    //       print(_name);
    //       print(page);
    //     }
    //   }
    // });
  }

 void _onLoading() async {
    //if (mounted) setState(() {});
    // if (request.data.length > 0) {
    //   //_refreshController.loadComplete();
    //   _refreshController.requestLoading();
    // } else {
    _refreshController.loadComplete();
    _refreshController.loadNoData();
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Center(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.text = '';
                    FocusScope.of(context).unfocus();
                  },
                ),
                hintText: 'Search by name and city...',
                border: InputBorder.none),
                onChanged: (value){
                  Future.delayed(Duration(seconds: 2));
                  // if(widget.searchIn == 'C' || widget.searchIn == 'R'){
                    searchApi(value);
                  // } else if(widget.searchIn == 'E' || widget.searchIn == 'L'){
                  //   searchApiTwo(value);
                  // }
                  setState((){});
                },
          ),
        ),
      ),
      leading:IconButton(
          icon: Icon(
            Icons.west_rounded,
            color: Colors.white,
            size: 35.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
        ),
      ),
      body: isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Constants.bgColor),
            ),
          )
        :
        // SingleChildScrollView(
        //     controller: _scrollController,
        //     physics: BouncingScrollPhysics(),
        //     child:
        SmartRefresher(
            controller: _refreshController,
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadStyle: LoadStyle.ShowWhenLoading,
              noDataText: 'No More Connection',
              //noMoreIcon: Icon(Icons.refresh_outlined),
            ),
            onLoading: _onLoading,
            child: widget.searchIn == 'R'
            ? ListView.builder(
                controller: _scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                //physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _userId.length == 0 ? 0 : _userId.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Container(
                        height: 10.0.h,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          //leading:
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // registerAs == 'E'
                                  //     ? pushNewScreen(context,
                                  //         screen: EducatorProfileViewScreen(),
                                  //         withNavBar: false,
                                  //         pageTransitionAnimation:
                                  //             PageTransitionAnimation.cupertino)
                                  //     : pushNewScreen(context,
                                  //         screen: LearnerProfileViewScreen(),
                                  //         withNavBar: false,
                                  //         pageTransitionAnimation:
                                  //             PageTransitionAnimation
                                  //                 .cupertino);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    _profileImage[index],
                                    width: 8.5.w,
                                    height: 5.0.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: 2.0.w,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(right: 13.0.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _name[index],
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      //color: Colors.grey,
                                      width: 25.0.w,
                                      child: Text(
                                        _lastDegree[index] != null &&
                                                _schoolName[index] != null
                                            ? '${_lastDegree[index]} | ${_schoolName[index]}'
                                            : '',
                                        style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Constants.bgColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Buttons
                              Padding(
                                padding: EdgeInsets.only(right: 2.0.w),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('$index is Rejected');
                                        requestActionApi(_userId[index], 'R');
                                      },
                                      child: Container(
                                        height: 3.5.h,
                                        width: 16.0.w,
                                        decoration: BoxDecoration(
                                            color: Constants.bgColor,
                                            border: Border.all(
                                                color: Constants.bgColor,
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            'Reject',
                                            style: TextStyle(
                                                fontSize: 8.0.sp,
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print('$index is Connected');
                                        requestActionApi(_userId[index], 'A');
                                      },
                                      child: Container(
                                        height: 3.5.h,
                                        width: 16.0.w,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Constants.bgColor,
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            'Connect',
                                            style: TextStyle(
                                                fontSize: 8.0.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
             : ListView.builder(
              controller: _scrollController,
                padding:
                    EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
                //physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _userId.length == 0 ? 0 : _userId.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0.w),
                      child: Container(
                        height: 10.0.h,
                        child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // registerAs == 'E'
                                    //     ? pushNewScreen(context,
                                    //         screen: EducatorProfileViewScreen(),
                                    //         withNavBar: false,
                                    //         pageTransitionAnimation:
                                    //             PageTransitionAnimation.cupertino)
                                    //     : pushNewScreen(context,
                                    //         screen: LearnerProfileViewScreen(),
                                    //         withNavBar: false,
                                    //         pageTransitionAnimation:
                                    //             PageTransitionAnimation
                                    //                 .cupertino);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      _profileImage[index],
                                      //connection.data[index].profileImage,
                                      width: 40.0,
                                      height: 40.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.0.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _name[index],
                                      //connection.data[index].name,
                                      style: TextStyle(
                                          fontSize: 9.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      width: 45.0.w,
                                      //color: Colors.grey,
                                      child: Text(
                                        _lastDegree[index] != null &&
                                                _schoolName[index] != null
                                            ? '${_lastDegree[index]} | ${_schoolName[index]}'
                                            : '',
                                        // connection.data[index].lastDegree != null && connection.data[index].schoolName != null
                                        // ? "${connection.data[index].lastDegree} | ${connection.data[index].schoolName}" : '',
                                        style: TextStyle(
                                            fontSize: 6.5.sp,
                                            color: Constants.bgColor,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w400),
                                            overflow: TextOverflow.clip
                                      ),
                                    ),
                                  ],
                                ),
                                //for request list
                                
                              ],
                            ),
                            trailing: widget.searchIn == 'C'
                            ? Padding(
                              padding: EdgeInsets.only(right: 2.0.w, top: 2.0.h),
                              child: GestureDetector(
                                onTap: () {
                                  print('$index is Connected');
                                },
                                child: _status[index] == '0'
                                    //connection.data[index].status == '0'
                                    ? Container(
                                        height: 3.5.h,
                                        width: 25.0.w,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Constants.bgColor,
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            'Request Sent',
                                            style: TextStyle(
                                                fontSize: 8.0.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 3.5.h,
                                        width: 16.0.w,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Constants.bgColor,
                                                width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        child: Center(
                                          child: Text(
                                            'Chat',
                                            style: TextStyle(
                                                fontSize: 8.0.sp,
                                                color: Constants.bgColor,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                              ),
                            )
                            : widget.searchIn == 'E' || widget.searchIn == 'L'
                            ? Padding(
                              padding:
                                  EdgeInsets.only(right: 2.0.w, top: 2.0.h),
                              child: GestureDetector(
                                onTap: () async{
                                  print('$index is Connected');
                                  await connect.connectionApi(_userId[index], authToken);
                                  // setState(() {
                                  //   isLoading = true;
                                  //   page = 1;
                                  //   _userId = [];
                                  //   _profileImage = [];
                                  //   _name = [];
                                  //   _lastDegree = [];
                                  //   _schoolName = [];
                                  //   _date = [];
                                  //   _distance = [];
                                  // });         
                                 // getEducatorListApi(page);
                                },
                                child: Container(
                                  height: 3.5.h,
                                  width: 16.0.w,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants.bgColor, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Center(
                                    child: Text(
                                      'Connect',
                                      style: TextStyle(
                                          fontSize: 8.0.sp,
                                          color: Constants.bgColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ) : Container()
                            ),
                      ),
                    ),
                  );
                }),
          )
    );
  }
 
 //Search API for connection and Request Tab
 Future<void> searchApi(String search) async {
    //var delResult = PostDelete();
  
  setState(() {
    isLoading =true;
  });
    try {
      Dio dio = Dio();

      //FormData formData = FormData.fromMap({'search_in': widget.searchIn, 'search': searchController.text});
      var response = await dio.get('${Config.searchUserUrl}?search_in=${widget.searchIn}&search=$search',
          //data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map['data'];
        //saveMapData = map['data']['status'];

        print(mapData);
        // setState(() {
        //   isLoading = false;
        // });
        print('LENGTH: ' + mapData.length.toString());
        _userId = [];
        _profileImage = [];
        _name = [];
        _lastDegree = [];
        _schoolName = [];
        _status = [];
        _date = [];
        _distance = [];
        setState((){});
        if (mapData.length > 0) {
          for (int i = 0; i < mapData.length; i++) {
            _userId.add(mapData[i]['user_id']);
            _profileImage.add(mapData[i]['profile_image']);
            _name.add(mapData[i]['name']);
            _lastDegree.add(mapData[i]['last_degree']);
            _schoolName.add(mapData[i]['school_name']);
            _date.add(mapData[i]['date']);
            if(widget.searchIn == 'C' || widget.searchIn == 'R'){
               _status.add(mapData[i]['status']);
            } else //if(widget.searchIn == 'E' || widget.searchIn == 'L')
            {
              _distance.add(mapData[i]['distance']);
            }
           
            
          }
          // k++;
          // print(k);
          print(_profileImage);
          print(_lastDegree);
          print(_schoolName);
          print(_distance);

          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }

  //Search API for Educator List and Learner Tab
 Future<void> searchApiTwo(String search) async {
    //var delResult = PostDelete();
  
  setState(() {
    isLoading =true;
  });
    try {
      Dio dio = Dio();

      //FormData formData = FormData.fromMap({'search_in': widget.searchIn, 'search': searchController.text});
      var response = await dio.get('${Config.searchUserUrl}?search_in=${widget.searchIn}&search=$search',
          //data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        map = response.data;
        mapData = map['data'];
        //saveMapData = map['data']['status'];

        print(mapData);
        // setState(() {
        //   isLoading = false;
        // });
        print('LENGTH: ' + mapData.length.toString());
        _userId = [];
        _profileImage = [];
        _name = [];
        _lastDegree = [];
        _schoolName = [];
        _date = [];
        _distance = [];
        setState((){});
        if (mapData.length > 0) {
          for (int i = 0; i < mapData.length; i++) {
            _userId.add(mapData[i]['user_id']);
            _profileImage.add(mapData[i]['profile_image']);
            _name.add(mapData[i]['name']);
            _lastDegree.add(mapData[i]['last_degree']);
            _schoolName.add(mapData[i]['school_name']);
            _date.add(mapData[i]['date']);
            _distance.add(mapData[i]['distance']);
            //_distance.add(mapData[i].distance);
          }
          // k++;
          // print(k);
          print(_profileImage);
          print(_lastDegree);
          print(_schoolName);

          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          setState(() {});
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (e, stack) {
      // closeProgressDialog(context);
      print(e.response);
      print(stack);
    }
  }

//For request Action
   Future<void> requestActionApi(int reqId, String action) async {
    //var delResult = PostDelete();

    try {
      Dio dio = Dio();

      FormData formData =
          FormData.fromMap({'request_id': reqId, 'action': action});
      var response = await dio.post(Config.requestActionUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));

      if (response.statusCode == 200) {
        //delResult = postDeleteFromJson(response.data);
        actionMap = response.data;
        //saveMapData = map['data']['status'];

        print(actionMap);
        // setState(() {
        //   isLoading = false;
        // });
        if (actionMap['status'] == true) {
          print('true');
          // setState(() {
          //   isLoading = true;
          //   page = 1;
          //   _userId = [];
          //   _profileImage = [];
          //   _name = [];
          //   _lastDegree = [];
          //   _schoolName = [];
          //   _status = [];
          // });
          //getRequestApi(page);
          Fluttertoast.showToast(
              msg: actionMap['message'],
              backgroundColor: Constants.bgColor,
              gravity: ToastGravity.BOTTOM,
              fontSize: 10.0.sp,
              toastLength: Toast.LENGTH_SHORT,
              textColor: Colors.white);
        } else {
          print('false');
          if (actionMap['message'] == null) {
            Fluttertoast.showToast(
                msg: actionMap['error_msg'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: actionMap['message'],
                backgroundColor: Constants.bgColor,
                gravity: ToastGravity.BOTTOM,
                fontSize: 10.0.sp,
                toastLength: Toast.LENGTH_SHORT,
                textColor: Colors.white);
          }
        }
        //getEducatorPostApi(page);
        //print(saveMap);
      } else {
        print(response.statusCode);
      }
    } on DioError catch (e, stack) {
      print(e.response);
      print(stack);
    }
  }

}
