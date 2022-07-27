import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showDialogError(exception, context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Something went wrong $exception"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

void showDialogMsg(msg, context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data);
}

Future<Map<int?, CubeUser?>> getUsersByIds(Set<int> ids) async {
  Completer<Map<int?, CubeUser?>> completer = Completer();
  Map<int?, CubeUser?> users = HashMap();
  try {
    var result =
        await ((getAllUsersByIds(ids) as FutureOr<PagedResult<CubeUser>?>)
            as FutureOr<PagedResult<CubeUser>>);
    users.addAll(Map.fromIterable(result.items,
        key: (item) => item.id, value: (item) => item));
  } catch (ex) {
    log("exception= $ex");
  }
  completer.complete(users);
  return completer.future;
}

Future<CubeFile> getUploadingImageFuture(FilePickerResult result) async {
  if (kIsWeb) {
    return uploadFile(File(result.files.single.path!));
  } else {
    return uploadFile(File(result.files.single.path!));
  }
}
