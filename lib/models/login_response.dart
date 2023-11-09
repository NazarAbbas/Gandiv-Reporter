import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'status')
  int? status;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  LoginData? loginData;

  LoginResponse({
    this.status,
    this.message,
    this.loginData,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        message: json["message"],
        loginData: LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": loginData?.toJson(),
      };
}

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final dynamic title;
  @JsonKey(name: 'firstName')
  final String firstName;
  @JsonKey(name: 'lastName')
  final String lastName;
  @JsonKey(name: 'mobileNo')
  final dynamic mobileNo;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'gender')
  final dynamic gender;
  @JsonKey(name: 'profileImage')
  final dynamic profileImage;
  @JsonKey(name: 'role')
  final String role;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'isChangePassword')
  final bool isChangePassword;

  LoginData({
    required this.id,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.email,
    required this.gender,
    required this.profileImage,
    required this.role,
    required this.token,
    required this.isChangePassword,
  });

  factory LoginData.fromRawJson(String str) =>
      LoginData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        title: json["title"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        gender: json["gender"],
        profileImage: json["profileImage"],
        role: json["role"],
        token: json["token"],
        isChangePassword: json["isChangePassword"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "firstName": firstName,
        "lastName": lastName,
        "mobileNo": mobileNo,
        "email": email,
        "gender": gender,
        "profileImage": profileImage,
        "role": role,
        "token": token,
        "isChangePassword": isChangePassword,
      };
}
