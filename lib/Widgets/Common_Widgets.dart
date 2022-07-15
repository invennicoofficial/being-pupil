import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import 'package:being_pupil/Constants/Const.dart';

// class Toast{
//   showToast(String message){
//     Fluttertoast.showToast(
//         msg: message,
//         //toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Constants.bgColor,
//         textColor: Colors.white,
//         fontSize: 10.0.sp
//     );
//   }
// }

class ButtonWidget extends StatelessWidget {
  final String btnName;
  final bool isActive;
  FontWeight fontWeight;
  ButtonWidget(
      {Key? key,
      required this.btnName,
      required this.isActive,
      this.fontWeight = FontWeight.w400})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: 90.0.w,
      decoration: BoxDecoration(
        color: isActive ? Constants.bgColor : Constants.disableColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(btnName,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: fontWeight,
              fontSize: 12.0.sp,
              color: isActive ? Colors.white : Colors.white54,
            )),
      ),
    );
  }
}

class NumberInputWidget extends StatelessWidget {
  var _formKey = GlobalKey<FormState>();
  FocusNode? focusNode;
  final TextEditingController textEditingController;
  bool autoFocus;
  bool isReadOnly;
  Function? validator;
  final String lable;
  NumberInputWidget(
      {Key? key,
      this.focusNode,
      required this.textEditingController,
      this.autoFocus = false,
      this.isReadOnly = false,
      this.validator,
      required this.lable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: new ThemeData(
          primaryColor: Constants.bpSkipStyle,
          primaryColorDark: Constants.bpSkipStyle,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 3.0.h, left: 3.0.w, right: 3.0.w),
          child: Container(
            height: 48.0,
            width: 90.0.w,
            child: TextFormField(
              focusNode: focusNode,
              controller: textEditingController,
              autofocus: autoFocus,
              readOnly: isReadOnly,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: lable, //"Phone Number",
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
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
              style: new TextStyle(fontFamily: "Montserrat", fontSize: 10.0.sp),
              // onChanged: (val) {
              //   _formKey.currentState!.validate();
              // },
              // validator: (val){
              //   if( val!.isEmpty || val.length < 10 || RegExp(r"^[6-9]\d{9}$").hasMatch(val)){
              //     return 'Enter Valid Phone Number';
              //   }
              //   return null;
              // },
            ),
          ),
        ));
  }
}

class TextInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String lable;
  bool isIdField;
  bool? isReadOnly;
  TextInputWidget(
      {Key? key,
      required this.textEditingController,
      required this.lable,
      this.isIdField = false,
      this.isReadOnly,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: new ThemeData(
        primaryColor: Constants.bpSkipStyle,
        primaryColorDark: Constants.bpSkipStyle,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 3.0.h, left: 3.0.w, right: 3.0.w),
        child: Container(
          height: 48.0,
          width: 90.0.w,
          child: TextFormField(
            controller: textEditingController,
            readOnly: isReadOnly ?? false,
            inputFormatters: [
              isIdField
                  ? LengthLimitingTextInputFormatter(15)
                  : LengthLimitingTextInputFormatter(200),
            ],
            decoration: InputDecoration(
              labelText: lable,
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
                ),
              ),
            ),
            style: new TextStyle(fontFamily: "Montserrat", fontSize: 10.0.sp),
          ),
        ),
      ),
    );
  }
}

class LinkInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String lable;
  bool moreLink;
  LinkInputWidget(
      {Key? key,
      required this.textEditingController,
      required this.lable,
      this.moreLink = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: new ThemeData(
          primaryColor: Constants.bpSkipStyle,
          primaryColorDark: Constants.bpSkipStyle,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 3.0.h, left: 3.0.w, right: 3.0.w),
          child: Container(
            height: 48.0,
            width: moreLink ? 80.0.w : 90.0.w,
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                  labelText: lable,
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
                  suffixIconConstraints: BoxConstraints(
                    maxHeight: 30.0,
                    maxWidth: 30.0,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 2.0.w),
                    child: Image.asset(
                      'assets/icons/link.png',
                      color: Constants.formBorder,
                    ),
                  )), //keyboardType: TextInputType.emailAddress,
              style: new TextStyle(fontFamily: "Montserrat", fontSize: 10.0.sp),
            ),
          ),
        ));
  }
}

class MultilineTextInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hint;
  const MultilineTextInput({
    Key? key,
    required this.textEditingController,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
          data: new ThemeData(
            primaryColor: Constants.bpSkipStyle,
            primaryColorDark: Constants.bpSkipStyle,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 3.0.h),
            child: Container(
              height: 13.0.h,
              width: 90.0.w,
              child: TextFormField(
                controller: textEditingController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
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
                      ),
                    ),
                    hintText: hint),
                style:
                    new TextStyle(fontFamily: "Montserrat", fontSize: 10.0.sp),
              ),
            ),
          ),
        );
  }
}
