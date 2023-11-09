import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonSerializable()
class DeleteNewsResponse {
  @JsonKey(name: 'status')
  final int status;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'data')
  final String aboutUsData;

  DeleteNewsResponse({
    required this.status,
    required this.message,
    required this.aboutUsData,
  });

  factory DeleteNewsResponse.fromRawJson(String str) =>
      DeleteNewsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteNewsResponse.fromJson(Map<String, dynamic> json) =>
      DeleteNewsResponse(
        status: json["status"],
        message: json["message"],
        aboutUsData: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": aboutUsData,
      };
}
