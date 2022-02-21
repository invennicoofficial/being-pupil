import 'package:being_pupil/Constants/Const.dart';
import 'package:being_pupil/Model/Config.dart';
import 'package:being_pupil/Widgets/Progress_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as storage;

class SubjectSelectionScreen extends StatefulWidget {
  SubjectSelectionScreen({Key? key}) : super(key: key);

  @override
  _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List _items = [
    'Chemestry',
    'Sceince',
    'Physics',
    'Master',
    'Computer',
    'BCA',
    'Logistic',
    'Flutter',
    'IOS',
    'Android',
    'Mathematics',
    'React',
    'PHP',
    'Laravel',
    'Chemestry1',
    'Sceince1',
    'Physics1',
    'Master1',
    'Computer1',
    'BCA1',
    'Logistic1',
    'Flutter1',
    'IOS1',
    'Android1',
    'Mathematics1',
    'React1',
    'PHP1',
    'Laravel1',
    'Chemestry d',
    'Sceince d',
    'Physics d',
    'Master d',
    'Computer d',
    'BCA d',
    'Logistic d',
    'Flutter d',
    'IOS d',
    'Android d',
    'Mathematics d',
    'React d',
    'PHP d',
    'Laravel d',
  ];
  double _fontSize = 14;
  int? _value = 1;
  List _selectedItem = [];
  TextEditingController searchController = TextEditingController();
  String? authToken;
  Map<String, dynamic>? subjectMap = Map<String, dynamic>();
  List<dynamic>? subjectMapData = []; //List();
  bool isLoading = true;
  Map<String, dynamic>? selectedSubMap = Map<String, dynamic>();
  Map<String, dynamic>? selectedSubjectMap = Map<String, dynamic>();
  List<dynamic> selectedSubjectMapData = [];

  @override
  void initState() {
    //_getAllItem();
    super.initState();
    getToken();
  }

