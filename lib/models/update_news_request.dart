import 'dart:io';

class UpdateNewsRequest {
  String? id;
  String? heading;
  String? subHeading;
  String? newsContent;
  String? durationInMin;
  String? locationId;
  List<String>? categoryIdsList;
  String? languageId;
  String? status;
  String? newsType;
  int? newsTypeId;
  List<File>? files;
  List<String>? deleteFiles;

  UpdateNewsRequest({
    this.id,
    this.heading,
    this.subHeading,
    this.newsContent,
    this.durationInMin,
    this.locationId,
    this.categoryIdsList,
    this.languageId,
    this.status,
    this.files,
    this.deleteFiles,
    this.newsType,
    this.newsTypeId,
  });
}
