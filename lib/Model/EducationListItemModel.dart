
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class EducationListItemModel {
  String? school_name;
  String? year;
  String? qualification;
  XFile? file;

  EducationListItemModel(
      {this.school_name,
       this.year,
       this.qualification,
       this.file});
}