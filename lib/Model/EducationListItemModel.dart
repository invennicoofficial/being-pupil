
import 'dart:io';

class EducationListItemModel {
  String school_name;
  String year;
  String qualification;
  File file;

  EducationListItemModel(
      {this.school_name,
       this.year,
       this.qualification,
       this.file});
}