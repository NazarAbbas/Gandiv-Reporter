import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gandiv/models/categories_response.dart';
import 'package:gandiv/models/change_password_request.dart';
import 'package:gandiv/models/change_password_response.dart';
import 'package:gandiv/models/forgot_password_response.dart';
import 'package:gandiv/models/locations_response.dart';
import 'package:gandiv/models/login_request.dart';
import 'package:gandiv/models/login_response.dart';
import 'package:gandiv/models/news_delete_response.dart';
import 'package:gandiv/models/news_list_response.dart';
import 'package:gandiv/models/profile_response.dart';
import 'package:gandiv/models/status_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import '../models/about_us_response.dart';
import '../models/create_news_response.dart';
import '../models/news_gallery_response.dart';
import '../models/signup_request.dart';
import '../models/signup_response.dart';
import '../models/update_news_response.dart';
import '../models/update_profile_response.dart';
import '../models/verify_response.dart';

part 'rest_client.g.dart';

class Apis {
  static const String signup = '/accounts/register';
  static const String login = '/accounts/login';
  static const String verify = '/accounts/verify/{code}';
  static const String forgotPassword = '/accounts/forgot-password';
  static const String aboutUs = '/Gandiv/aboutus';
  static const String ePaper = '/Gandiv/epaper';
  static const String newsList = '/news';
  static const String newsStatus = '/news/count';
  static const String newsGalleryList = '/news/gallery-new';

  static const String newsCategories = '/news/categories';
  static const String newsLocations = '/news/locations';
  static const String createNews = '/news/create';
  static const String updateProfile = '/users/profile';
  static const String getProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String deleteNews = '/news/delete/{id}';
  static const String updateNews = '/news/update';
}

@RestApi(baseUrl: "https://api.gandivsamachar.com/api")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // @GET("/users")
  // Future<List<NewsList>> getUsers();

  @POST(Apis.signup)
  Future<SignupResponse> signupApi(@Body() SignupRequest signupRequest);

  @POST(Apis.login)
  Future<LoginResponse> loginApi(@Body() LoginRequest loginRequest);

  @GET(Apis.aboutUs)
  Future<AboutUsResponse> aboutusApi();

  @MultiPart()
  @POST(Apis.createNews)
  Future<CreateNewsResponse> createNewsApi(
      {@required @Header('Authorization') String? token,
      @required @Part(name: 'Heading') String? heading,
      @required @Part(name: 'SubHeading') String? subHeading,
      @required @Part(name: 'NewsContent') String? newsContent,
      @required @Part(name: 'LocationId') String? locationId,
      @required @Part(name: 'Status') String? status,
      @required @Part(name: 'LanguageId') String? languageId,
      @required @Part(name: 'DurationInMin') String? durationInMin,
      @required @Part(name: 'NewsTypeId') int? newsTypeId,
      @required @Part(name: 'CategoryIds') List<String>? categoryId,
      @required @Part(name: 'MediaFiles') List<File>? files});

  @MultiPart()
  @PUT(Apis.updateNews)
  Future<UpdateNewsResponse> updateNewsApi(
      {@required @Header('Authorization') String? token,
      @required @Part(name: 'Id') String? id,
      @required @Part(name: 'Heading') String? heading,
      @required @Part(name: 'SubHeading') String? subHeading,
      @required @Part(name: 'NewsContent') String? newsContent,
      @required @Part(name: 'LocationId') String? locationId,
      @required @Part(name: 'Status') String? status,
      @required @Part(name: 'LanguageId') String? languageId,
      @required @Part(name: 'DurationInMin') String? durationInMin,
      @required @Part(name: 'newsType') String? newsType,
      @required @Part(name: 'NewsTypeId') int? newsTypeId,
      @required @Part(name: 'CategoryIds') List<String>? categoryId,
      @required @Part(name: 'MediaFiles') List<File>? files,
      @required @Part(name: 'DeleteFiles') List<String>? deleteFiles});

  @MultiPart()
  @PUT(Apis.updateProfile)
  Future<UpdateProfilleResponse> updateProfileApi(
      {@required @Header('Authorization') String? token,
      @required @Part(name: 'FirstName') String? firstName,
      @required @Part(name: 'LastName') String? lastName,
      @required @Part(name: 'MobileNo') String? mobileNo,
      @required @Part(name: 'File') File? file});

  @PUT(Apis.verify)
  Future<VerifyResponse> verifyApi(@Path("code") String code);

  @DELETE(Apis.deleteNews)
  Future<DeleteNewsResponse> deleteNewsApi(
      @Header('Authorization') String? token, @Path("id") String id);

  @PUT(Apis.changePassword)
  Future<ChangePasswordResponse> changePasswordApi(
      @Header('Authorization') String? token,
      @Body() ChangePasswordRequest changePasswordRequest);

  @GET(Apis.getProfile)
  Future<ProfileResponse> profileApi(@Header('Authorization') String? token);

  @PUT(Apis.forgotPassword)
  Future<VerifyResponse> forgotPasswordApi(
      @Query("username") String userName, @Query("password") String password);

  @GET(Apis.newsCategories)
  Future<CategoriesResponse> newsCategoryApi();

  @GET(Apis.newsLocations)
  Future<LocationsResponse> newsLocationsApi();

  @GET(Apis.newsList)
  Future<NewsListResponse> newsListApi(
      [@Query("CategoryId") String? categoryId,
      @Query("LocationId") String? locationId,
      @Query("LanguageId") int? laguageId,
      @Query("PageSize") int? pageSize,
      @Query("PageNumber") int? pageNumber,
      @Query("SearchText") String? searchText]);

  @GET(Apis.newsStatus)
  Future<StatusResponse> statusApi([
    @Header('Authorization') String? token,
    @Query("StartDate") String? fromDate,
    @Query("EndDate") String? toDate,
    @Query("CategoryId") String? categoryId,
  ]);

  @GET(Apis.newsGalleryList)
  Future<NewsGalleryResponse> newsGalleryListApi(
      @Header('Authorization') String? token,
      [@Query("CategoryId") String? categoryId,
      @Query("LocationId") String? locationId,
      @Query("PageSize") int? pageSize,
      @Query("PageNumber") int? pageNumber,
      @Query("StartDate") String? startDate,
      @Query("EndDate") String? endDate,
      @Query("StatusId") int? statusId,
      @Query("SearchText") String? searchText]);

  @PUT(Apis.forgotPassword)
  Future<ForgotPasswordResponse> forgotPassword([
    @Query("username") String? username,
  ]);
}
