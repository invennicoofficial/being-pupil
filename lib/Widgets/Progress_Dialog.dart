import 'package:being_pupil/Constants/Const.dart';
import 'package:flutter/material.dart';


class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withAlpha(150),
      child: Center(
        child: new Container(
          child: new GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Constants.bgColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
