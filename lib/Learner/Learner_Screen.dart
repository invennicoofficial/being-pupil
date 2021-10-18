import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Learner/Connection_API.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Model/Learner_List_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class LearnerScreen extends StatefulWidget {
  LearnerScreen({Key key}) : super(key: key);

  @override
  _LearnerScreenState createState() => _LearnerScreenState();
}

class _LearnerScreenState extends State<LearnerScreen> {

   String registerAs, authToken;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int k = 0;

  bool isLoading = true;
  LearnerListModel learner = LearnerListModel();
  ConnectionAPI connect = ConnectionAPI();

  List<int> _userId = [];
  List<String> _profileImage = [];
  List<String> _name = [];
  List<String> _lastDegree = [];
  List<String> _schoolName = [];
  List<String> _date = [];
  List<String> _distance = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    print(authToken);
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      registerAs = preferences.getString('RegisterAs');
    });
    getLearnerListApi(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page > 1) {
          if (learner.data.length > 0) {
            page++;
            getLearnerListApi(page);
            print(_name);
            print(page);
          }
        } else {
          page++;
          getLearnerListApi(page);
          print(_name);
          print(page);
        }
      }
    });
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
        automaticallyImplyLeading: false,
        backgroundColor: Constants.bgColor,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.west_rounded,
        //     color: Colors.white,
        //     size: 35.0,
        //   ),
        //   onPressed: //null,
        //       () {
        //     Navigator.of(context).pop();
        //   },
        //   padding: EdgeInsets.zero,
        // ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null)
        ],
        title: Text(
          'Learners',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
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
              noDataText: 'No More Learners',
              //noMoreIcon: Icon(Icons.refresh_outlined),
            ),
            onLoading: _onLoading,
        child: ListView.builder(
          controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                _profileImage[index],
                                width: 8.5.w,
                                height: 5.0.h,
                                fit: BoxFit.cover,
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
                                  style: TextStyle(
                                      fontSize: 9.0.sp,
                                      color: Constants.bgColor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700),
                                ),
                                Container(
                                  width: 55.0.w,
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
                          ],
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 2.0.w, top: 2.0.h),
                          child: GestureDetector(
                            onTap: () async{
                                  print('$index is Connected');
                                  await connect.connectionApi(_userId[index], authToken);
                                  setState(() {
                                    isLoading = true;
                                    page = 1;
                                    _userId = [];
                                    _profileImage = [];
                                    _name = [];
                                    _lastDegree = [];
                                    _schoolName = [];
                                    _date = [];
                                    _distance = [];
                                  });         
                                  getLearnerListApi(page);
                                },
                            child: Container(
                              height: 3.0.h,
                              width: 16.0.w,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Constants.bgColor, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Center(
                                child: Text(
                                  'Connect',
                                  style: TextStyle(
                                      fontSize: 8.0.sp,
                                      color: Constants.bgColor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              );
            }),
      ),
    );
  }

   //Get Learner List API
  Future<void> getLearnerListApi(int page) async {
    // displayProgressDialog(context);

    try {
      Dio dio = Dio();

      var response = await dio.get('${Config.getLearnerListUrl}?page=$page',
          options: Options(headers: {"Authorization": 'Bearer ' + authToken}));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // closeProgressDialog(context);
        //return EducatorPost.fromJson(json)
        //result = EducatorPost.fromJson(response.data);
        learner = LearnerListModel.fromJson(response.data);

        print(learner.data[0].name);

        if (learner.data.length > 0) {
          for (int i = 0; i < learner.data.length; i++) {
            _userId.add(learner.data[i].userId);
            _profileImage.add(learner.data[i].profileImage);
            _name.add(learner.data[i].name);
            _lastDegree.add(learner.data[i].lastDegree);
            _schoolName.add(learner.data[i].schoolName);
            _date.add(learner.data[i].date);
            _distance.add(learner.data[i].distance);
          }

          print(_name);

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
}
