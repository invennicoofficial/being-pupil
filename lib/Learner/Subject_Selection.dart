import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

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
  ];
  double _fontSize = 14;
  int? _value = 1;
  List _selectedItem = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    //_getAllItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constants.bgColor,
          title: Text('Subjects',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 2.0.h),
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
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 1.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Search bar
            // TextField(
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(),
            //     hintText: 'Enter a search term',
            //   ),
            // ),
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
                        labelText: "Search for subject of expertise",
                        labelStyle: TextStyle(
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
                          maxHeight: 30.0,
                          maxWidth: 30.0,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 2.0.w),
                          child: Image.asset(
                            'assets/icons/search.png',
                            color: Constants.formBorder,
                          ),
                        )), //keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                        fontFamily: "Montserrat", fontSize: 10.0.sp),
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
                                  fontWeight: FontWeight.w400,
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
                _items.length,
                (int index) {
                  return ChoiceChip(
                    backgroundColor: Colors.transparent,
                    selectedColor: Colors.transparent,
                    side: BorderSide(color: Constants.bpOnBoardSubtitleStyle),
                    label: Text(_items[index],
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bpOnBoardSubtitleStyle)),
                    selected: _value == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _value = selected ? index : null;
                      });
                      if (_selectedItem.contains(_items[index])) {
                      } else {
                        if (_selectedItem.length < 25) {
                          _selectedItem.add(_items[index]);
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

// Allows you to get a list of all the ItemTags
  // _getAllItem() {
  //   List<Item>? lst = _tagStateKey.currentState?.getAllItem;
  //   if (lst != null)
  //     lst.where((a) => a.active == true).forEach((a) => print(a.title));
  // }

  Widget _buildChip(int index, String ingredient) {
    return Chip(
      label: Text(ingredient, style: TextStyle(color: Constants.bgColor)),
      backgroundColor: Colors.transparent,
      //deleteIcon: Icon(Icons.close, size: 20),
      labelPadding: EdgeInsets.fromLTRB(5, 2, 1, 2),
      elevation: 5,
      // onDeleted: (){
      //   setState(() {
      //     _items.removeAt(index);
      //   });
      // },
    );
  }
}