  void getToken() async {
    authToken = await storage.FlutterSecureStorage().read(key: 'access_token');
    await getSelectedSubjectListForLearner();
    getFilteredSubjectListForLearner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constants.bgColor,
          leading: IconButton(
            icon: Icon(
              Icons.west_rounded,
              color: Colors.white,
              size: 35.0,
            ),
            onPressed: //null,
                () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.zero,
          ),
          title: Text('Subjects',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white))),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Constants.bgColor),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Theme(
                    data: new ThemeData(
                      primaryColor: Constants.bpSkipStyle,
                      primaryColorDark: Constants.bpSkipStyle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0.h),
                      child: Container(
                        height: 7.0.h,
                        width: 90.0.w,
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "Search for subject of expertise",
                              hintStyle: TextStyle(
                                  color: Constants.bpSkipStyle,
                                  fontFamily: "Montserrat",
                                  fontSize: 10.0.sp),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Constants.formBorder,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Constants.formBorder,
                                  //width: 2.0,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                maxHeight: 35.0,
                                maxWidth: 35.0,
                              ),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 2.0.w),
                                child: Image.asset(
                                  'assets/icons/search.png',
                                  color: Constants.formBorder,
                                ),
                              )), //keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                              fontFamily: "Montserrat", fontSize: 10.0.sp),
                          onChanged: (value) {
                            Future.delayed(Duration(seconds: 2));
                            searchSubjects(value);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),

                  //Selected Subjects
                  Wrap(
                    spacing: 8,
                    children: List<Widget>.generate(
                      _selectedItem == null ? 0 : _selectedItem.length,
                      (int index) {
                        return ChoiceChip(
                          backgroundColor: Constants.selectedIcon,
                          selectedColor: Constants.selectedIcon,
                          //side: BorderSide(color: Constants.bpOnBoardSubtitleStyle),
                          label: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedItem.removeAt(index);
                              });
                              print('NEWLLLL' + _selectedItem.toString());
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedItem[index],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF231F20))),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Icon(Icons.close,
                                    size: 20.0, color: Color(0xFF231F20)),
                              ],
                            ),
                          ),
                          selected: true,
                          onSelected: (bool selected) {
                            setState(() {
                              //_value = selected ? index : null;
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),

                  //Count text
                  _selectedItem.length == 0
                      ? Container()
                      : Text('${_selectedItem.length} subjects are selected',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 8.0.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF6B737C))),
                  //Divider
                  _selectedItem.length == 0
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.0.h),
                          child: Divider(
                            height: 0.5.h,
                            thickness: 0.5,
                            color: Color(0xFFA8B4C1),
                          ),
                        ),
                  //All subjects
                  Wrap(
                    spacing: 8,
                    children: List<Widget>.generate(
                      subjectMapData!.length,
                      (int index) {
                        return ChoiceChip(
                          backgroundColor: Colors.transparent,
                          selectedColor: Colors.transparent,
                          side: BorderSide(
                              color: Constants.bpOnBoardSubtitleStyle),
                          label: Text(subjectMapData![index],
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.bpOnBoardSubtitleStyle)),
                          selected: _value == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _value = selected ? index : null;
                            });
                            if (_selectedItem
                                .contains(subjectMapData![index])) {
                            } else {
                              if (_selectedItem.length < 25) {
                                _selectedItem.add(subjectMapData![index]);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "You can add only 25 subjects",
                                    backgroundColor: Constants.bgColor,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 10.0.sp,
                                    toastLength: Toast.LENGTH_SHORT,
                                    textColor: Colors.white);
                              }
                            }

                            print('LLLLL' + _selectedItem.toString());
                          },
                        );
                      },
                    ).toList(),
                  ),

                  //Continue Button
                  Padding(
                    padding: EdgeInsets.only(top: 15.0.h),
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences preff =
                            await SharedPreferences.getInstance();
                        preff.setBool("isSubjectSelected", true);
                        //setState(() {});
                        postSubjectForLearner(_selectedItem.toString());
                      },
                      child: Container(
                        height: 7.0.h,
                        width: 90.0.w,
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          color: Constants.bpOnBoardTitleStyle,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            color: Constants.formBorder,
                            width: 0.15,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Continue'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 11.0.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
              // Tags(
              //   key: _tagStateKey,
              //   textField: TagsTextField(
              //     textStyle: TextStyle(fontSize: _fontSize),
              //     constraintSuggestion: true, suggestions: [],
              //     //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
              //     onSubmitted: (String str) {
              //       // Add item to the data source.
              //       setState(() {
              //         // required
              //         _items.add(Item(
              //           title: str,
              //           active: true,
              //           index: 1,
              //         ));
              //       });
              //     },
              //   ),
              //   itemCount: _items.length, // required
              //   itemBuilder: (int index) {
              //     final item = _items[index];

              //     return ItemTags(
              //       // Each ItemTags must contain a Key. Keys allow Flutter to
              //       // uniquely identify widgets.
              //       key: Key(index.toString()),
              //       index: index, // required
              //       title: item.title,
              //       active: item.active,
              //       customData: item.customData,
              //       textStyle: TextStyle(
              //         fontSize: _fontSize,
              //       ),
              //       combine: ItemTagsCombine.withTextBefore,
              //       image: ItemTagsImage(
              //           image: AssetImage(
              //               "assets/icons/apple.png") // OR NetworkImage("https://...image.png")
              //           ), // OR null,
              //       icon: ItemTagsIcon(
              //         icon: Icons.add,
              //       ), // OR null,
              //       removeButton: ItemTagsRemoveButton(
              //         onRemoved: () {
              //           // Remove the item from the data source.
              //           setState(() {
              //             // required
              //             _items.removeAt(index);
              //           });
              //           //required
              //           return true;
              //         },
              //       ), // OR null,
              //       onPressed: (item) => print(item),
              //       onLongPressed: (item) => print(item),
              //     );
              //   },
              // ),

//         Wrap(
//    children: _items.asMap().map(
//       (index, ingredient) => MapEntry(index, _buildChip(index, ingredient))
//     ).values.toList(),
//     spacing: 6,
//     runSpacing: 3,
// ),
              ),
    );
  }

