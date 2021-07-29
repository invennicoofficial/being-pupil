import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReportFeed extends StatefulWidget {
  const ReportFeed({Key key}) : super(key: key);

  @override
  _ReportFeedState createState() => _ReportFeedState();
}

class _ReportFeedState extends State<ReportFeed> {
  bool isOther = false;
  TextEditingController _detailController = TextEditingController();

  Widget detailedBox() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.0.h, left: 3.0.w, right: 3.0.w),
              child: Text(
                'Detailed Description',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0.sp,
                    color: Constants.bgColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        Theme(
          data: new ThemeData(
            primaryColor: Constants.bpSkipStyle,
            primaryColorDark: Constants.bpSkipStyle,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 1.0.h),
            child: Container(
              height: 13.0.h,
              width: 90.0.w,
              child: TextFormField(
                controller: _detailController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                //maxLength: 100,
                decoration: InputDecoration(
                    //labelText: "Please mention your achivements...",
                    //counterText: '',
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
                    hintText: "Add Detailed Description"),
                //keyboardType: TextInputType.emailAddress,
                style:
                    new TextStyle(fontFamily: "Montserrat", fontSize: 10.0.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: Text(
          'Report Issue',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            ListView.builder(
                itemCount: 9,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
                      onTap: () {
                        setState(() {
                          index == 8 ? isOther = true : isOther = false;
                        });
                        print(isOther ? 'Other' : 'NotOther');
                      },
                      title: Text(
                        index == 8 ? 'Other' : 'Report Issue ${index + 1}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Constants.bgColor),
                      ));
                }),
            isOther ? detailedBox() : Container(),
            SizedBox(
              height: 10.0.h,
            ),
            Container(
              height: 7.0.h,
              width: 90.0.w,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Constants.bgColor,
                  ),
                  color: Constants.bgColor,
                  borderRadius: BorderRadius.circular(5.0)),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 11.0.sp,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 3.0.h,
            ),
          ],
        ),
      ),
    );
  }
}
