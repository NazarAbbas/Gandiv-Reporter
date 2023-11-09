import 'package:freezed_annotation/freezed_annotation.dart';

class StatusResponse {
  @JsonKey(name: 'status')
  int status;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'data')
  StatusData statusData;

  StatusResponse({
    required this.status,
    required this.message,
    required this.statusData,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) => StatusResponse(
        status: json["status"],
        message: json["message"],
        statusData: StatusData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": statusData.toJson(),
      };
}

class StatusData {
  @JsonKey(name: 'allStatusId')
  int? allStatusId;
  @JsonKey(name: 'allStatusName')
  String? allStatusName;
  @JsonKey(name: 'allStatusHindiName')
  String? allStatusHindiName;
  @JsonKey(name: 'allStatusCount')
  int? allStatusCount;

  @JsonKey(name: 'publishedStatusId')
  int? publishedStatusId;
  @JsonKey(name: 'publishedStatusName')
  String? publishedStatusName;
  @JsonKey(name: 'publishedStatusHindiName')
  String? publishedStatusHindiName;
  @JsonKey(name: 'publishedStatusCount')
  int? publishedStatusCount;

  @JsonKey(name: 'approvedStatusId')
  int? approvedStatusId;
  @JsonKey(name: 'approvedStatusName')
  String? approvedStatusName;
  @JsonKey(name: 'approvedStatusHindiName')
  String? approvedStatusHindiName;
  @JsonKey(name: 'approvedStatusCount')
  int? approvedStatusCount;

  @JsonKey(name: 'draftedStatusId')
  int? draftedStatusId;
  @JsonKey(name: 'draftedStatusName')
  String? draftedStatusName;
  @JsonKey(name: 'draftedStatusHindiName')
  String? draftedStatusHindiName;
  @JsonKey(name: 'draftedStatusCount')
  int? draftedStatusCount;

  @JsonKey(name: 'submittedStatusId')
  int? submittedStatusId;
  @JsonKey(name: 'submittedStatusName')
  String? submittedStatusName;
  @JsonKey(name: 'submittedStatusHindiName')
  String? submittedStatusHindiName;
  @JsonKey(name: 'submittedStatusCount')
  int? submittedStatusCount;

  StatusData({
    this.allStatusId,
    this.allStatusName,
    this.allStatusHindiName,
    this.allStatusCount,
    this.publishedStatusId,
    this.publishedStatusName,
    this.publishedStatusHindiName,
    this.publishedStatusCount,
    this.approvedStatusId,
    this.approvedStatusName,
    this.approvedStatusHindiName,
    this.approvedStatusCount,
    this.draftedStatusId,
    this.draftedStatusName,
    this.draftedStatusHindiName,
    this.draftedStatusCount,
    this.submittedStatusId,
    this.submittedStatusName,
    this.submittedStatusHindiName,
    this.submittedStatusCount,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) => StatusData(
        allStatusId: json["allStatusId"],
        allStatusName: json["allStatusName"],
        allStatusHindiName: json["allStatusHindiName"],
        allStatusCount: json["allStatusCount"],
        publishedStatusId: json["publishedStatusId"],
        publishedStatusName: json["publishedStatusName"],
        publishedStatusHindiName: json["publishedStatusHindiName"],
        publishedStatusCount: json["publishedStatusCount"],
        approvedStatusId: json["approvedStatusId"],
        approvedStatusName: json["approvedStatusName"],
        approvedStatusHindiName: json["approvedStatusHindiName"],
        approvedStatusCount: json["approvedStatusCount"],
        draftedStatusId: json["draftedStatusId"],
        draftedStatusName: json["draftedStatusName"],
        draftedStatusHindiName: json["draftedStatusHindiName"],
        draftedStatusCount: json["draftedStatusCount"],
        submittedStatusId: json["submittedStatusId"],
        submittedStatusName: json["submittedStatusName"],
        submittedStatusHindiName: json["submittedStatusHindiName"],
        submittedStatusCount: json["submittedStatusCount"],
      );

  Map<String, dynamic> toJson() => {
        "allStatusId": allStatusId,
        "allStatusName": allStatusName,
        "allStatusHindiName": allStatusHindiName,
        "allStatusCount": allStatusCount,
        "publishedStatusId": publishedStatusId,
        "publishedStatusName": publishedStatusName,
        "publishedStatusHindiName": publishedStatusHindiName,
        "publishedStatusCount": publishedStatusCount,
        "approvedStatusId": approvedStatusId,
        "approvedStatusName": approvedStatusName,
        "approvedStatusHindiName": approvedStatusHindiName,
        "approvedStatusCount": approvedStatusCount,
        "draftedStatusId": draftedStatusId,
        "draftedStatusName": draftedStatusName,
        "draftedStatusHindiName": draftedStatusHindiName,
        "draftedStatusCount": draftedStatusCount,
        "submittedStatusId": submittedStatusId,
        "submittedStatusName": submittedStatusName,
        "submittedStatusHindiName": submittedStatusHindiName,
        "submittedStatusCount": submittedStatusCount,
      };
}
