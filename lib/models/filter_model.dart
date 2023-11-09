import 'dart:convert';

class FilterModel {
  final String? displayStartDate;
  final String? displayEndDate;
  final String? apiStartDate;
  final String? apiEndDate;
  final String? status;
  final int? statusId;
  final String? categoryId;

  FilterModel({
    this.displayEndDate,
    this.displayStartDate,
    this.apiStartDate,
    this.apiEndDate,
    this.status,
    this.statusId,
    this.categoryId,
  });

  factory FilterModel.fromRawJson(String str) =>
      FilterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
        displayEndDate: json["displayEndDate"],
        displayStartDate: json["displayStartDate"],
        apiStartDate: json["apiStartDate"],
        apiEndDate: json["apiEndDate"],
        status: json["status"],
        statusId: json["statusId"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "displayEndDate": displayEndDate,
        "displayStartDate": displayStartDate,
        "apiStartDate": apiStartDate,
        "apiEndDate": apiEndDate,
        "status": status,
        "statusId": statusId,
        "categoryId": categoryId,
      };
}
