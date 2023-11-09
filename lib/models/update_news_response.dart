import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

class UpdateNewsResponse {
  @JsonKey(name: 'status')
  int status;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'data')
  String? data;

  UpdateNewsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory UpdateNewsResponse.fromRawJson(String str) =>
      UpdateNewsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateNewsResponse.fromJson(Map<String, dynamic> json) =>
      UpdateNewsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
