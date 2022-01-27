import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:sizer/sizer.dart';

class SubjectSelectionScreen extends StatefulWidget {
  SubjectSelectionScreen({Key? key}) : super(key: key);

  @override
  _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List _items = ['Chemestry', 'Sceince', 'Physics', 'Master', 'Computer', 'BCA', 'Logistic', 'Flutter', 'IOS', 'Android', 'Mathematics', 'React', 'PHP', 'Laravel', ];
  double _fontSize = 14;
  int? _value = 1;

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
      body: SingleChildScrollView(
        child: 
    //     Wrap(
    //   children: List<Widget>.generate(
    //     3,
    //     (int index) {
    //       return ChoiceChip(
    //         label: Text('Item $index'),
    //         selected: _value == index,
    //         onSelected: (bool selected) {
    //           setState(() {
    //             _value = selected ? index : null;
    //           });
    //         },
    //       );
    //     },
    //   ).toList(),
    // )
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

        Wrap(
   children: _items.asMap().map(
      (index, ingredient) => MapEntry(index, _buildChip(index, ingredient))
    ).values.toList(),
    spacing: 6,
    runSpacing: 3,
),
      ),
    );
  }

// Allows you to get a list of all the ItemTags
  // _getAllItem() {
  //   List<Item>? lst = _tagStateKey.currentState?.getAllItem;
  //   if (lst != null)
  //     lst.where((a) => a.active == true).forEach((a) => print(a.title));
  // }

  Widget _buildChip(int index, String ingredient){
    return Chip(
      label: Text(ingredient, style: TextStyle(color: Constants.bgColor)),
      backgroundColor: Colors.transparent,
      //deleteIcon: Icon(Icons.close, size: 20),
      labelPadding: EdgeInsets.fromLTRB(5,2,1,2),
      elevation: 5,
      // onDeleted: (){
      //   setState(() {
      //     _items.removeAt(index);
      //   });
      // },
    );
  }
}