//Get filter subject list for learner
  getFilteredSubjectListForLearner() async {
    //displayProgressDialog(context);
    //var result = CategoryList();

    try {
      Dio dio = Dio();
      var option = Options(headers: {"Authorization": 'Bearer ' + authToken!});
      var response = await dio.get(Config.getFilteredListUrl, options: option);

      if (response.statusCode == 200) {
        //closeProgressDialog(context);
        subjectMap = response.data;
        setState(() {
          subjectMapData = subjectMap!['data'];
        });

        isLoading = false;
        setState(() {});

        //closeProgressDialog(context);
      } else {
        //closeProgressDialog(context);
        if (subjectMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: subjectMap!['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      //closeProgressDialog(context);
      if (e.response != null) {
        print(e.message);
        print(stack);
      }
    }
  }

  //Search in subjects
  searchSubjects(String search) async {
    //displayProgressDialog(context);
    //var result = CategoryList();

    try {
      Dio dio = Dio();
      var option = Options(headers: {"Authorization": 'Bearer ' + authToken!});
      var response = await dio
          .get('${Config.getFilteredListUrl}?search=$search', options: option);

      if (response.statusCode == 200) {
        //closeProgressDialog(context);
        subjectMap = response.data;
        setState(() {
          subjectMapData = subjectMap!['data'];
        });

        isLoading = false;
        setState(() {});

        //closeProgressDialog(context);
      } else {
        //closeProgressDialog(context);
        if (subjectMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: subjectMap!['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      //closeProgressDialog(context);
      if (e.response != null) {
        print(e.message);
        print(stack);
      }
    }
  }

  //Get Selected subject list for learner
  getSelectedSubjectListForLearner() async {
    //displayProgressDialog(context);
    //var result = CategoryList();

    try {
      Dio dio = Dio();
      var option = Options(headers: {"Authorization": 'Bearer ' + authToken!});
      var response =
          await dio.get(Config.getSelectedSubjectUrl, options: option);

      if (response.statusCode == 200) {
        //closeProgressDialog(context);
        selectedSubjectMap = response.data;
        debugPrint('SELECTED:::' + selectedSubjectMap.toString());
        if (selectedSubjectMap!['status'] == true) {
          setState(() {
            selectedSubjectMapData = selectedSubjectMap!['data'];
            _selectedItem.addAll(selectedSubjectMapData);
          });

          isLoading = false;
          setState(() {});

          //closeProgressDialog(context);
        } else {
          Fluttertoast.showToast(
            msg: selectedSubjectMap!['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      } else {
        //closeProgressDialog(context);
        if (selectedSubjectMap!['error_msg'] != null) {
          Fluttertoast.showToast(
            msg: selectedSubjectMap!['error_msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      //closeProgressDialog(context);
      if (e.response != null) {
        print(e.message);
        print(stack);
      }
    }
  }

  //post subject for learner
  postSubjectForLearner(String subjects) async {
    displayProgressDialog(context);

    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(
          {"subjects": subjects.replaceAll('[', '').replaceAll(']', '')});

      var response = await dio.post(Config.postFilteredListUrl,
          data: formData,
          options: Options(headers: {"Authorization": 'Bearer ' + authToken!}));

      if (response.statusCode == 200) {
        selectedSubMap = response.data;
        print(response.data);
        closeProgressDialog(context);

        if (selectedSubMap!['status'] == true) {
          Navigator.pop(context, 'true');
          Fluttertoast.showToast(
            msg: selectedSubMap!['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        } else {
          Fluttertoast.showToast(
            msg: selectedSubMap!['message'] == null
                ? selectedSubMap!['error_msg']
                : selectedSubMap!['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Constants.bgColor,
            textColor: Colors.white,
            fontSize: 10.0.sp,
          );
        }
      }
    } on DioError catch (e, stack) {
      print(e.message);
      print(stack);
    }
  }

  displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new ProgressDialog();
        }));
  }

  closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
